//
//  ColorLabel.swift
//  Draw
//
//  Created by mc on 2018/3/6.
//  Copyright © 2018年 Tianyi. All rights reserved.
//

import UIKit
enum ColorDirection: Int {
    case leftToRight
    case topLeftToBottomRight
    case bottomLeftToTopRight
    case topToBottom
}

open class ColorLabel: UILabel {
    
    ///渐变色颜色，在IB里面设置以逗号隔开
    @IBInspectable public var hexColors: String = "4366ff,e641ff"
    @IBInspectable public var direction: Int = 0
    
    var colorDirection: ColorDirection {
        return ColorDirection(rawValue: direction) ?? .leftToRight
    }
    
    var colors: CFArray {
        let s = hexColors.split(separator: ",")
            .map({ String($0) })
            .compactMap({ UIColor(hexString: $0)?.cgColor })
        return s as CFArray
    }
    
    var singleColor: UIColor? {
        let s = hexColors.split(separator: ",")
        guard s.count < 2, let c = s.map({ String($0) }).first else {return nil}
        return UIColor(hexString: c)
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let c = singleColor {
            textColor = c
            return
        }
        guard let context = UIGraphicsGetCurrentContext() else {return}
        let height = rect.size.height
        let textSize = rect.size
        
        let imageRef = context.makeImage()//获得倒置的图片
        context.clear(rect)
        /*
         为什么会发生倒置问题
         究其原因是因为Core Graphics源于Mac OS X系统，在Mac OS X中，坐标原点在左下方并且正y坐标是朝上的，而在iOS中，原点坐标是在左上方并且正y坐标是朝下的。在大多数情况下，这不会出现任何问题，因为图形上下文的坐标系统是会自动调节补偿的。但是创建和绘制一个CGImage对象时就会暴露出倒置问题。
         */
        //下面的两行代码将：原点在左下方并且正y坐标是朝上的
        context.translateBy(x: 0, y: height)
        context.scaleBy(x: 1.0, y: -1.0)
        //下面的context 原点在左下 并且 正y坐标是朝上的
        context.clip(to: CGRect(x: rect.origin.x, y: 0, width: rect.size.width, height: rect.size.height), mask: imageRef!)
        
        
        //划渐变色图层
        let colorSpaceRef = CGColorSpaceCreateDeviceRGB()
        let gradientRef = CGGradient(colorsSpace: colorSpaceRef, colors: colors, locations: nil)
        var startPoint = CGPoint.zero
        var endPoint = CGPoint(x: textSize.width, y: textSize.height)
        switch colorDirection {
        case .leftToRight:
            endPoint.y = 0
            break
        case .topLeftToBottomRight:
            break
        case .bottomLeftToTopRight:
            startPoint.y = textSize.height
            endPoint.y = 0
        case .topToBottom:
            endPoint = .init(x: 0, y: textSize.height )
        }
        
//        print(text,rect, textSize, "s", startPoint, "e", endPoint)
        context.drawLinearGradient(gradientRef!, start: startPoint, end: endPoint, options: .drawsAfterEndLocation)
    }
}

extension UILabel {
    
    public func size(text: String) -> CGSize {
        let v = UILabel()
        v.text = text
        v.font = font
        v.sizeToFit()
        return v.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines).size
    }
}

//open class ColorLabel: UILabel {
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
//    var oldRecy: CGRect = .zero
//    override open func draw(_ rect: CGRect) {
//        super.draw(rect)
//
//        if !isLoad {
//            reload()
//            isLoad = true
//            oldRecy = rect
//        }else {
//            if rect != oldRecy {
//                print("~~~~~~~~~~~~~~2",rect, oldRecy)
//                reload()
//                oldRecy = rect
//            }
//        }
//    }
//
//    open override func layoutIfNeeded() {
//        super.layoutIfNeeded()
//        print("~~~~~~~~~~~~~~1")
//    }
//
//    open func didUpdate(block: (ColorLabel) -> Void) {
//
//        block(self)
//        guard isLoad else {return}
//        reload()
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



