//
//  HUD.swift
//  Education
//
//  Created by ovfun on 15/12/9.
//  Copyright © 2015年 牛至网. All rights reserved.
//

import Foundation

public struct HUD {
    
    public static var myHud: MBProgressHUD?
    
    public static func showInKeyWindow(_ mode: MBProgressHUDMode = .indeterminate, title: String? = nil, delayHide: TimeInterval? = nil) {
        
        if myHud == nil {
            
            myHud = MBProgressHUD(window: UIApplication.shared.keyWindow)
        }
        HUD.reset()
        
        UIApplication.shared.keyWindow?.addSubview(myHud!)
        myHud?.mode = mode
        myHud?.detailsLabelText = title
        myHud?.detailsLabelFont = UIFont.systemFont(ofSize: 16)
        myHud?.yOffset = 40
        myHud?.show(true)
        
        if let d = delayHide {
            
            HUD.hide(true, delayHide: d)
        }
    }
    
    public static func showInView(_ view: UIView?, mode: MBProgressHUDMode = .indeterminate, title: String? = nil, delayHide: TimeInterval? = nil) {
        
        guard let v = view else {return}
        if myHud == nil {
            myHud = MBProgressHUD(view: v)
        }
        HUD.reset()
        
        v.addSubview(myHud!)
        myHud?.mode = mode
        myHud?.detailsLabelText = title
        myHud?.detailsLabelFont = UIFont.systemFont(ofSize: 16)
        myHud?.show(true)
        
        if let d = delayHide {
            
            HUD.hide(true, delayHide: d)
        }
    }
    
    public static func showToast(_ title: String?) {
        HUD.showInKeyWindow(.text, title: title, delayHide: 2)
    }
    
    public static func hide(_ animat: Bool = true, delayHide: TimeInterval? = nil) {
        
        myHud?.hide(animat, afterDelay: delayHide ?? 0)
    }
    
    static func reset() {
        
        HUD.myHud?.labelText = nil
        HUD.myHud?.hide(false)
        HUD.myHud?.mode = .indeterminate
        HUD.myHud?.detailsLabelText = nil
    }
}

extension UIView {
    
    public func showHUD(_ mode: MBProgressHUDMode = .indeterminate, title: String? = nil, delayHide: TimeInterval? = nil) {
        
        HUD.showInView(self, mode: mode, title: title, delayHide: delayHide)
    }
}

extension UIViewController {
    
    public func showHUD(_ mode: MBProgressHUDMode = .indeterminate, title: String? = nil, delayHide: TimeInterval? = nil) {
        
        HUD.showInView(self.view, mode: mode, title: title, delayHide: delayHide)
    }
}
