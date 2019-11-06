//
//  HasReuseDisposeBag.swift
//  BNKit
//
//  Created by luojie on 2016/11/24.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public protocol HasReuseDisposeBag {
    var reuseSelector: Selector { get }
    var reuseDisposeBag: DisposeBag { get }
}

extension HasReuseDisposeBag where Self: NSObject {
    
    public var reuseDisposeBag: DisposeBag {
        
        return objc.findOrCreateValue(forKey: &Keys.reuseDisposeBag, createValue: {
            let disposeBag = DisposeBag()
            objc.set(value: disposeBag, forKey: &Keys.reuseDisposeBag)
            rx.methodInvoked(reuseSelector)
                .subscribe(onNext: { [unowned self] _ in
                    self.objc.set(value: nil, forKey: &Keys.reuseDisposeBag)
                })
                .disposed(by: disposeBag)
            return disposeBag
        })
    }
}

extension UITableViewCell: HasReuseDisposeBag {
    
    public var reuseSelector: Selector {
        return #selector(UITableViewCell.prepareForReuse)
    }
}

extension UICollectionReusableView: HasReuseDisposeBag {
    
    public var reuseSelector: Selector {
        return #selector(UICollectionReusableView.prepareForReuse)
    }
}


private enum Keys {
    static var reuseDisposeBag = "reuseDisposeBag"
}

