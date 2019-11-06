//
//  String+json.swift
//  apc
//
//  Created by uke on 2019/3/20.
//  Copyright © 2019 @天意. All rights reserved.
//

import Foundation

extension String {
    
    public var toJson: Json? {
        
        return self.data(using: .utf8)?.toJson
    }
}
