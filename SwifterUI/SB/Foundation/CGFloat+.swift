//
//  CGFloat+转化.swift
//  apc
//
//  Created by ovfun on 16/6/2.
//  Copyright © 2016年 @天意. All rights reserved.
//

import Foundation

extension CGFloat {

    public var center: CGFloat { return (self / 2) }
    
    public func toRadians() -> CGFloat {
        return (CGFloat (Double.pi) * self) / 180.0
    }
    
    public func degreesToRadians() -> CGFloat {
        return toRadians()
    }
    
    public mutating func toRadiansInPlace() {
        self = (CGFloat (Double.pi) * self) / 180.0
    }
    
    public func degreesToRadians (_ angle: CGFloat) -> CGFloat {
        return (CGFloat (Double.pi) * angle) / 180.0
    }
}

extension Double {
    
    public func formatDouble() -> String {
        
//        if self < 1000 {
//
//            let m = NSString(format: "%0.1f", self) as String
//            return "\(m)m"
//        }else{
//
            let m = NSString(format: "%0.2f", self) as String
            return "\(m)km"
//        }
    }
    
    public func formatDoubleWithoutUnion() -> String {
        return NSString(format: "%0.2f", self) as String
    }
}
