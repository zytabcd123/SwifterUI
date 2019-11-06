//
//  AlbumSelectPicker.swift
//  secret
//
//  Created by mc on 2017/9/12.
//  Copyright © 2017年 mc. All rights reserved.
//

import UIKit
import Photos


open class AlbumSelectPicker: UIViewController, IsInImageStoryboard {
    
    typealias Section = ImageSelectPicker.Section
    var didSelectedBlock: ((Int, String?) -> ())?
    var didCancelBlock: (() -> ())?
    @IBOutlet weak var myTableView: UITableView!
    var albums = [Section]()

    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
    }

    @IBAction func didCancelBtAction() {
        
        dismiss(animated: true, completion: nil)
        didCancelBlock?()
    }
}

// MARK: - Table view data source

extension AlbumSelectPicker: UITableViewDelegate, UITableViewDataSource {
    open func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return albums.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sec = albums[indexPath.row]
        let cell = AlbumTableCell.dequeue(from: tableView)
        cell.photoView.setAssetImage(ass: sec.asset.lastObject, size: CGSize(width: 320, height: 320))
        cell.titleLabel.text = sec.collection.localizedTitle
        cell.countLabel.text = "(\(sec.asset.count))"
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sec = albums[indexPath.row]
        didSelectedBlock?(indexPath.row,sec.collection.localizedTitle)
        didCancelBtAction()
    }
}



