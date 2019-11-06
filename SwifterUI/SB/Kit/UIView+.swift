//
//  UIView+.swift
//  apc
//
//  Created by ovfun on 2017/1/3.
//  Copyright © 2017年 @天意. All rights reserved.
//

import Foundation

extension UIView {
    
    public var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

extension UIView {
    
    public func animatedRelayout(completion: (() -> Void)? = nil) {
        
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.layoutIfNeeded()
        }, completion: { _ in
            completion?()
        })
    }
    
    public func heartbeatAnimation(_ duration: TimeInterval = 0.3, delay: TimeInterval = 0, finishedBlock: (()->())? = nil) {
        
        UIView.animateKeyframes(withDuration: duration, delay: delay, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.transform = CGAffineTransform(scaleX: 2, y: 2)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1, animations: {
                self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            })
        }) { (isFinished) in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: [], animations: {
                self.transform = .identity
            }, completion: { (isFinished) in
                finishedBlock?()
            })
        }
    }
}
