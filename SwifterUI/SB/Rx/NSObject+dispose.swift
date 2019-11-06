//
//  NSObject+dispose.swift
//  apc
//
//  Created by uke on 2019/3/20.
//  Copyright © 2019 @天意. All rights reserved.
//

import Foundation
import RxSwift

public protocol HasDisposeBag {
    
    var disposeBag: DisposeBag { get set }
}

extension NSObject: HasDisposeBag {
    
    public var disposeBag: DisposeBag {
        get {
            if let result = objc_getAssociatedObject(self, &AssociatedKeys.DisposeBag) as? DisposeBag {
                return result
            }
            let result = DisposeBag()
            objc_setAssociatedObject(self, &AssociatedKeys.DisposeBag, result, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return result
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.DisposeBag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

private struct AssociatedKeys {
    
    static var DisposeBag = "DisposeBag"
}
