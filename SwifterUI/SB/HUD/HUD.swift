//
//  HUD.swift
//  SwifterUI
//
//  Created by uke on 2019/11/6.
//  Copyright © 2019 uke. All rights reserved.
//

import Foundation

public struct HUD {
        
    static var myHud: MBProgressHUD?
    public static func showInKeyWindow(_ mode: MBProgressHUDMode = .indeterminate, title: String? = nil, delayHide: TimeInterval? = nil) {
        guard let v = UIApplication.shared.windows.last else {return print("HUD找不到keyWindow")}
        let hd = MBProgressHUD.showAdded(to: v, animated: true)
        hd.mode = mode
        hd.label.text = title
        myHud = hd
        if let t = delayHide {
            hd.hide(animated: true, afterDelay: t)
        }
    }
    
    public static func showInView(_ view: UIView, mode: MBProgressHUDMode = .indeterminate, title: String? = nil, delayHide: TimeInterval? = nil) {
        let hd = MBProgressHUD.showAdded(to: view, animated: true)
        hd.mode = mode
        hd.label.text = title
        myHud = hd
        if let t = delayHide {
            hd.hide(animated: true, afterDelay: t)
        }
    }
    
    public static func showToast(_ title: String?) {
        HUD.showInKeyWindow(.text, title: title, delayHide: 2)
    }
    
    public static func hide(_ animat: Bool = true, delayHide: TimeInterval? = nil) {
        myHud?.hide(animated: animat, afterDelay: delayHide ?? 0)
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
