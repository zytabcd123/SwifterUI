//
//  BallAnimationView.swift
//
//  Code generated using QuartzCode 1.63.0 on 2018/1/30.
//  www.quartzcodeapp.com
//

import UIKit

class BallAnimationView: UIView {
        
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        let w = min(UIScreen.main.bounds.size.width, self.frame.size.height) / 10
        let x = (UIScreen.main.bounds.size.width - w) / 2
        let y = (self.frame.size.height - w) / 2

        //动画图层,就是不停变大的那个圆
        let animationLayer = CAShapeLayer()
        animationLayer.backgroundColor = tintColor.cgColor
        animationLayer.frame = CGRect(x: x, y: y, width: w, height: w)
        animationLayer.cornerRadius = w / 2
        
        // 放大的动画
        let transformAnim = CABasicAnimation(keyPath: "transform")
        transformAnim.toValue = CATransform3DMakeScale(8, 8, 1)
        transformAnim.duration = 3
        
        // 透明度动画(其实也可以直接设置CAReplicatorLayer的instanceAlphaOffset来实现)
        let alphaAnim = CABasicAnimation(keyPath: "opacity")
        alphaAnim.toValue = 0
        alphaAnim.duration = 3
        
        let animGroup = CAAnimationGroup()
        animGroup.animations = [transformAnim,alphaAnim]
        animGroup.duration = 3.6
        animGroup.repeatCount = Float.infinity
        animGroup.isRemovedOnCompletion = false
        animationLayer.add(animGroup, forKey: "BallAnimationView")
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.addSublayer(animationLayer);
        replicatorLayer.instanceCount = 3  //三个复制图层
        replicatorLayer.instanceDelay = 1.2  //复制间隔
        
        self.layer.addSublayer(replicatorLayer)
    }
    
    func setProgress(_ p: CGFloat) {
        guard self.alpha != p else {return}
        self.alpha = p
        self.isHidden = p <= 0
    }
    
    func start() {

        self.isHidden = false
    }
    
    func stop() {
        
        self.isHidden = true
    }
}
