//
//  ViewController.swift
//  secret
//
//  Created by mc on 2017/8/14.
//  Copyright © 2017年 mc. All rights reserved.
//

import Foundation

extension UIViewController {
    /**
     Return a viewController's parentViewController which is a given Type, Usage:
     ```swift
     return viewController.parentViewControllerWithType(LoginContainerViewController)
     ```
     Above code shows how to get viewController's parent LoginContainerViewController
     */
    public func parentViewControllerWithType<VC: UIViewController>(_ type: VC.Type) -> VC? {
        var parentViewController = self.parent
        while parentViewController != nil {
            if let viewController = parentViewController as? VC {
                return viewController
            }
            parentViewController = parentViewController!.parent
        }
        return nil
    }
    
    /**
     Return a viewController's childViewController which is a given Type, Usage:
     ```swift
     return viewController.childViewControllerWithType(QQPlayerViewController)
     ```
     Above code shows how to get viewController's child QQPlayerViewController
     */
    public func childViewControllerWithType<ViewController: UIViewController>(_ type: ViewController.Type) -> ViewController? {
        /**
         recursion to get childViewController.
         here is exmple to show the search order number:
         rootViewController:                           0
         childViewControllers:                         1         5         9
         childViewControllers's childViewControllers:  2 3 4     6 7 8     10 11 12
         */
        for childViewController in children {
            if let viewController = childViewController as? ViewController {
                return viewController
            }
            
            if let viewController = childViewController.childViewControllerWithType(ViewController.self) {
                return viewController
            }
        }
        return  nil
    }
    
    //获取当前的nvc
    public func getCurrentNavigationController()->UINavigationController?{
        var parent: UIViewController?
        if let window = UIApplication.shared.delegate?.window,let rootVC = window?.rootViewController {
            parent = rootVC
            while (parent?.presentedViewController != nil) {
                parent = parent?.presentedViewController!
            }
            
            if let tabbar = parent as? UITabBarController ,let nav = tabbar.selectedViewController as? UINavigationController {
                return nav
            }else if let nav = parent as? UINavigationController {
                return nav
            }
        }
        return nil
    }
    
    //pop回指定类名的控制器
    public func backToController(ctrlClassName : String,animated : Bool){

    }
}


extension UIViewController {
    
    public func setNavColor(_ color: UIColor, shadowColor: UIColor, translucent: Bool) {
        self.navigationController?.navigationBar.setNavigationBarColor(color, shadowColor: shadowColor, translucent: translucent)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    public func setNavTitle(color: UIColor? = nil, font: UIFont? = nil) {
        
        var d: [NSAttributedString.Key : Any] = [:]
        if let c = color {
            d[NSAttributedString.Key.foregroundColor] = c
        }
        if let f = font {
            d[NSAttributedString.Key.font] = f
        }
        navigationController?.navigationBar.titleTextAttributes = d
    }
}

public protocol NavigationItemProtocol {
    func setupLeftItem() -> UIButton
    
    func leftItemAction(_ sender: UIButton?)
}

extension UIViewController: NavigationItemProtocol {
    public func setupLeftItem() -> UIButton {
        let leftItem = UIButton()
        leftItem.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        leftItem.setImage(UIImage(named: "back"), for: .normal)
        leftItem.setImage(UIImage(named: "back"), for: .highlighted)
        leftItem.imageView?.contentMode = .scaleToFill
        leftItem.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        leftItem.addTarget(self, action: #selector(leftItemAction(_:)), for: .touchUpInside)
        leftItem.imageEdgeInsets.left = -25
        //.... Set Right/Left Bar Button item
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftItem)
        return leftItem
    }
    
    @objc open func leftItemAction(_ sender: UIButton?) {
        self.view.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
}
