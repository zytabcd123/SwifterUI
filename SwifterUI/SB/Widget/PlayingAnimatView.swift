//
//  PlayingAnimatView.swift
//  apc
//
//  Created by uke on 2018/11/21.
//  Copyright © 2018 uke. All rights reserved.
//

import Foundation

open class PlayingAnimatView: UIView {
    
    @IBInspectable public var instanceCount = 3
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let w = self.w / CGFloat(instanceCount * 2 + 1)
        
        let ly = CALayer()
        ly.frame = CGRect(x: w, y: self.frame.size.height / 2, width: w, height: self.frame.size.height)
        ly.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.7490196078, blue: 0.1098039216, alpha: 1)
        ly.anchorPoint = CGPoint(x: 0.5, y: 1)
        ly.add(PlayingAnimatView.scaleYAnimation, forKey: "scaleAnimation")
        
        let rly = CAReplicatorLayer()
        rly.frame = bounds
        rly.instanceCount = instanceCount
        rly.instanceTransform = CATransform3DMakeTranslation(w * 2, 0, 0)
        rly.instanceDelay = 0.2
        rly.addSublayer(ly)
        
        self.layer.addSublayer(rly)
        
        
    }
    
    static var scaleYAnimation: CABasicAnimation {
        let a = CABasicAnimation(keyPath: "transform.scale.y")
        a.toValue = 0.1
        a.duration = 0.3
        a.autoreverses = true
        a.repeatCount = Float.infinity
        a.isRemovedOnCompletion = false
        return a
    }
}
