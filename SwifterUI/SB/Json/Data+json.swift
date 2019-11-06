//
//  Data+json.swift
//  apc
//
//  Created by uke on 2019/3/20.
//  Copyright © 2019 @天意. All rights reserved.
//

import Foundation

extension Data {
    
    public var toJson: Json? {
        
        guard count > 0 else {return nil}
        //        print(String(data: self, encoding: String.Encoding.utf8) ?? "data转换utf8失败")
        do {
            let jsonDic = try JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions.mutableContainers)
            return Json(value: jsonDic)
        } catch {
            //            print(String(data: self, encoding: String.Encoding.utf8)!)
            print("解析错误",error)
            return nil
        }
    }
}
