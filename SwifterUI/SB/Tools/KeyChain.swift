//
//  KeyChain.swift
//  apc
//
//  Created by ovfun on 16/3/24.
//  Copyright © 2016年 @天意. All rights reserved.
//

import Foundation

private func bundleID() -> String {
    
    guard let s = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String else {
        
        assert(true, "bundleID为空")
        return ""
    }
    return s
}

public enum Serivice: String {
    
    case Nmae, Password, UUID
}

private enum Action {
    
    case insert, fetch, delete
}

///保存账号密码和uuid
public struct KeyChain {

    static public func save(_ username: String,andPassword pwd: String) {

        Action.insert.action(username, serivice: .Nmae)
        Action.insert.action(pwd, serivice: .Password)
    }
    
    static public func getUsername() -> String? {
        
        return Action.fetch.action(serivice: .Nmae).1
    }
    
    static public func getPassword() -> String? {
        
        return Action.fetch.action(serivice: .Password).1
    }
    
    static public func getUUID() -> String {
        
        if let uuid = Action.fetch.action(serivice: .UUID).1 {
            
            return uuid
        }
        
        let u = CFUUIDCreate(kCFAllocatorDefault)
        let uuid = CFUUIDCreateString(kCFAllocatorDefault, u) as String
        Action.insert.action(uuid, serivice: .UUID)
        return uuid
    }
    
    @discardableResult
    static public func delete(_ valueSerivice: Serivice) -> Bool {
        
        return Action.delete.action(serivice: valueSerivice).0 == errSecSuccess
    }
    
    @discardableResult
    static public func cleanAll()  -> Bool {

        return KeyChain.delete(.Nmae) || KeyChain.delete(.Password) || KeyChain.delete(.UUID)
    }
}


extension Serivice {
    
    
    var des: String {
        
        return bundleID() + "." + self.rawValue
    }
    
    var params: [String : AnyObject] {
        
        return [
            kSecAttrAccount as String: self.des as AnyObject
            ,kSecAttrService as String : self.des as AnyObject
            ,kSecClass as String : kSecClassGenericPassword
//                ,kSecAttrAccessible as String : kSecAttrAccessibleAfterFirstUnlock
        ]
    }
}

extension Action {
    
    @discardableResult
    func action(_ value: String = "",serivice: Serivice) -> (OSStatus, String?) {
        
        var returnValue: String? = nil
        var status = SecItemCopyMatching(serivice.params as CFDictionary, nil)
        
        switch self {
        case .insert:
            
            let valurData = value.data(using: String.Encoding.utf8)
            var attributes = [String : AnyObject]()
            
            switch status {
            case errSecSuccess:
                
                attributes[kSecValueData as String] = valurData as AnyObject?
                status = SecItemUpdate(serivice.params as CFDictionary, attributes as CFDictionary)
            case errSecItemNotFound:
                
                var query = serivice.params
                query[kSecValueData as String] = valurData as AnyObject?
                status = SecItemAdd(query as CFDictionary, nil)
            default: break
            }
        case .fetch:
            
            var query = serivice.params
            query[kSecReturnData as String] = true as AnyObject?
            query[kSecMatchLimit as String] = kSecMatchLimitOne
            
            var result: CFTypeRef?
            status = SecItemCopyMatching(query as CFDictionary, &result)
            
            if let r = result as? Data,
               let v = String(data: r, encoding: String.Encoding.utf8) {
                returnValue = v
            }
        case .delete:
            
            status = SecItemDelete(serivice.params as CFDictionary)
        }
        
        return (status, returnValue)
    }
}
