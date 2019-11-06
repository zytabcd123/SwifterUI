//
//  UITextField+Rx.swift
//  ArtExamination
//
//  Created by apple on 2017/4/24.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UITextField {
    
    /*
     
        - parameter length: 限制textField的长度为多少
     
        当 textField 输入比限制长度多一位开始执行判断
     
        let phoneValid = phoneTextField.rx.text.orEmpty
        .map{$0.count >= 11 }
        .share(replay: 1)
     
        phoneValid
        .bind(to: phoneTextField.rx.limitText(length: 11))
        .disposed(by: disposeBag)
     
     */
    
    public func limitText(length: Int) -> Binder<Bool> {
        
        return Binder(self.base) { textField, limit in
            
            let t = textField.text ?? ""
            if t.count > length {
                
                let idx = t.index(t.startIndex, offsetBy: length)
                textField.text = String(t[..<idx])
            }
        }
    }
    
    public func next() -> Binder<Bool> {
        
        return Binder(self.base, binding: { (textField, nextResponder) in
            if nextResponder {
                textField.becomeFirstResponder()
            }else {
//                print(self.base, textField)
//                self.base.becomeFirstResponder()
            }
            self.base.isEnabled = !nextResponder
        })
    }
}

extension Reactive where Base: UITextView {
    
    /*
     
     - parameter length: 限制textField的长度为多少
     
     当 textField 输入比限制长度多一位开始执行判断
     
     let phoneValid = phoneTextField.rx.text.orEmpty
     .map{$0.count >= 11 }
     .share(replay: 1)
     
     phoneValid
     .bind(to: phoneTextField.rx.limitText(length: 11))
     .disposed(by: disposeBag)
     
     */
    
    public func limitText(length: Int) -> Binder<Bool> {
        
        return Binder(self.base) { textField, limit in
            
            let t = textField.text ?? ""
            if t.count > length {
                
                let idx = t.index(t.startIndex, offsetBy: length)
                textField.text = String(t[..<idx])
            }
        }
    }
}
