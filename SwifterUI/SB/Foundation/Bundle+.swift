//
//  Bundle+.swift
//  secret
//
//  Created by mc on 2017/7/19.
//  Copyright © 2017年 mc. All rights reserved.
//

import Foundation

public protocol IsInBundle {
    
    static var bundle: Bundle { get }
}

public extension IsInBundle where Self: AnyObject {
    
    static var bundle: Bundle {
        return Bundle(for: Self.self)
    }
}
