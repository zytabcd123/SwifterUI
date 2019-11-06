//
//  Motification+Rx.swift
//  secret
//
//  Created by mc on 2017/8/14.
//  Copyright © 2017年 mc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension NSObject {
    
    public func postNotification(name: Notification.Name) {
        NotificationCenter.default
            .post(name: name, object: self)
    }
    
    public func observeNotification(name: Notification.Name, object: AnyObject? = nil, didReceiveNotification: @escaping (Notification) -> Void) {
        NotificationCenter.default
            .rx.notification(name, object: object)
            .subscribe(onNext: didReceiveNotification)
            .disposed(by: disposeBag)
    }
}
