//
//  Number+.swift
//  apc
//
//  Created by uke on 2018/12/10.
//  Copyright © 2018 uke. All rights reserved.
//

import Foundation

extension Int {
    
    
    /// 大于10000的数字格式化，除以10000后直接截断，不四舍五入
    ///
    /// - Parameters:
    ///   - digit: 保留几位小数
    ///   - unit: 单位
    public func format(_ digit: Int = 1, unit: String = "万") -> String? {
        
        guard self >= 10000 else { return "\(self)"}
        
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = digit
        numberFormatter.minimumFractionDigits = digit
        numberFormatter.numberStyle = .decimal
        numberFormatter.roundingMode = .floor
        
        let i = Float(self) / Float(10000)
        return numberFormatter.string(from: NSNumber(value: i )).flatMap({ $0 + unit })
    }
}

extension Double {
    
    /// 大于10000的数字格式化，除以10000后直接截断，不四舍五入
    ///
    /// - Parameters:
    ///   - digit: 保留几位小数
    ///   - unit: 单位
    public func format(_ digit: Int = 1, unit: String = "万") -> String? {

        guard self >= 10000 else { return "\(self)"}
        
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = digit
        numberFormatter.minimumFractionDigits = digit
        numberFormatter.numberStyle = .decimal
        numberFormatter.roundingMode = .floor
        
        let i = Float(self) / Float(10000)
        return numberFormatter.string(from: NSNumber(value: i )).flatMap({ $0 + unit })
    }
}

extension Float {
    
    public func rmb() -> String? {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.numberStyle = .currency
        numberFormatter.roundingMode = .floor// 舍入方式
        numberFormatter.currencySymbol = "￥"
        return numberFormatter.string(from: NSNumber(value: self))
    }
}
