//
//  Data+.swift
//  ArtExamination
//
//  Created by ovfun on 2017/6/8.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

import Foundation

extension Data {
    
    public var toString : String? {
        guard count > 0 else {return nil}
        return String(decoding: self, as: UTF8.self)
    }
}
