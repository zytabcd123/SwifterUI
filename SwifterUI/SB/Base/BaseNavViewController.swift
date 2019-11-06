//
//  BaseNavViewController.swift
//  SwifterUI
//
//  Created by uke on 2019/11/6.
//  Copyright © 2019 uke. All rights reserved.
//

import Foundation
import UIKit

open class BaseNavViewController: UINavigationController {
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()


    }
    
    deinit {
        print(String(describing: type(of: self)), #function)
    }
}
