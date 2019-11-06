//
//  ZHRefresh.swift
//  apc
//
//  Created by ovfun on 16/6/2.
//  Copyright © 2016年 @天意. All rights reserved.
//

import Foundation
import RxSwift

public let MinOffsetToPull: CGFloat = 20.0
public let LoadingViewSize: CGFloat = 50.0

public enum ZHRefreshState: Int {
    
    case stopped
    case dragging
    case animatingBounce
    case loading
    case animatingToStopped
    
    func isAnyOf(_ values: [ZHRefreshState]) -> Bool {
        return values.contains(where: { $0 == self })
    }
}

extension UIScrollView {
    
    private struct ZHRefreshViewKeys {
        static var header = "ZHRefreshHeaderView"
        static var footer = "ZHRefreshFooterView"
        static var nextPageIndex = "ZHRefreshNextPageIndex"
        static var hasNextPage = "ZHRefreshHasNextPage"
        static var disBag = "ZHDisBag"
    }
    
    fileprivate var disBag: DisposeBag {
        get {
            if let result = objc_getAssociatedObject(self, &ZHRefreshViewKeys.disBag) as? DisposeBag {
                return result
            }
            let result = DisposeBag()
            objc_setAssociatedObject(self, &ZHRefreshViewKeys.disBag, result, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return result
        }
        
        set {
            objc_setAssociatedObject(self, &ZHRefreshViewKeys.disBag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public weak var header: ZHRefreshHeader? {
        get {
            return objc_getAssociatedObject(self, &ZHRefreshViewKeys.header) as? ZHRefreshHeader
        }
        
        set {
            objc_setAssociatedObject(self, &ZHRefreshViewKeys.header, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public weak var footer: ZHRefreshFooter? {
        get {
            return objc_getAssociatedObject(self, &ZHRefreshViewKeys.footer) as? ZHRefreshFooter
        }
        
        set {
            objc_setAssociatedObject(self, &ZHRefreshViewKeys.footer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var nextPage: Int {
        get { return objc_getAssociatedObject(self, &ZHRefreshViewKeys.nextPageIndex) as? Int ?? 1}
        set {
            objc_setAssociatedObject(self, &ZHRefreshViewKeys.nextPageIndex, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    public var hasNextPage: Bool {
        get { return objc_getAssociatedObject(self, &ZHRefreshViewKeys.hasNextPage) as? Bool ?? false}
        set {
            objc_setAssociatedObject(self, &ZHRefreshViewKeys.hasNextPage, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    public func addHeaderRefresh(_ start: @escaping () -> () ) {
        
        isMultipleTouchEnabled = false
        panGestureRecognizer.maximumNumberOfTouches = 1
        
        let r = ZHRefreshHeader()
        r.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        self.header = r
        r.didStartRefresh = {
            DispatchQueue.executeAfter(seconds: 1.2, closure: { [weak self] in
                self?.nextPage = 1
                start()
            })
        }
        addSubview(r)
        self.header?.isUserInteractionEnabled = false
        self.nextPage = 1
    }
    
    public func addFooterRefreshAutoHidden(_ start: @escaping () -> () ) {
        
        isMultipleTouchEnabled = false
        panGestureRecognizer.maximumNumberOfTouches = 1
        
        let r = ZHRefreshFooter()
        self.footer = r
        r.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { start() })
            .disposed(by: disBag)
        addSubview(r)
        self.footer?.isUserInteractionEnabled = false
        self.hiddenFooter = true
        self.showNoMore(nomore: false)
    }
    
    public func endRefresh(sourceCount: Int) {
        
        endHeaderRefresh()
        endFooterRefresh()
        nextPage += 1
        hasNextPage = sourceCount > 0
        if !hasNextPage, self.footer?.hasContent ?? false {
            self.hiddenFooter = false
            showNoMore(nomore: true)
        }else {
            self.hiddenFooter = !hasNextPage
        }
    }
    
    public func showNoMore(nomore: Bool) {
        
        if nomore {
            self.footer?.showNomore()
        }else {
            self.footer?.hiddenNomore()
        }
    }
    
    public func endErrorRefresh() {
        
        endHeaderRefresh()
        endFooterRefresh()
    }
    
    public func removeHeaderRefresh() {
        
        self.header?.removeFromSuperview()
    }
    
    fileprivate func endHeaderRefresh() {
        
        header?.endRefreshing()
    }
    
    fileprivate func endFooterRefresh() {
        
        footer?.endRefreshing()
    }
    
    ///显示隐藏footer
    fileprivate var hiddenFooter: Bool {
        
        get {return footer?.isHidden ?? false}
        set {footer?.isHidden = newValue}
    }
    
    fileprivate var hiddenHeader: Bool {
        
        get {return header?.isHidden ?? false}
        set {header?.isHidden = newValue}
    }
}

extension DispatchQueue {
    
    fileprivate static func executeAfter(seconds: TimeInterval, closure: @escaping () -> Void) {
        let delay = DispatchTime.now() + seconds
        DispatchQueue.main.asyncAfter(deadline: delay, execute: closure)
    }
}
