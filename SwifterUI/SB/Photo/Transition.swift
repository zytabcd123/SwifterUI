//
//  AnimatedTransition.swift
//  secret
//
//  Created by mc on 2017/8/2.
//  Copyright © 2017年 mc. All rights reserved.
//

import UIKit

open class Transition: NSObject,UIViewControllerTransitioningDelegate {
    
    var beforeImageViewFrame: CGRect! {
        didSet {
            percentIntractive.beforeImageViewFrame = beforeImageViewFrame
        }
    }
    var currentImageViewFrame: CGRect! {
        didSet {
            percentIntractive.currentImageViewFrame = currentImageViewFrame
        }
    }
    var currentImage: UIImage! {
        didSet {
            percentIntractive.currentImage = currentImage
        }
    }
    var gestureRecognizer: UIPanGestureRecognizer! {
        didSet {
            percentIntractive.gestureRecognizer = gestureRecognizer
        }
    }
    
    private var customPush = PushTransition()
    private var customPop = PopTransition()
    private var percentIntractive = PercentTransition()
    
    deinit {
        
    }
    
    convenience init(_ image: UIImage?,beforeImgFrame: CGRect? ,afterImgFrame: CGRect?) {
        self.init()
        
        setTransitionImage(image)
        setTransitionBeforeImgFrame(beforeImgFrame)
        setTransitionAfterImgFrame(afterImgFrame)
    }
    
    // 转场过渡的图片
    private func setTransitionImage(_ transitionImage: UIImage?) {
        customPush.transitionImage = transitionImage
        customPop.transitionImage = transitionImage
    }
    
    // 转场前的图片frame
    private func setTransitionBeforeImgFrame(_ frame: CGRect?) {
        customPush.transitionBeforeImgFrame = frame ?? CGRect.zero
        customPop.transitionBeforeImgFrame = frame ?? CGRect.zero
        percentIntractive.beforeImageViewFrame = frame ?? CGRect.zero
    }
    
    // 转场后的图片frame
    private func setTransitionAfterImgFrame(_ frame: CGRect?) {
        customPush.transitionAfterImgFrame = frame ?? CGRect.zero
        customPop.transitionAfterImgFrame = frame ?? CGRect.zero
    }
    
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customPush
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customPop
    }
    
    open func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if gestureRecognizer != nil {
            return percentIntractive
        }else {
            return nil
        }
    }
    
    
}
