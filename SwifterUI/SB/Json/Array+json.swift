//
//  Array+json.swift
//  apc
//
//  Created by uke on 2019/3/20.
//  Copyright © 2019 @天意. All rights reserved.
//

import Foundation

extension Array {
    
    public var json: String? {
        
        guard let d = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted) else {return nil}
        return String(data: d, encoding: .utf8)
    }
    
    public var data: Data? {
        
        return try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
    }
}
