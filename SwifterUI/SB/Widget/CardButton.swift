//
//  CardButton.swift
//  Draw
//
//  Created by mc on 2018/4/23.
//  Copyright © 2018年 Tianyi. All rights reserved.
//

import UIKit

open class CardButton: UIButton {
    
    let cardLayer = CAShapeLayer()
    var colorLayer = CAGradientLayer()
    
    @IBInspectable public var cardRadius: CGFloat = 0.0
    @IBInspectable public var corner: Int = 0
    
    ///渐变色颜色，在IB里面设置以逗号隔开
    @IBInspectable public var hexColors: String = "40e0d0,ff8c00,ff0080"
    @IBInspectable public var start: CGPoint = .zero
    @IBInspectable public var end: CGPoint = .zero
    
    
    var colors: [CGColor] {
        let s = hexColors.split(separator: ",")
            .map({ String($0) })
            .compactMap({ UIColor(hexString: $0)?.cgColor })
        return s
    }
    
    // MARK: shadow
    @IBInspectable public var shadow: UIColor = .white
    @IBInspectable public var offset: CGSize = .zero
    @IBInspectable public var opacity: CGFloat = 0
    @IBInspectable public var shadowRadius: CGFloat = 1
    
    
    var isLoad = false
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        reload()
        isLoad = true
    }
    
    open func didUpdate(block: (CardButton) -> Void) {
        
        block(self)
        guard isLoad else {return}
        reload()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        layer.insertSublayer(colorLayer, at: 0)
    }
    
    func reload() {
        let mp = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: CardBgType(value: corner).corners, cornerRadii: CGSize(width: cardRadius, height: cardRadius))
        cardLayer.frame = self.bounds
        cardLayer.path = mp.cgPath
        
        colorLayer.colors = colors
        colorLayer.startPoint = start
        colorLayer.endPoint = end
        colorLayer.frame = self.bounds
        colorLayer.mask = cardLayer
        
        layer.shadowColor = shadow.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = Float(opacity)
        layer.shadowPath = mp.cgPath
        layer.shadowRadius = shadowRadius
        layer.cornerRadius = cardRadius
    }
}

