//
//  Color+.swift
//  SwifterUI
//
//  Created by uke on 2019/7/17.
//  Copyright © 2019 uke. All rights reserved.
//

import Foundation
import SwiftUI

@available(iOS 13.0.0, *)
public extension Color {
    
    init(_ r: Int, g: Int, b: Int, a: Double) {
        self = Color(Color.RGBColorSpace.sRGB,
                     red: Double(r) / 255.0,
                     green: Double(g) / 255.0,
                     blue: Double(b) / 255.0,
                     opacity: min(1, max(0, a)))
    }
    
    /// 十六进制初始化
    ///
    /// - Parameters:
    ///   - hex: 十六进制色值
    ///   - transparency: 透明度 0 ~ 1
    init(_ hex: Int, transparency: Double = 1) {
        self = Color((hex >> 16) & 0xff,
                     g: (hex >> 8) & 0xff,
                     b: hex & 0xff,
                     a: transparency)
    }
    
    
    init(_ color: UIColor) {
        let ci = CIColor(color: color)
        self = Color(.sRGB,
                     red: Double(ci.red),
                     green: Double(ci.green),
                     blue: Double(ci.blue),
                     opacity: Double(ci.alpha))
    }
}

@available(iOS 13.0.0, *)
public extension Color {
    
    static var random: Color {
        let r = Int(arc4random_uniform(255))
        let g = Int(arc4random_uniform(255))
        let b = Int(arc4random_uniform(255))
        return Color(r, g: g, b: b, a: 1)
    }
}
