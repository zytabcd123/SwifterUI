//
//  CardView.swift
//  Draw
//
//  Created by mc on 2018/1/16.
//  Copyright © 2018年 Tianyi. All rights reserved.
//

import UIKit
import RxSwift

public enum CardBgType: Int {
    case top = 1
    case center
    case bottom
    case noTopLeft
    case noTopRight
    case all
    
    init(value: Int) {
        switch value {
        case 1: self = .top
        case 2: self = .center
        case 3: self = .bottom
        case 4: self = .noTopLeft
        case 5: self = .noTopRight
        default: self = .all
        }
    }
}
extension CardBgType {
    public static let shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
    public static let shadowOpacity: Float = 0.2
    public static let shadowRadius: CGFloat = 4.0
    public static let shadowOffset = CGSize(width: 0, height: 2)
    public static let radius: CGFloat = 16.0
    public static let offset: CGFloat = 20.0
    
    public var corners: UIRectCorner {
        switch self {
        case .top: return [.topLeft, .topRight]
        case .center: return []
        case .bottom: return [.bottomLeft, .bottomRight]
        case .noTopLeft: return [.bottomLeft, .bottomRight, .topRight]
        case .noTopRight: return [.bottomLeft, .bottomRight, .topLeft]
        case .all: return [.allCorners]
        }
    }
}


open class CardView: UIView {
    
    let cardLayer = CAShapeLayer()
    var colorLayer = CAGradientLayer()
    
    @IBInspectable public var cardRadius: CGFloat = 0.0
    @IBInspectable public var corner: Int = 0
    
    ///渐变色颜色，在IB里面设置以逗号隔开
    @IBInspectable public var hexColors: String = "40e0d0,ff8c00,ff0080"
    @IBInspectable public var start: CGPoint = .zero
    @IBInspectable public var end: CGPoint = .zero
    
    // MARK: shadow
    @IBInspectable public var shadow: UIColor = .white
    @IBInspectable public var offset: CGSize = .zero
    @IBInspectable public var opacity: CGFloat = 0
    @IBInspectable public var shadowRadius: CGFloat = 1
    
    var colors: [CGColor] {
        let s = hexColors.split(separator: ",")
            .map({ String($0) })
            .compactMap({ UIColor(hexString: $0)?.cgColor })
        return s
    }
    var isLoad = false
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        relayout()
        reload()
        isLoad = true
    }
    
    open func didUpdate(block: (CardView) -> Void) {
        
        block(self)
        guard isLoad else {return}
        reload()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        load()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        load()
    }
    
    func load() {
        
        backgroundColor = UIColor.clear
        layer.insertSublayer(colorLayer, at: 0)
        
        self.rx.observe(CGRect.self, "bounds")
            .filterNil()
            .subscribe(onNext: { [unowned self] _ in
                guard self.isLoad else {return}
                self.relayout()
            })
            .disposed(by: disposeBag)
    }
    
    func reload() {
        
        colorLayer.colors = colors
        colorLayer.startPoint = start
        colorLayer.endPoint = end
        colorLayer.mask = cardLayer
        
        layer.shadowColor = shadow.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = Float(opacity)
        layer.cornerRadius = cardRadius
    }
    
    func relayout() {
        let mp = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: CardBgType(value: corner).corners, cornerRadii: CGSize(width: cardRadius, height: cardRadius))
        cardLayer.frame = self.bounds
        cardLayer.path = mp.cgPath
        colorLayer.frame = self.bounds
        layer.shadowPath = mp.cgPath
    }
}

