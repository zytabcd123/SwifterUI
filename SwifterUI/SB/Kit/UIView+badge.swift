//
//  UIView+Badge.swift
//  show
//
//  Created by ovfun on 16/7/4.
//  Copyright © 2016年 牛至网. All rights reserved.
//

import Foundation
import SnapKit

public enum BadgeType {
    case spot(Int?)
    case numbers(Int?)
    case N(Int?)
    case S(String?, UIColor)
}

extension UIView {
        
    private struct ZHBadge {
        static var badge = "ZHBadgeView"
    }
    
    private weak var badge: UIView? {
        get {
            return objc_getAssociatedObject(self, &ZHBadge.badge) as? UIView
        }
        
        set {
            objc_setAssociatedObject(self, &ZHBadge.badge, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    /// 给视图添加气泡
    ///
    /// - Parameters:
    ///   - type: 气泡类型
    ///   - offset: 默认偏移量为0 当视图是矩形的时候气泡中点在右上角，为圆形的时候气泡贴圆形内弧线
    public func badge(_ type: BadgeType, offset: CGFloat = 0, offsetX: CGFloat = 0,  offsetY: CGFloat = 0, isBarItem: Bool = false) {
        
        badge?.removeFromSuperview()
        switch type {
        case .spot(let count):
            
            guard let c = count , c > 0 else {return }
            let v = UIView()
            v.backgroundColor = UIColor(hex: 0xff4444)
            v.setCornerRadius(radius: 4.0)
            self.addSubview(v)
//            self.layer.masksToBounds = false
            
            v.snp.makeConstraints({

                $0.size.equalTo(CGSize(width: 8, height: 8))
                $0.top.equalTo(self).inset(offset + offsetY)
                $0.right.equalTo(self).inset(offset - offsetX)
            })
            
            badge = v
        case .numbers(let count):
            
            guard let c = count , c > 0 else {return }
            
            let v = UIView()
            v.backgroundColor = UIColor(hex: 0xff4444)
            v.setCornerRadius(radius: 8.0)
            if isBarItem {
                self.addSubview(v)
            }else {
                self.superview?.addSubview(v)
            }
//            self.layer.masksToBounds = false
            
            let l = UILabel()
            l.textAlignment = .center
            l.font = UIFont.systemFont(ofSize: 12)
            l.textColor = UIColor.white
            l.text = c > 99 ? "99+" : "\(c)"
            l.numberOfLines = 1
            v.addSubview(l)
            
            l.snp.makeConstraints({ $0.edges.equalTo(v).inset(UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)) })
            v.snp.makeConstraints({
                
                ///圆形视图偏移量
                var i: CGFloat = 0
                if self.w == self.h && self.layer.cornerRadius == self.w / 2 {
                    
                    let c = (sqrt(CGFloat(2 * self.w * self.w)) - self.w) / 2
                    i = sqrt((c * c) / 2)
                }
                $0.height.equalTo(16)
                $0.width.greaterThanOrEqualTo(16)
                $0.top.equalTo(self).inset(i - 8 + offset + offsetY)
                $0.centerX.equalTo(self).inset(self.w / 2 - i + offset + offsetX)
            })
            
            badge = v
        case .N(let count):
            
            guard let c = count , c > 0 else {return }
            
            let v = UIView()
            v.backgroundColor = UIColor(hex: 0xff4444)
            v.setCornerRadius(radius: 8.0)
            if isBarItem {
                self.addSubview(v)
            }else {
                self.superview?.addSubview(v)
            }
            //            self.layer.masksToBounds = false
            
            let l = UILabel()
            l.textAlignment = .center
            l.font = UIFont.systemFont(ofSize: 12)
            l.textColor = UIColor.white
            l.text = "N"
            l.numberOfLines = 1
            v.addSubview(l)
            
            l.snp.makeConstraints({ $0.edges.equalTo(v).inset(UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)) })
            v.snp.makeConstraints({
                
                ///圆形视图偏移量
                var i: CGFloat = 0
                if self.w == self.h && self.layer.cornerRadius == self.w / 2 {
                    
                    let c = (sqrt(CGFloat(2 * self.w * self.w)) - self.w) / 2
                    i = sqrt((c * c) / 2)
                }
                $0.height.equalTo(16)
                $0.width.greaterThanOrEqualTo(16)
                $0.top.equalTo(self).inset(i - 8 + offset + offsetY)
                $0.centerX.equalTo(self).inset(self.w / 2 - i + offset + offsetX)
            })
            
            badge = v
        case .S(let str, let c):
            
            guard let s = str , s.count > 0 else {return }
            
            let v = UIView()
            v.backgroundColor = c
            v.setCornerRadius(radius: 8.0)
            if isBarItem {
                self.addSubview(v)
            }else {
                self.superview?.addSubview(v)
            }
            //            self.layer.masksToBounds = false
            
            let l = UILabel()
            l.textAlignment = .center
            l.font = UIFont.systemFont(ofSize: 12)
            l.textColor = UIColor.white
            l.text = s
            l.numberOfLines = 1
            v.addSubview(l)
            
            l.snp.makeConstraints({ $0.edges.equalTo(v).inset(UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)) })
            v.snp.makeConstraints({
                
                ///圆形视图偏移量
                var i: CGFloat = 0
                if self.w == self.h && self.layer.cornerRadius == self.w / 2 {
                    
                    let c = (sqrt(CGFloat(2 * self.w * self.w)) - self.w) / 2
                    i = sqrt((c * c) / 2)
                }
                $0.height.equalTo(16)
                $0.width.greaterThanOrEqualTo(16)
                $0.top.equalTo(self).inset(i - 8 + offset + offsetY)
                $0.right.equalTo(self)
//                $0.centerX.equalTo(self).inset(self.w / 2 - i + offset + offsetX)
            })
            
            badge = v
        }
    }
    
}

extension UIBarButtonItem {
    
    public func badge(_ type: BadgeType, offset: CGFloat = 0, offsetX: CGFloat = 0,  offsetY: CGFloat = 0) {
        
        if customView == nil {

            customView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30)).then({
                
                let v = UIImageView(image: image?.withRenderingMode(.automatic))
                v.center = $0.center
                v.isUserInteractionEnabled = true
                $0.addSubview(v)
                
                let ges = UITapGestureRecognizer(target: target, action: action)
                v.addGestureRecognizer(ges)
            })
        }
        
        customView?.badge(type, offset: offset, offsetX: offsetX, offsetY: offsetY, isBarItem: true)
    }
}


