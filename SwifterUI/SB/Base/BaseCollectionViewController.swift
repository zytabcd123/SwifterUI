//
//  BaseCollectionViewController.swift
//  SwifterUI
//
//  Created by uke on 2019/11/6.
//  Copyright © 2019 uke. All rights reserved.
//

import Foundation
import UIKit

open class BaseCollectionViewController: UICollectionViewController,BaseViewControllerProtocol {
    
    public var didBackBlock: (() -> ())?

    deinit {
        print(String(describing: type(of: self)), #function)
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        self.gestureBack(true)
    }

    @IBAction open func backButtontClick(){
        didBackBlock?()
        if (self.navigationController?.children.count ?? 0) > 1{
            
            self.navigationController?.popViewController(animated: true)
        }else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // 在使用 Container View 时，把子控制器的 didMoveToParentViewController 方法当作 viewDidLoad 事件使用时，有时候会被运行 2 次, 有可能会产生 Bug
    // 此时可以用 viewDidEmbeded 取代 didMoveToParentViewController, viewDidEmbeded 方法只会运行 1 次
    override open func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)

        if embeded {
            didBackBlock?()
            print("离开:",String(describing: type(of: self)), #function)
        }

        if !embeded {
            embeded = true
            viewDidEmbeded()
        }
    }
    fileprivate var embeded = false
    open func viewDidEmbeded() {}
}
