//
//  ZHDate.swift
//  niuzhi
//
//  Created by ovfun on 15/10/28.
//  Copyright © 2015年 ovfun. All rights reserved.
//

import Foundation

private protocol Formatterable {
    
    var formatter: DateFormatter {get}
}

private enum SmartTime {
    
    case none(String?)
    case minutes(String?)
    case second(String?)
    case hours(String?)
    case days(String?)
    
    init(time: TimeInterval) {
        
        let dif = D.currentTimeInterval() - time
        if dif <= 3600 {
            self = .hours(D.timeFormat(time, style: .hh_mm))
//            if dif <= 0 { self = .none(D.timeFormat(time, style: .yyyy_MM_dd_HH_mm_ss)) }
//            else if dif <= 60 { self = .minutes(LS.time_just) }
//            else if dif <= 3600 { self = .second("\(Int(dif / 60)) " + LS.time_mins) }
//            else { self = .none(D.timeFormat(time, style: .yyyy_MM_dd_HH_mm_ss)) }
        }else {
            
            guard let today = D.timeIntervalFormat(Date(), style: .yyyy_MM_dd),
                let taget = D.timeIntervalFormat(time, style: .yyyy_MM_dd) else {
                    
                    self = .none(D.timeFormat(time, style: .yyyy_MM_dd_HH_mm_ss))
                    return
            }
            switch today - taget {
            case 0: self = .hours(D.timeFormat(time, style: .hh_mm))
            case 86400 * 1: self = .days(D.timeFormat(time, style: .hh_mm).flatMap({ "昨天" + " \($0)"}))
            case 86400 * 2, 86400 * 3, 86400 * 4, 86400 * 5, 86400 * 6, 86400 * 7: self = .days(D.timeFormat(time, style: .eeee_HH_mm))
            default: self = .days(D.timeFormat(time, style: .yyyy_MM_dd))
//                self = time.isThisYear ? .days(D.timeFormat(time, style: .MM_dd_HH_mm))
//                                            : .days(D.timeFormat(time, style: .yyyy_MM_dd))
            }
        }
    }
    
    var des: String? {
        switch self {
        case .none(let s): return s
        case .minutes(let s): return s
        case .second(let s): return s
        case .hours(let s): return s
        case .days(let s): return s
        }
    }
}

///时间处理
public struct D {
    
    public enum FormateStyle: Formatterable {
        
        case hh_mm
        case eeee_HH_mm
        case MM_dd_HH_mm
        case yyyy_MM_dd
        case yyyy_MM_dd_EEEE
        case yyyy_MM_dd_HH_mm_ss
        
        var formatter: DateFormatter {
            
            let dateFormat : DateFormatter = DateFormatter()
            dateFormat.locale = Locale.current
//            dateFormat.locale = NSLocale(localeIdentifier: "zh_CN") as Locale!
            switch self {
                
            case .eeee_HH_mm:
                dateFormat.dateFormat = "EEEE HH:mm"
            case .MM_dd_HH_mm:
                dateFormat.dateFormat = "MM-dd HH:mm"
            case .hh_mm:
                dateFormat.dateFormat = "HH:mm"
            case .yyyy_MM_dd:
                dateFormat.dateFormat = "yyyy-MM-dd"
            case .yyyy_MM_dd_EEEE:
                dateFormat.dateFormat = "yyyy-MM-dd EEEE"
            case .yyyy_MM_dd_HH_mm_ss:
                dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            }
            return dateFormat
        }
    }
    
    public enum SmartStyle {
        case im
        case list
        
        func getSmartTime(_ time: TimeInterval) -> String? {
            
            switch self {
            case .im: return SmartTime(time: time).des
            case .list:
                switch SmartTime(time: time) {
                case .none(let s): return s
                case .minutes, .second, .hours: return D.timeFormat(time, style: .hh_mm)
                default: return D.timeFormat(time, style: .yyyy_MM_dd)
                }
            }
        }
    }
}


extension D {
    
    ///NSDate、字符串、时间戳格式化成字符串
    public static func timeFormat<T>(_ date: T?, style: FormateStyle) -> String? {
        
        if let t = date as? String, let d = D.FormateStyle.yyyy_MM_dd_HH_mm_ss.formatter.date(from: t) {//时间格式“2015-12-24 12：00：00”
            
            return style.formatter.string(from: d)
        }
        
        if let t = date as? Double, t > 0 {//时间戳格式
            
            let d = Date(timeIntervalSince1970: t)
            return style.formatter.string(from: d)
        }
        
        if let d = date as? Date {//NSDate格式
            
            return style.formatter.string(from: d)
        }
        
        return nil
    }
    
    
    /// 时间戳格式化
    ///
    /// - Parameters:
    ///   - date: 需要格式化的时间可以是Date，Double，String 类型时间
    ///   - style: 格式化样式
    /// - Returns: 时间戳
    public static func timeIntervalFormat<T>(_ date: T?, style: FormateStyle) -> TimeInterval? {
        
        let d = D.timeFormat(date, style: style)
        return D.timeInterval(time: d, style: style)
    }
    
    ///字符串时间转时间戳
    public static func timeInterval(time: String?, style: FormateStyle) -> TimeInterval? {
        
        guard let t = time else { return nil }
        guard let d = style.formatter.date(from: t) else { return nil }
        
        return d.timeIntervalSince1970
    }
    
    ///格式化当前时间，style传入需要格式化的类型
    public static func currentTime(_ style: FormateStyle) -> String? {
        
        return style.formatter.string(from: Date())
    }
    
    ///获取当前时间戳
    public static func currentTimeInterval() -> TimeInterval {
        
        return Date(timeIntervalSinceNow: 0).timeIntervalSince1970
    }
    
    public static func currentTimeIntervalLong() -> Int {
        
        return Int(Date(timeIntervalSinceNow: 0).timeIntervalSince1970 * 1000)
    }
    
    
    public static func timeSmartFormat<T>(_ time: T?, style: SmartStyle = .im) -> String? {
        
        if time == nil { return nil }
        
        var timeInterval: TimeInterval = 0
        if let t = time as? String {//时间格式“2015-12-24 12：00：00”
            if let d = D.timeInterval(time: t, style: D.FormateStyle.yyyy_MM_dd_HH_mm_ss) {
                timeInterval = d
            }
        }
        if let t = time as? Double {//时间戳格式
            timeInterval = t
        }
        if let d = time as? Date {//NSDate格式
            timeInterval = d.timeIntervalSince1970
        }
        
        return style.getSmartTime(timeInterval)
    }
    
    public static func timeActivityFormat<T>(_ time: T?) -> (String?, Bool) {
        
        if time == nil { return (nil, false) }
        
        var timeInterval: TimeInterval = 0
        if let t = time as? String {//时间格式“2015-12-24 12：00：00”
            if let d = D.timeInterval(time: t, style: D.FormateStyle.yyyy_MM_dd_HH_mm_ss) {
                timeInterval = d
            }
        }
        if let t = time as? Double {//时间戳格式
            timeInterval = t
        }
        if let d = time as? Date {//NSDate格式
            timeInterval = d.timeIntervalSince1970
        }
        
        let dif = Int(D.currentTimeInterval() - timeInterval)
        let activity = dif <= 5 * 60
        if dif < 86400 {
            switch dif {
            case 0...60: return ("\(dif) 秒前", activity)
            case 61...3600: return ("\(Int(dif / 60)) 分钟前", activity)
            case 3601...86400: return ("\(Int(dif / 3600)) 小时前", activity)
            default: return ("", activity)
            }
        }else {
            guard let today = D.timeIntervalFormat(Date(), style: .yyyy_MM_dd),
                  let taget = D.timeIntervalFormat(timeInterval, style: .yyyy_MM_dd) else { return (nil, false) }
            let ddif = Int(today - taget)
            switch ddif {
            case 86400 * 1: return ("昨天", activity)
            case 86400 * 2: return ("前天", activity)
            case 86400 * 3: return ("3 天前", activity)
            case 86400 * 4: return ("4 天前", activity)
            case 86400 * 5: return ("5 天前", activity)
            case 86400 * 6: return ("6 天前", activity)
            default: return ("7 天前", activity)
            }
        }
    }
}
