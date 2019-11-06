//
//  Json+.swift
//  apc
//
//  Created by uke on 2019/3/20.
//  Copyright © 2019 @天意. All rights reserved.
//

import Foundation

extension Json {
    
    var uid: String {
        return self["uid"].stringValue ?? ""
    }
    
    var data: Json {
        return self["data"]
    }
    
    var list: Json {
        return self["list"]
    }
    
    var id: Json {
        return self["id"]
    }
    
    var code: Json {
        return self["code"]
    }
    
    var message: Json {
        return self["message"]
    }
}



