//
//  JSONParser.swift
//  Education
//
//  Created by luojie on 16/3/11.
//  Copyright © 2016年 牛至网. All rights reserved.
//

import Foundation
/**
 提供 JSON 简易转化功能，是从 CaesarParser 提取，
用法：

 ```swift

static func parse(dic: [String : AnyObject]) -> CourseModel {
    
    var m = CourseModel()
    
    m.name <-- dic["name"]
    m.overView <-- dic["title"]
    m.id <-- dic["id"]
    m.type <-- dic["subject"]
    m.studentsNum <-- dic["orderNum"]
    m.courseNum <-- dic["lessionNum"]
    m.favNum <-- dic["favNum"]
    m.score <-- dic["grade"]
    m.price <-- dic["sourcePrice"]
    m.photo <-- dic["img"]
    m.des <-- dic["context"]
    m.teacher <-- dic["teacher"]
    m.school <-- dic["school"]

    return m
}

```
支持解析的数据类型为:
    Int, String, Double, Float, Bool, NSURL, NSDate, ModelParseable, RawRepresentable

以及以上类型的数组:
   [Int],  [String],  [Double]   ..... [ModelParseable],  [RawRepresentable]

以及以上类型的 Optional:
    Int?,   String?,   Double?   .....  ModelParseable?,   RawRepresentable?,
   [Int]?, [String]?, [Double]?  ..... [ModelParseable]?, [RawRepresentable]?


需解析的数据类型大致可分为三类:    
    1. JSON 属性类(类似于 Core Data 中的 Property)，如： Int, String, Double, Float, Bool, NSURL, NSDate
    2. JSON 关系类(类似于 Core Data 中的 Relationship)，如：ModelParseable, [ModelParseable]
    3. JSON 枚举属性类, 该类需执行 RawRepresentable 协议，并且 rawValue 是 JSON 属性类其中的一种，例如: enum PlayStatus: Int { case UnPlay, Playing, Played }

下面一个例子演示了 JSON 属性类，JSON 关系类，和 JSON 枚举属性类的解析方法:
 ```swift

enum PlayStatus: Int {
    case UnPlay, Playing, Played
}

struct CourseModel: ModelParseable {

     // JSON 属性类
    var id: Int?
    var name: String?
    var photo: NSURL?

    // JSON 关系类
    var teacher: TeacherModel?
    var schools: [SchoolModel]()

     // JSON 枚举属性类
    var playStatus = PlayStatus.UnPlay
    
    static func parse(dic: [String : AnyObject]) -> CourseModel {
        
        var m = CourseModel()
        
        // JSON 属性类
        m.id <-- dic["id"]
        m.name <-- dic["name"]
        m.photo <-- dic["img"]
        
        // JSON 关系类
        m.teacher <-- dic["teacher"]
        m.schools <-- dic["schools"]
        
        // JSON 枚举属性类
        m.playStatus <-- dic["playStatus"]

    }
}


```
如果解析失败，Optional 类型的属性将设为 nil, 非 Optional 类，将保持原来的值不变。

另外如果 schools 存在多页，当需要加入新数据时，可以这样写:

```swift

    var moreShools = [SchoolModel]()
    moreShools <- dic["schools"]

    m.schools += moreShools

```

如需要了解更多请访问： https://github.com/lancy/CaesarParser

*/


/**
 *  model的子协议
 */
public protocol ModelParseable {
    static func parse(_ json: Json) -> Self
}


// MARK: - Operator

precedencegroup ComparativePrecedence {
    associativity: right
    higherThan: LogicalConjunctionPrecedence
}
infix operator <-- : ComparativePrecedence


// MARK: - JSONPropertyType

public protocol JSONPropertyType {
    
    static func convert(from json: Json) -> Self?
}

extension Int: JSONPropertyType {
  
    public static func convert(from json: Json) -> Int? {
        switch json.value {
        case let int as Int:
            return int
        case let str as String:
            return Int(str)
        default:
            return nil
        }
    }
}

extension Int8: JSONPropertyType {
    public static func convert(from json: Json) -> Int8? {
        return Int.convert(from: json).flatMap { Int8($0) }
    }
}

extension Int16: JSONPropertyType {
    public static func convert(from json: Json) -> Int16? {
        return Int.convert(from: json).flatMap { Int16($0) }
    }
}

extension Int32: JSONPropertyType {
    public static func convert(from json: Json) -> Int32? {
        return Int.convert(from: json).flatMap { Int32($0) }
    }
}

extension Int64: JSONPropertyType {
    public static func convert(from json: Json) -> Int64? {
        return Int.convert(from: json).flatMap { Int64($0) }
    }
}

extension String: JSONPropertyType {
  
    public static func convert(from json: Json) -> String? {
        switch json.value {
        case let x as String: return x
        case let x as Int: return String(x)
        case let x as Double: return String(x)
        default: return json.value as? String
        }
    }
}

extension Double: JSONPropertyType {
    
    public static func convert(from json: Json) -> Double? {
        switch json.value {
        case let double as Double:
            return double
        case let str as String:
            return Double(str)
        default:
            return nil
        }
    }
}

extension Float: JSONPropertyType {
    
    public static func convert(from json: Json) -> Float? {
        switch json.value {
        case let float as Float:
            return float
        case let str as String:
            return Float(str)
        default:
            return nil
        }
    }
}

extension Bool: JSONPropertyType {
    
    public static func convert(from json: Json) -> Bool? {
        switch json.value {
        case let bool as Bool:
            return bool
        case let str as String:
            if let int = Int(str) {
                return int > 0
            } else {
                return Bool(str)
            }
        case let int as Int:
            return int > 0
        default:
            return nil
        }
    }
}

extension URL: JSONPropertyType {
    
    public static func convert(from json: Json) -> URL? {
        if let str = json.value as? String, let url = self.init(string: str) {
            return url
        }
        return nil
    }
}

extension Date: JSONPropertyType {
    
    public static func convert(from json: Json) -> Date? {
        if let string = json.value as? String {
            if let timeInterval = Double(string) {
                return self.init(timeIntervalSince1970: timeInterval / 1000.0)
            }
            
            let dateFormatter = DateFormatter()
            return dateFormatter.possibleDateFromString(string)
        } else if let timeInterval = json.value as? Double {
            
            return self.init(timeIntervalSince1970: timeInterval / 1000.0)
        }else {
            return nil
        }
    }
}

//extension NSDate: JSONPropertyType {
//    
//    public static func convert(from json: Json) -> Self? {
//
//        return Date.convert(from: json).flatMap{ Self.init($0) }
////        guard let dt = Date.convert(from: json) else {return nil}
////        return NSData.init(data: dt)
//    }
//}

private extension DateFormatter {
    func possibleDateFromString(_ string: String) -> Date? {
        let dateFormats = ["YYYY-MM-dd HH:mm:ss.SSS","YYYY-MM-dd", "YYYY-MM-dd HH:mm:ss", "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"]
        return dateFormats
            .compactMap { dateFromString(string, format: $0) }
            .first
    }
    
    func dateFromString(_ string: String, format: String) -> Date? {
        dateFormat = format
        return date(from: string)
    }
}

extension NSNumber: JSONPropertyType {
    public static func convert(from json: Json) -> Self? {
        return Double.convert(from: json).flatMap {  self.init(value: $0) }
    }
}

struct JSONParser {
    
    // MARK: - Parse Property
    
    @discardableResult
    static func convertAndAssign<P: JSONPropertyType>(_ property: inout P?, form json: Json) -> P? {
        if let convertedValue = P.convert(from: json) {
            property = convertedValue
        }
        return property
    }
    
    @discardableResult
    static func convertAndAssign<P: JSONPropertyType>(_ property: inout P, form json: Json) -> P {
        var newProperty: P?
        convertAndAssign(&newProperty, form: json)
        if let newProperty = newProperty { property = newProperty }
        return property
    }
    
    @discardableResult
    static func convertAndAssign<P: JSONPropertyType>(_ properties: inout [P]?, form json: Json) -> [P]? {
        if let jsons = json.jsonsValue {
            properties = jsons.compactMap(P.convert)
        }
        return properties
    }
    
    @discardableResult
    static func convertAndAssign<P: JSONPropertyType>(_ properties: inout [P], form json: Json) -> [P] {
        var newProperties: [P]?
        convertAndAssign(&newProperties, form: json)
        if let newProperties = newProperties { properties = newProperties }
        return properties
    }
    
    // MARK: - Parse Relationship

    @discardableResult
    static func convertAndAssign<M: ModelParseable>(_ model: inout M?, form json: Json) -> M? {
        if json.dicValue != nil {
            model = M.parse(json)
            return model
        }
        return nil
    }
    
    @discardableResult
    static func convertAndAssign<M: ModelParseable>(_ model: inout M, form json: Json) -> M {
        var newModel: M?
        convertAndAssign(&newModel, form: json)
        if let newModel = newModel { model = newModel }
        return model
    }
    
    @discardableResult
    static func convertAndAssign<M: ModelParseable>(_ models: inout [M]?, form json: Json) -> [M]? {
        if let jsons = json.jsonsValue {
            models = jsons.compactMap(M.parse)
            return models
        }
        return nil
    }
    
    @discardableResult
    static func convertAndAssign<M: ModelParseable>(_ models: inout [M], form json: Json) -> [M] {
        var newModels: [M]?
        convertAndAssign(&newModels, form: json)
        if let newModels = newModels { models = newModels }
        return models
    }
    
    // MARK: - Enum
    
    @discardableResult
    static func convertAndAssign<E: RawRepresentable>(_ enumeration: inout E?, form json: Json) -> E? where E.RawValue: JSONPropertyType {
        var newRawValue: E.RawValue?
        convertAndAssign(&newRawValue, form: json)
        if let newRawValue = newRawValue, let newEnumeration = E(rawValue: newRawValue) {
            enumeration = newEnumeration
        }
        return enumeration
    }
    
    @discardableResult
    static func convertAndAssign<E: RawRepresentable>(_ enumeration: inout E, form json: Json) -> E where E.RawValue: JSONPropertyType {
        var newEnumeration: E?
        convertAndAssign(&newEnumeration, form: json)
        if let newEnumeration = newEnumeration {
             enumeration = newEnumeration
        }
        return enumeration
    }
    
    
    @discardableResult
    static func convertAndAssign<E: RawRepresentable>(_ enumerations: inout [E]?, form json: Json) -> [E]? where E.RawValue: JSONPropertyType {
        if let jsons = json.jsonsValue {
            enumerations = jsons.compactMap {
                var newEnumeration: E?
                convertAndAssign(&newEnumeration, form: $0)
                return newEnumeration
            }
        }
        return enumerations
    }
    
    
    @discardableResult
    static func convertAndAssign<E: RawRepresentable>(_ enumerations: inout [E], form json: Json) -> [E] where E.RawValue: JSONPropertyType {
        var newEnumerations: [E]?
        convertAndAssign(&newEnumerations, form: json)
        if let newEnumerations = newEnumerations { enumerations = newEnumerations }
        return enumerations
    }
}



