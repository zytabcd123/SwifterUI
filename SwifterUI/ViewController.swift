//
//  ViewController.swift
//  SwifterUI
//
//  Created by uke on 2019/11/6.
//  Copyright © 2019 uke. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var tab: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tab.alwaysBounceVertical = true
        tab.addHeaderRefresh {
            
        }
    }

    @IBAction func timer() {


    }
}
