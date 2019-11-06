//
//  PlaceholderTextView.swift
//  SelfSizeTextView
//
//  Created by luojie on 16/5/12.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


open class PlaceholderTextView: UITextView {
    
    public var placeholder: String? { didSet { setNeedsDisplay() } }
    
    public var placeholderColor: UIColor = .lightGray { didSet { setNeedsDisplay() } }
    
    override open var text: String! { didSet { setNeedsDisplay() } }

    override open func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    fileprivate func setup() {
        observeNotification(name: UITextView.textDidChangeNotification, object: self) { [unowned self] _ in
            self.setNeedsDisplay()
        }
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let p = placeholder, text.isEmpty else { return }
        
        var placeholderAttributes = [NSAttributedString.Key: AnyObject]()
        placeholderAttributes[NSAttributedString.Key.font] = font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        placeholderAttributes[NSAttributedString.Key.foregroundColor] = placeholderColor

        let x = contentInset.left + textContainerInset.left + textContainer.lineFragmentPadding
        let y = textContainerInset.top
        p.draw(in: CGRect(x: x, y: y, width: rect.width, height: rect.height), withAttributes: placeholderAttributes)
    }
}
