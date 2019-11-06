//
//  UIViewController+Alert.swift
//  apc
//
//  Created by ovfun on 2017/1/3.
//  Copyright © 2017年 @天意. All rights reserved.
//

import Foundation

extension UIViewController {
    
    /**
     显示系统样式actionSheet
     
     - parameter title:          标题
     - parameter msg:            信息
     - parameter actions:        按钮
     - parameter didSelectBlock: 按钮回调，idx为actions数组的下标
     */
    public func showActionSheet(_ title: String?, msg: String? = nil, actions: [String], didSelectBlock: ((Int) -> Void)?){
        
        let actionSheet = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
        
        if actionSheet.popoverPresentationController != nil {//ipad中没有ActionSheet组件，直接用Alert样式替换
            
            let actions = actions + ["取消"]
            showAlert(title, msg: msg, actions: actions, didSelectBlock: didSelectBlock)
            return
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (ac) -> Void in
            
            didSelectBlock?(-1)
            actionSheet.dismiss(animated: true, completion: nil)
        }
        actionSheet.addAction(cancel)
        
        for (idx, str) in actions.enumerated(){
            
            let action = UIAlertAction(title: str, style: .default) { (ac) -> Void in
                
                print("\(idx),\(str)")
                didSelectBlock?(idx)
            }
            actionSheet.addAction(action)
        }
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    /**
     显示系统样式Alertview
     
     - parameter title:          警告标题
     - parameter msg:            警告内容
     - parameter actions:        警告操作按钮
     - parameter didSelectBlock: 按钮回调，idx为actions数组的下标
     */
    public func showAlert(_ title: String?, msg: String? = nil, actions: [String], didSelectBlock: ((Int) -> Void)?){
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        for (idx, str) in actions.enumerated(){
            
            let action = UIAlertAction(title: str, style: .default) { (ac) -> Void in
                
                print("\(idx),\(str)")
                didSelectBlock?(idx)
            }
            alert.addAction(action)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}
