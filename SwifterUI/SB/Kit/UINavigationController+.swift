//
//  UINavigationController+.swift
//  apc
//
//  Created by lee on 2018/12/14.
//  Copyright © 2018 uke. All rights reserved.
//

import Foundation

extension UINavigationController {
    // MARK: - 返回当前顶部视图控制器
    open class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        return controller
    }
}

extension UINavigationBar {
    
    public func setNavigationBarColor(_ color: UIColor, shadowColor: UIColor, translucent: Bool) {
        
        self.isTranslucent = translucent
        self.setBackgroundImage(image(color), for: .topAttached, barMetrics: .default)
        //        self.setBackgroundImage(image(color), for: .default)
        self.barStyle = translucent ? .blackTranslucent : .default
        self.shadowImage = shadowImage(shadowColor)
        self.barTintColor = color
    }
    
    private func image(_ color: UIColor) -> UIImage {
        
        let r = CGRect(x: 0, y: 0, width: UIScreen.w, height: 64)
        UIGraphicsBeginImageContextWithOptions(r.size, false, 0)
        color.setFill()
        UIRectFill(r)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
    }
    
    private func shadowImage(_ navColor: UIColor) -> UIImage?{
        
        //        if navColor == UIColor.clear {
        //
        //            return UIImage()
        //        }
        
        let r = CGRect(x: 0, y: 0, width: UIScreen.w, height: 0.3)
        UIGraphicsBeginImageContextWithOptions(r.size, false, 0)
        //        let color = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
        //        color.setFill()
        navColor.setFill()
        UIRectFill(r)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
    }
}
