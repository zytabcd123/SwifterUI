//
//  Date+.swift
//  secret
//
//  Created by mc on 2017/7/20.
//  Copyright © 2017年 mc. All rights reserved.
//

import Foundation

extension Date {
    
    public var expire: TimeInterval {
        
        return timeIntervalSince1970 - Date(timeIntervalSinceNow: 0).timeIntervalSince1970
    }
    
    public var isThisYear: Bool {
        
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: Calendar.Component.year)
    }
    
    public var age: Int {
        let d = DateFormatter()
        d.dateFormat = "yyyy-MM-dd"
        guard let t = d.date(from: d.string(from: self))?.timeIntervalSinceNow else {return 0}
        let a = trunc(t / (60 * 60 * 24)) / 365
        return abs(Int(a))
    }
}

extension TimeInterval {
    
    public var isThisYear: Bool {
        
        return Date(timeIntervalSince1970: self).isThisYear
    }
    
    public var isExpire: Bool {
        
        return expire <= 0
    }
    
    public var expire: TimeInterval {
        
        return self - D.currentTimeInterval()
    }
    
    public func expire(duration: Double) -> TimeInterval {
        
        return D.currentTimeInterval() + duration
    }
    
    
    /// 00:00不够小时的省略小时
    public var formatReciprocal: String {
        
        guard self > 0 else {return "00:00"}
        let t = Int(self)
        let h = (t / 60 / 60)
        let m = (t / 60) % 60
        let s = t % 60
        let hs = h >= 10 ? "\(h)" : "0\(h)"
        let ms = (m) >= 10 ? "\(m)" : "0\(m)"
        let ss = (s) >= 10 ? "\(s)" : "0\(s)"
        
        return h > 0 ? "\(hs):\(ms):\(ss)" : "\(ms):\(ss)"
    }
    
    /// 00时00分00秒
    public var formatReciprocalStyle1: String {
        
        guard self > 0 else {return "00分00秒"}
        let t = Int(self)
        let h = (t / 60 / 60)
        let m = (t / 60) % 60
        let s = t % 60
        let hs = h >= 10 ? "\(h)" : "0\(h)"
        let ms = (m) >= 10 ? "\(m)" : "0\(m)"
        let ss = (s) >= 10 ? "\(s)" : "0\(s)"
        
        return h > 0 ? "\(hs)时\(ms)分\(ss)秒" : "\(ms)分\(ss)秒"
    }
    
    
    /// 00:00:00
    public var formatReciprocalStyle2: String {
        
        guard self > 0 else {return "00:00:00"}
        let t = Int(self)
        let h = (t / 60 / 60)
        let m = (t / 60) % 60
        let s = t % 60
        let hs = h >= 10 ? "\(h)" : "0\(h)"
        let ms = (m) >= 10 ? "\(m)" : "0\(m)"
        let ss = (s) >= 10 ? "\(s)" : "0\(s)"
        
        return "\(hs):\(ms):\(ss)"
    }
}

extension Date {
    
    public static func date(_ string: String?) -> Date? {
        
        guard let s = string else {return nil}
        let d = DateFormatter()
        return d.possibleDateFromString(s)
    }
}
fileprivate extension DateFormatter {
    func possibleDateFromString(_ string: String) -> Date? {
        let dateFormats = ["YYYY-MM-dd HH:mm:ss.SSS","YYYY-MM-dd", "YYYY-MM-dd HH:mm:ss"]
        return dateFormats
            .compactMap { dateFromString(string, format: $0) }
            .first
    }
    
    func dateFromString(_ string: String, format: String) -> Date? {
        dateFormat = format
        return date(from: string)
    }
}
