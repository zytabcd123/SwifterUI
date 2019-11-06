//
//  PushTransition.swift
//  secret
//
//  Created by mc on 2017/8/2.
//  Copyright © 2017年 mc. All rights reserved.
//

import UIKit

open class PushTransition: NSObject,UIViewControllerAnimatedTransitioning {
    
    var transitionImage: UIImage?
    var transitionBeforeImgFrame: CGRect = CGRect.zero
    var transitionAfterImgFrame: CGRect = CGRect.zero
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // 转场过渡的容器view
        let containerView = transitionContext.containerView
        
        // FromVC
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let fromView = fromViewController?.view
        fromView?.isHidden = true
        
        // ToVC
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let toView = toViewController?.view
        containerView.addSubview(toView!)
        toView?.isHidden = true
        
        if transitionBeforeImgFrame == CGRect.zero {
            
            toView?.isHidden = false
            toView?.alpha = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                
                toView?.alpha = 1
                
            }, completion: { (finished:Bool) in
                
                // 设置transitionContext通知系统动画执行完毕
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            
            return
        }
        
        // 有渐变的黑色背景
        let bgView = UIView(frame: containerView.bounds)
        bgView.backgroundColor = .black
        bgView.alpha = 0
        containerView.addSubview(bgView)
        
        // 过渡的图片
        let transitionImgView = UIImageView(image: self.transitionImage)
        transitionImgView.frame = self.transitionBeforeImgFrame
        containerView.addSubview(transitionImgView)
        
        // 如果没有过度图片
        if transitionImage == nil {
            transitionImgView.backgroundColor = UIColor.black
            transitionImgView.alpha = 0.1
            
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveLinear, animations: { [weak self] in
            
            transitionImgView.frame = (self?.transitionAfterImgFrame)!
            bgView.alpha = 1
            
            if self?.transitionImage == nil {
                transitionImgView.alpha = 0
            }
            
        }) { (finished:Bool) in
            
            toView?.isHidden = false
            
            bgView.removeFromSuperview()
            transitionImgView.removeFromSuperview()
            
            //  设置transitionContext通知系统动画执行完毕
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
        }
    }
}
