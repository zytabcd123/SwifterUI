//
//  Cache.swift
//  SwifterUI
//
//  Created by uke on 2019/11/6.
//  Copyright © 2019 uke. All rights reserved.
//

import Foundation

class Cache<KeyType : AnyObjectCastable, ValueType : AnyObjectCastable> {
    
    private let _cache = NSCache<KeyType.ObjectType, ValueType.ObjectType>()
    
    subscript(key: KeyType) -> ValueType? {
        get {
            return _cache.object(forKey: key as! KeyType.ObjectType) as? ValueType
        }
        set {
            switch newValue {
            case let object as ValueType.ObjectType:
                _cache.setObject(object, forKey: key as! KeyType.ObjectType)
            default:
                _cache.removeObject(forKey: key as! KeyType.ObjectType)
            }
        }
    }
}


protocol AnyObjectCastable {
    associatedtype ObjectType: AnyObject
}

extension URL: AnyObjectCastable {
    typealias ObjectType = NSURL
}

extension Data: AnyObjectCastable {
    typealias ObjectType = NSData
}
