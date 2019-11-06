import Foundation

/**
 使 JSON 支持 keyPath 取值
 ## 用法 ##
 
 ```swift
static func parse(dic: [String : AnyObject]) -> Order {
 
    let json = Json(value: dic)
 
    var m = Order()
 
    m.id    <-- json["data.order.id"]
    m.photo <-- json["data.order.img"]
    m.date  <-- json["data.order.time"]
 
    return m
}
 ```
  * 建议在网络请求框架处将 dic 转化为 Json
 ### 链式取值 ###
以下两行代码功能是相同的
 
 ```swift
m.id <-- json["data.order.id"]
m.id <-- json["data"]["order"][id"]
 ```
 
 ### 手动取值 ###

 ```swift
 m.id    = json["data.order.id"].integerValue
 m.photo = json["data.order.img"].urlValue
 m.date  = json["data.order.time"].dateValue
 ```
 
 ### 属性链取值 ###
 
 ```swift
 m.id    = json.data.order.id.integerValue
 m.photo = json.data.order.photo.urlValue
 m.date  = json.data.order.date.dateValue
 ```
须事先声明属性对应的 key 值
 ```swift

private extension Json {
    var data: Json {
        return self["data"]
    }
    
    var id: Json {
        return self["id"]
    }
    
    var order: Json {
        return self["order"]
    }
    
    var photo: Json {
        return self["img"]
    }
    
    var date: Json {
        return self["time"]
    }
}
 ```
 */

public struct Json {
    public let value: Any?
    
    public init(value: Any?) {
        self.value = value
    }
    
    public subscript(keyPath: String) -> Json {
        let newValue = (value as? NSDictionary)?.value(forKeyPath: keyPath)
        return Json(value: newValue)
    }
}

extension Json: CustomStringConvertible {
    public var description: String {
        switch value {
        case nil:
            return "Json value: nil"
        case let hasDescription as CustomStringConvertible:
            return "Json value: \(hasDescription)"
        case let value?:
            let typeString = String(describing: type(of: value))
            return "Json value: \(typeString)"
        }
    }
}

extension Json {
    public var integerValue: Int? {
        return valueWithType(Int.self)
    }
    
    public var stringValue: String? {
        return valueWithType(String.self)
    }
    
    public var doubleValue: Double? {
        return valueWithType(Double.self)
    }
    
    public var floatValue: Float? {
        return valueWithType(Float.self)
    }
    
    public var boolValue: Bool? {
        return valueWithType(Bool.self)
    }
    
    public var urlValue: URL? {
        return valueWithType(URL.self)
    }
    
    public var dateValue: Date? {
        return valueWithType(Date.self)
    }
    
    public var numberValue: NSNumber? {
        return valueWithType(NSNumber.self)
    }
    
    public var dicValue: [String: Any]? {
        return value as? [String: Any]
    }
    
    public var arrayValue: [Any]? {
        return value as? [Any]
    }
    
    public var jsonsValue: [Json]? {
        return arrayValue?.map { Json(value: $0) }
    }
    
    private func valueWithType<P: JSONPropertyType>(_ type: P.Type) -> P? {
        var result: P?
        result <-- self
        return result
    }
}

@discardableResult
public func <--<P: JSONPropertyType>(property: inout P?, json: Json) -> P? {
    return JSONParser.convertAndAssign(&property, form: json)
}

@discardableResult
public func <--<P: JSONPropertyType>(property: inout P, json: Json) -> P {
    return JSONParser.convertAndAssign(&property, form: json)
}

@discardableResult
public func <--<P: JSONPropertyType>(properties: inout [P]?, json: Json) -> [P]? {
    return JSONParser.convertAndAssign(&properties, form: json)
}

@discardableResult
public func <--<P: JSONPropertyType>(properties: inout [P], json: Json) -> [P] {
    return JSONParser.convertAndAssign(&properties, form: json)
}

@discardableResult
public func <--<M: ModelParseable>(model: inout M?, json: Json) -> M? {
    return JSONParser.convertAndAssign(&model, form: json)
}

@discardableResult
public func <--<M: ModelParseable>(model: inout M, json: Json) -> M {
    return JSONParser.convertAndAssign(&model, form: json)
}

@discardableResult
public func <--<M: ModelParseable>(models: inout [M]?, json: Json) -> [M]? {
    return JSONParser.convertAndAssign(&models, form: json)
}

@discardableResult
public func <--<M: ModelParseable>(models: inout [M], json: Json) -> [M] {
    return JSONParser.convertAndAssign(&models, form: json)
}

@discardableResult
public func <--<E: RawRepresentable>(enumeration: inout E?, json: Json) -> E? where E.RawValue: JSONPropertyType {
    return JSONParser.convertAndAssign(&enumeration, form: json)
}

@discardableResult
public func <--<E: RawRepresentable>(enumeration: inout E, json: Json) -> E where E.RawValue: JSONPropertyType {
    return JSONParser.convertAndAssign(&enumeration, form: json)
}

@discardableResult
public func <--<E: RawRepresentable>(enumerations: inout [E]?, json: Json) -> [E]? where E.RawValue: JSONPropertyType {
    return JSONParser.convertAndAssign(&enumerations, form: json)
}

@discardableResult
public func <--<E: RawRepresentable>(enumerations: inout [E], json: Json) -> [E] where E.RawValue: JSONPropertyType {
    return JSONParser.convertAndAssign(&enumerations, form: json)
}


