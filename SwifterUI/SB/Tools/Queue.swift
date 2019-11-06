//
//  Queue.swift
//  Education
//
//  Created by luojie on 15/12/15.
//  Copyright © 2015年 牛至网. All rights reserved.
//

import Foundation

/**
 提供常用线程的简单访问方法. 用 Qos 代表线程对应的优先级。
    - Main:                 对应主线程
    - UserInteractive:      对应优先级高的线程
    - UserInitiated:        对应优先级中的线程
    - Utility:              对应优先级低的线程
    - Background:           对应后台的线程
    
    例如，异步下载图片可以这样写：
    ```swift
    Queue.UserInitiated.execute {
 
        let url = NSURL(string: "http://image.jpg")!
        let data = NSData(contentsOfURL: url)!
        let image = UIImage(data: data)
        
        Queue.Main.execute {
            imageView.image = image
        }
    }
 */

public enum Queue: ExcutableQueue {
    case main
    case userInteractive
    case userInitiated
    case utility
    case background
    
    public var queue: DispatchQueue {
        switch self {
        case .main:
            return .main
        case .userInteractive:
            return .global(qos: .userInteractive)
        case .userInitiated:
            return .global(qos: .userInitiated)
        case .utility:
            return .global(qos: .utility)
        case .background:
            return .global(qos: .background)
        }
    }
}

/// 提供本 App 要使用的所有 SerialQueue，以下的 case 只是一个例子，可以根据需要修改
public enum SerialQueue: String, ExcutableQueue {

    case DownLoadImage = "ovfun.Education.SerialQueue.DownLoadImage"
    case UpLoadFile = "ovfun.Education.SerialQueue.UpLoadFile"

    public var queue: DispatchQueue {
        return DispatchQueue(label: rawValue)
    }
}

/// 给 Queue 提供默认的执行能力
public protocol ExcutableQueue {
   
    var queue: DispatchQueue { get }
}

extension ExcutableQueue {
  
    public func execute(_ closure: @escaping () -> Void) {
        queue.async(execute: closure)
    }
    
    public func executeAfter(seconds: TimeInterval, closure: @escaping () -> Void) {
        let delay = DispatchTime.now() + seconds
        queue.asyncAfter(deadline: delay, execute: closure)
    }
}
