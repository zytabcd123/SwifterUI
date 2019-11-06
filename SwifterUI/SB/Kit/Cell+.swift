//
//  Cell+.swift
//  secret
//
//  Created by mc on 2017/7/19.
//  Copyright © 2017年 mc. All rights reserved.
//

import Foundation

// UITableViewCell
public protocol IsTableViewCell {}
extension UITableViewCell: IsTableViewCell {}
extension IsTableViewCell where Self: UITableViewCell {
    
    public static func dequeue(from tableView: UITableView) -> Self {
        let identifier = String(describing: self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? Self else  {
            fatalError("Can't get \(identifier) from tableView!")
        }
        return cell
    }
}


// UICollectionViewCell
public protocol IsCollectionViewCell {}
extension UICollectionViewCell: IsCollectionViewCell {}
extension IsCollectionViewCell where Self: UICollectionViewCell {
    
    public static func dequeue(from collectionView: UICollectionView, forIndexPath indexPath: IndexPath) -> Self {
        let identifier = String(describing: self)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? Self else  {
            fatalError("Can't get \(identifier) from collectionView!")
        }
        return cell
    }
    
    public static func dequeue(from collectionView: UICollectionView, forIndex index: Int) -> Self {
        return dequeue(from: collectionView, forIndexPath: IndexPath(item: index, section: 0))
    }
}
