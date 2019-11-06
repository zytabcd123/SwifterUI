//
//  UIScrollView+.swift
//  secret
//
//  Created by mc on 2017/9/11.
//  Copyright © 2017年 mc. All rights reserved.
//

import Foundation

extension UIScrollView {
    
    public enum ScrollPosition {
        case top
        case bottom
        case left
        case right
    }
    
    public func scrollsTo(_ position: ScrollPosition, animated: Bool = true) {
        var offset: CGPoint!
        defer { setContentOffset(offset, animated: animated) }
        switch position {
        case .top:      offset = CGPoint(x: contentOffset.x, y: 0)
        case .bottom:   offset = CGPoint(x: contentOffset.x, y: bottomOffsetY)
        case .left:     offset = CGPoint(x: 0,               y: contentOffset.y)
        case .right:    offset = CGPoint(x: rightOffsetX,    y: contentOffset.y)
        }
    }
    
    var bottomOffsetY: CGFloat { return max(0, contentSize.height - bounds.height) }
    var rightOffsetX: CGFloat { return max(0, contentSize.width - bounds.width) }
    
    
    public func scrollBy(x: CGFloat = 0, y: CGFloat = 0, animated: Bool = true) {
        let offset = contentOffset + CGPoint(x: x, y: y)
        setContentOffset(offset, animated: animated)
    }
    
    public var remainHeight: CGFloat {
        return max(0, contentSize.height - (contentOffset.y + bounds.height))
    }
}
