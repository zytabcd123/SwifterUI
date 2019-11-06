//
//  Dictionary+json.swift
//  apc
//
//  Created by uke on 2019/3/20.
//  Copyright © 2019 @天意. All rights reserved.
//

import Foundation

extension Dictionary {
    
    public var json: String? {
        
        guard count > 0 else {return nil}
        do {
            let d = try JSONSerialization.data(withJSONObject: self, options:.prettyPrinted)
            return String(decoding: d, as: UTF8.self)
        } catch {
            print("解析错误")
            return nil
        }
        
    }
}
