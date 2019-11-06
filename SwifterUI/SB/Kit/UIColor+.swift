//
//  UIColor+RGBA.swift
//  apc
//
//  Created by ovfun on 16/3/15.
//  Copyright © 2016年 @天意. All rights reserved.
//

import Foundation

extension UIColor {
    
    public static func RGBA (_ r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) ->UIColor{
        
        return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    

    /// 十六进制初始化
    ///
    /// - Parameters:
    ///   - hex: 十六进制色值
    ///   - transparency: 透明度 0 ~ 1
    public convenience init(hex: Int, transparency: CGFloat = 1) {
        var trans: CGFloat {
            if transparency > 1 {
                return 1
            } else if transparency < 0 {
                return 0
            } else {
                return transparency
            }
        }
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff, transparency: trans)
    }
    
    /// SwifterSwift: Create Color from hexadecimal string with optional transparency (if applicable).
    ///
    /// - Parameters:
    ///   - hexString: hexadecimal string (examples: EDE7F6, 0xEDE7F6, #EDE7F6, #0ff, 0xF0F, ..).
    ///   - transparency: optional transparency value (default is 1).
    public convenience init?(hexString: String?, transparency: CGFloat = 1) {
        guard let hex = hexString else {return nil}
        var string = ""
        if hex.lowercased().hasPrefix("0x") {
            string =  hex.replacingOccurrences(of: "0x", with: "")
        } else if hex.hasPrefix("#") {
            string = hex.replacingOccurrences(of: "#", with: "")
        } else {
            string = hex
        }
        
        if string.count == 3 { // convert hex to 6 digit format if in short format
            var str = ""
            string.forEach { str.append(String(repeating: String($0), count: 2)) }
            string = str
        }
        
        guard let hexValue = Int(string, radix: 16) else { return nil }
        
        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
        
        let red = (hexValue >> 16) & 0xff
        let green = (hexValue >> 8) & 0xff
        let blue = hexValue & 0xff
        self.init(red: red, green: green, blue: blue, transparency: trans)
    }

    /// rgba初始化
    ///
    /// - Parameters:
    ///   - red: 0 ~ 255 之间
    ///   - green: 0 ~ 255 之间
    ///   - blue: 0 ~ 255 之间
    ///   - transparency: 透明度 0 ~ 1
    public convenience init(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        var trans: CGFloat {
            if transparency > 1 {
                return 1
            } else if transparency < 0 {
                return 0
            } else {
                return transparency
            }
        }
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
    }
    
    public static var random: UIColor {
        let r = Int(arc4random_uniform(255))
        let g = Int(arc4random_uniform(255))
        let b = Int(arc4random_uniform(255))
        return UIColor(red: r, green: g, blue: b)
    }
    
    
    /// 十六进制字符串
    public var hexString: String {
        var red:	CGFloat = 0
        var green:	CGFloat = 0
        var blue:	CGFloat = 0
        var alpha:	CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgb: Int = (Int)(red*255)<<16 | (Int)(green*255)<<8 | (Int)(blue*255)<<0
        return NSString(format:"#%06x", rgb).uppercased as String
    }
    
    public var alpha: CGFloat {
        var a: CGFloat = 0
        getRed(nil, green: nil, blue: nil, alpha: &a)
        return a
    }
}
