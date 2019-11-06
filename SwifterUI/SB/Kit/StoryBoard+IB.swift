//
//  StoryBoard+IBInspectable.swift
//  apc
//
//  Created by ovfun on 16/3/15.
//  Copyright © 2016年 @天意. All rights reserved.
//

import Foundation

public protocol IsInStoryboard: IsInBundle {
    static var storyboardName: String { get }
}

public extension IsInStoryboard where Self: UIViewController {
    
    static func fromStoryboard() -> Self {
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: "\(self)") as! Self
    }
}

/// 提供在 StoryBoard 设置 View 的常用属性能力，如：圆角半径，镶边宽度和颜色
extension UIView {
    
    @IBInspectable
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor? {
        get {
            return layer.borderColor?.uiColor
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension CGColor {
    
    public var uiColor: UIColor {
       
        return UIColor(cgColor: self)
    }
}

extension UITableView {
   
    @IBInspectable
    public var CellSelfSized: Bool {
       
        get {
           
            return rowHeight == UITableView.automaticDimension
        }
        set(enable) {
            if enable {
                estimatedRowHeight = rowHeight
                rowHeight = UITableView.automaticDimension
            }
        }
    }
}

extension UICollectionView {
 
    @IBInspectable
    public var CellSelfSized: Bool {
      
        get {
           
            guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return false }
            return layout.estimatedItemSize != CGSize.zero
        }
        set(enable) {
            if enable {
               
                guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
                layout.estimatedItemSize = layout.itemSize
            }
        }
    }
}
