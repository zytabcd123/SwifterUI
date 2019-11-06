//
//  AnimatedPercent.swift
//  secret
//
//  Created by mc on 2017/8/2.
//  Copyright © 2017年 mc. All rights reserved.
//

import UIKit

open class PercentTransition: UIPercentDrivenInteractiveTransition {
    
    var beforeImageViewFrame: CGRect = CGRect.zero
    var currentImageViewFrame: CGRect = CGRect.zero
    var currentImage: UIImage?
    
    var gestureRecognizer: UIPanGestureRecognizer! {
        didSet {
            gestureRecognizer.addTarget(self, action: #selector(PercentTransition.gestureRecognizeDidUpdate(_:)))
        }
    }
    
    private var transitionContext: UIViewControllerContextTransitioning!
    private var blackBgView: UIView?
    private var fromView: UIView?
    private var toView: UIView?
    
    private var isFirst = true
    
    deinit {
        gestureRecognizer = nil
    }
    
    
    
    @objc func gestureRecognizeDidUpdate(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in:  gestureRecognizer.view)
        
        var scale = 1 - translation.y / UIScreen.h
        
        scale = scale > 1 ? 1:scale
        scale = scale < 0 ? 0:scale
        
        if isFirst {
            beginInterPercent()
            isFirst = false
        }
        
        switch gestureRecognizer.state {
        case .began:
            // 进不来
            break
        case .changed:
            update(scale)
            updateInterPercent(scale)
            break
        case .ended:
            
            if translation.y <= 80 {
                cancel()
                interPercentCancel()
            }else {
                finish()
                interPercentFinish()
            }
            
            break
        default:
            cancel()
            interPercentCancel()
            break
        }
        
    }
    
    func beginInterPercent() {
        
        let transitionContext = self.transitionContext
        
        // 转场过渡的容器view
        if let containerView = transitionContext?.containerView {
            
            // ToVC
            let toViewController = transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.to)
            toView = toViewController?.view
            toView?.isHidden = false
            containerView.addSubview(toView!)
            
            // 有渐变的黑色背景
            blackBgView = UIView(frame: containerView.bounds)
            blackBgView?.backgroundColor = .black
            blackBgView?.isHidden = false
            containerView.addSubview(blackBgView!)
            
            
            // fromVC
            let fromViewController = transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.from)
            fromView = fromViewController?.view
            fromView?.backgroundColor = UIColor.clear
            fromView?.isHidden = false
            containerView.addSubview(fromView!)
            
        }
    }
    
    func updateInterPercent(_ scale: CGFloat) {
        blackBgView?.alpha = scale * scale * scale
    }
    
    func interPercentCancel() {
        
        let transitionContext = self.transitionContext
        
        fromView?.backgroundColor = .black
        blackBgView?.removeFromSuperview()
        
        transitionContext?.completeTransition(!(transitionContext?.transitionWasCancelled)!)
    }
    
    func interPercentFinish() {
        
        let transitionContext = self.transitionContext
        
        // 转场过渡的容器view
        if let containerView = transitionContext?.containerView {
            
            // 过度的图片
            let transitionImgView = UIImageView(image: currentImage)
            transitionImgView.clipsToBounds = true
            transitionImgView.frame = currentImageViewFrame
            containerView.addSubview(transitionImgView)
            
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveLinear, animations: { [weak self] in
                
                transitionImgView.frame = (self?.beforeImageViewFrame)!
                self?.blackBgView?.alpha = 0
                
            }) { [weak self] (finished: Bool) in
                
                self?.blackBgView?.removeFromSuperview()
                transitionImgView.removeFromSuperview()
                
                transitionContext?.completeTransition(!(transitionContext?.transitionWasCancelled)!)
                
                self?.fromView?.isHidden = false
                self?.toView?.isHidden = false
            }
        }
    }
    
    override open func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
    }
}
