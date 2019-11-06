//
//  ColorButton.swift
//  Draw
//
//  Created by mc on 2018/3/7.
//  Copyright © 2018年 Tianyi. All rights reserved.
//

import UIKit

open class ColorButton: UIButton {
    
    ///渐变色颜色，在IB里面设置以逗号隔开
    @IBInspectable public var hexColors: String = "46B1FE,8C6FFF"
    @IBInspectable public var start: CGPoint = .zero
    @IBInspectable public var end: CGPoint = .zero
    
    
    var colors: [Any] {
        let s = hexColors.split(separator: ",")
            .map({ String($0) })
            .compactMap({ UIColor(hexString: $0)?.cgColor })
        return s
    }
    
    var singleColor: UIColor? {
        let s = hexColors.split(separator: ",")
        guard s.count < 2, let c = s.map({ String($0) }).first else {return nil}
        return UIColor(hexString: c)
    }
    
    open func didUpdate(block: (ColorButton) -> Void) {
        
        block(self)
        setNeedsDisplay()
    }

    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let c = singleColor {
            setTitleColor(c, for: .normal)
            return
        }
        
        let colorLayer = CAGradientLayer()
        colorLayer.frame = titleRect(forContentRect: rect)
        colorLayer.colors = colors
        colorLayer.startPoint = start
        colorLayer.endPoint = end
        
        
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.isOpaque, 0)
        colorLayer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        setTitleColor(outputImage?.color, for: .normal)
    }
}

extension UIImage {
    
    fileprivate var color: UIColor? {
        return UIColor(patternImage: self)
    }
}

//open class ColorButton: UIButton {
//
//    var colorLayer = CAGradientLayer()
//
//    @IBInspectable public var from: UIColor = .white
//    @IBInspectable public var to: UIColor = .white
//    @IBInspectable public var start: CGPoint = .zero
//    @IBInspectable public var end: CGPoint = .zero
//
//
//    var isLoad = false
//    override open func draw(_ rect: CGRect) {
//        super.draw(rect)
//        reload()
//        isLoad = true
//    }
//
//    open func didUpdate(block: (ColorButton) -> Void) {
//
//        block(self)
//        guard isLoad else {return}
//        reload()
//    }
//
////    open override func layoutSubviews() {
////        super.layoutSubviews()
////        reload()
////        isLoad = true
////    }
//
//    override open func awakeFromNib() {
//        super.awakeFromNib()
//
//
//    }
//
//    func reload() {
//
//        colorLayer.colors = [from.cgColor, to.cgColor]
//        colorLayer.startPoint = start
//        colorLayer.endPoint = end
//        colorLayer.frame = self.frame
//
//        superview?.layer.addSublayer(colorLayer)
//        colorLayer.mask = layer
//        frame = colorLayer.bounds
//    }
//}

