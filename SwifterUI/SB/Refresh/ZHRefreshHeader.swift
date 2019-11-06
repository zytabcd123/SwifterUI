//
//  ZHRefreshHeader.swift
//  apc
//
//  Created by mc on 2018/1/30.
//  Copyright © 2018年 @天意. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

open class ZHRefreshHeader: UIRefreshControl {
    
    var didStartRefresh: (() -> ())?
    fileprivate var myScrollView: UIScrollView!
    lazy var refreshView: BallAnimationView = {
        let v = BallAnimationView(frame: self.bounds)
        v.tintColor = self.myScrollView.tintColor
        self.insertSubview(v, at: 0)
        self.beginRefreshing()
        return v
    }()
    var disBag = DisposeBag()

    
    var didRefreshed = false
    var canStartRefresh = false {
        didSet{
            if canStartRefresh && isAnimation && !self.didRefreshed {
                self.didRefreshed = true
                self.didStartRefresh?()
            }
        }
    }
    var isAnimation = false

    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let v = newSuperview as? UIScrollView else {return}
        self.backgroundColor = UIColor.clear
        
        self.myScrollView = v
        addObserve()
    }
    
    override open func beginRefreshing() {
        
        guard !isAnimation else {return}
        isAnimation = true
        self.refreshView.start()
    }
    
    override open func endRefreshing() {
        
        guard isAnimation else {return}
        refreshView.stop()
        isAnimation = false
        didRefreshed = false
        super.endRefreshing()
    }

    public func addObserve() {
        
        self.myScrollView
            .rx.observe(CGPoint.self, "contentOffset")
            .filter { $0 != nil }
            .map { $0! }
            .do(onNext: { [weak self] point in
                guard point.y <= 0 else {return}
                let p = CGFloat(min(50, abs(point.y * 2))) / CGFloat(50)
                self?.refreshView.setProgress(p)
            })
            .subscribe(onNext: { [weak self] point in
                guard let `self` = self else {return}
                self.canStartRefresh = self.isRefreshing && !self.myScrollView.isDragging
                guard point.y < 0, !self.isRefreshing else {return}

                self.beginRefreshing()
            })
            .disposed(by: disBag)
    }
}
