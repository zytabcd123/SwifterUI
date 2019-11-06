//
//  BaseVcProtocol.swift
//  SwifterUI
//
//  Created by uke on 2019/11/6.
//  Copyright © 2019 uke. All rights reserved.
//

import UIKit

public protocol BaseViewControllerProtocol: UIGestureRecognizerDelegate {
    
    func gestureBack(_ open: Bool)
}

extension BaseViewControllerProtocol where Self: UIViewController {

    public func gestureBack(_ open: Bool) {
    
        if (self.navigationController?.viewControllers.count ?? 0) > 1 {
            
            self.navigationController?.interactivePopGestureRecognizer!.isEnabled = open
            self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        }else {
            
            self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
        }
    }
}

