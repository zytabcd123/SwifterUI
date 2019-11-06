//
//  Optional+Rx.swift
//  WorkMap
//
//  Created by luojie on 16/10/17.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


public protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    public var value: Wrapped? {
        return self
    }
}

extension Observable {
    
    public func mapToOptional() -> Observable<Element?> {
        return map(Optional.init)
    }
}

extension Observable where Element: OptionalType {
    
    public func filterNil() -> Observable<Element.Wrapped> {
        return filter { $0.value != nil }
            .map { $0.value! }
    }
}

extension SharedSequenceConvertibleType where Element: OptionalType {
    
    public func filterNil() -> SharedSequence<SharingStrategy, Element.Wrapped> {
        return filter { $0.value != nil }
            .map { $0.value! }
    }
}

extension SharedSequenceConvertibleType {
    
    public func mapToOptional() -> SharedSequence<Self.SharingStrategy, Self.Element?> {
        return map(Optional.init)
    }
}
