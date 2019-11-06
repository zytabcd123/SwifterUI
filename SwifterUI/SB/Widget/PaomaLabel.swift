//
//  PaomaLabel.swift
//  clclient
//
//  Created by uke on 2018/11/16.
//  Copyright © 2018 uke. All rights reserved.
//

import Foundation
import SnapKit

open class PaomaLabel: UIView {
    
    //需要在IB里面构建，布局，宽度不设置固定或者靠右边
    @IBOutlet open weak var label: UILabel!
    @IBInspectable open var alignment: NSTextAlignment = .left
    //需要赋值才能跑起来
    @IBInspectable open var text: String? {
        didSet {
            setup()
        }
    }
    @IBInspectable open var att: NSAttributedString? {
        didSet {
            setup()
        }
    }
    var isLoad = false

    override open func awakeFromNib() {
        super.awakeFromNib()
        
        isLoad = true
        setup()
    }
    
    func setup() {
        
        guard isLoad else {return}

        if let s = att {
            label.layer.removeAllAnimations()
            label.attributedText = s
            label.layoutIfNeeded()
            Queue.main.executeAfter(seconds: 0.3, closure: { [weak self] in self?.circleText()})
        }else if let s = text, s.count > 0 {
            label.layer.removeAllAnimations()
            label.text = s
            label.layoutIfNeeded()
            Queue.main.executeAfter(seconds: 0.3, closure: { [weak self] in self?.circleText()})
        }
    }
    
    func circleText() {
        
        guard label.w > self.w else {
            if alignment != .left {
                label.textAlignment = alignment
                label.snp.updateConstraints({
                    $0.right.equalToSuperview()
                })
            }
            return
        }
        label.textAlignment = .left
        label.snp.updateConstraints({
            $0.right.greaterThanOrEqualToSuperview()
        })
        let r1 = frame
        let r2 = label.frame
        animatedRelayout()
        let a = CABasicAnimation(keyPath: "position.x")
        a.fromValue = r2.size.width / 2
        a.toValue = -r2.size.width / 2
        a.duration = CFTimeInterval(label.w / 35)
        a.beginTime = 1
        
        let a1 = CABasicAnimation(keyPath: "position.x")
        a1.fromValue = r1.size.width + r2.size.width / 2
        a1.toValue = r2.size.width / 2
        a1.duration = a.duration * CFTimeInterval(r1.width / r2.width)
        a1.beginTime = a.duration + 1
        
        let group = CAAnimationGroup()
        group.animations = [a, a1]
        group.duration = a.duration + a1.duration + 1
        group.repeatCount = Float.infinity
        group.isRemovedOnCompletion = false
        group.timingFunction = CAMediaTimingFunction(name: .linear)
        
        label.layer.add(group, forKey: "PaomaLabelAnimation")
    }
}

