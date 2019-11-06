//
//  ZHRefreshFooter.swift
//  apc
//
//  Created by ovfun on 16/6/2.
//  Copyright © 2016年 @天意. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class ZHRefreshFooter: UIControl {
    
    
    fileprivate var myScrollView: UIScrollView!
    fileprivate var contentInset: UIEdgeInsets!
    private lazy var refreshView = UIActivityIndicatorView(style: .white)
    private var nomoreView: UIView?
    private var isShowNomore = false
    var disBag = DisposeBag()
    var hasContent: Bool {
        return myScrollView.contentSize.height > 44
    }
    
    fileprivate(set) var refreshState: ZHRefreshState = .stopped {
        
        willSet{
            
            if refreshState == .dragging && newValue == .animatingBounce {
                
                statAnimating()
            } else if newValue == .loading {
                
                beginRefreshing()
            } else if newValue == .animatingToStopped {
                
                stopAnimation()
            } else if newValue == .stopped {
                
            }
        }
    }
    
    
    init () {
        super.init(frame: CGRect.zero)
        
        self.addSubview(refreshView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let v = newSuperview as? UIScrollView else {return}
        self.backgroundColor = UIColor.clear
        
        self.myScrollView = v
        self.contentInset = v.contentInset
        addObserve()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard refreshState != .animatingBounce else {return}
        
        let y = max(myScrollView.contentSize.height, 0)
        self.frame = CGRect(x: 0, y: y, width: myScrollView.frame.size.width, height: LoadingViewSize)
        self.refreshView.color = UIColor.black
        self.refreshView.frame = CGRect(x: 0, y: (self.frame.size.height - refreshView.frame.size.height) / 2, width: UIScreen.main.bounds.size.width, height: 44)
    }
    
    public func showNomore() {
        
        guard !isShowNomore else {return}
        isShowNomore = true
        
        print(myScrollView.contentInset, myScrollView.contentSize, myScrollView.contentOffset)
        self.nomoreView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.nomoreView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        self.addSubview(nomoreView!)
        
        let lv = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        lv.font = UIFont.systemFont(ofSize: 14)
        lv.text = "没有更多"
        lv.textAlignment = .center
        lv.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        
        self.nomoreView?.addSubview(lv)
        
        self.myScrollView.contentInset.bottom += self.frame.size.height
    }
    
    public func hiddenNomore() {
        
        guard isShowNomore else {return}
        isShowNomore = false
        self.nomoreView?.removeFromSuperview()
        myScrollView.contentInset.bottom = contentInset.bottom
    }
    
    public func statAnimating() {
        
        guard !isHidden, !isShowNomore else {return}
        
        refreshView.startAnimating()
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: { [weak self] in
            
            self?.myScrollView.contentInset.bottom += self?.frame.size.height ?? 0
        }) { [weak self] _ in
            
            self?.refreshState = .loading
        }
    }
    
    public func stopAnimation() {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: { [weak self] in
            
            self?.myScrollView.contentInset.bottom = self?.contentInset.bottom ?? 0
        }) { [weak self] _ in
            
            self?.refreshView.stopAnimating()
            self?.refreshState = .stopped
        }
    }
    
    public func beginRefreshing() {
        
        sendActions(for: .valueChanged)
    }
    
    public func endRefreshing() {
        
        if refreshState == .stopped {return}
        
        refreshState = .animatingToStopped
    }
    
    public override var isHidden: Bool {
        
        willSet{
            
            if myScrollView.contentInset == contentInset {
                return
            }
            
            if !isHidden && newValue && refreshState == .animatingToStopped {
                
                refreshState = .stopped
                myScrollView.contentInset.bottom = self.contentInset.bottom
            }else if isHidden && !newValue && refreshState == .animatingToStopped {
                
                refreshState = .stopped
                myScrollView.contentInset.bottom += self.frame.size.height
                self.frame = CGRect(origin: CGPoint(x: self.frame.origin.x, y: myScrollView.contentSize.height), size: self.frame.size)
            }else {
                
                refreshState = .stopped
                myScrollView.contentInset.bottom = contentInset.bottom
            }
        }
    }
}

extension ZHRefreshFooter {
    
    public func addObserve() {
        
        self.myScrollView
            .rx.observe(CGPoint.self, "contentOffset")
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in self?.observeContentOfSet()})
            .disposed(by: disBag)
        
        self.myScrollView
            .rx.observe(CGRect.self, "frame")
            .subscribe(onNext: { [weak self] _ in self?.observeFrame() })
            .disposed(by: disBag)
        
        self.myScrollView
            .rx.observe(UIGestureRecognizer.State.self, "panGestureRecognizer.state")
            .subscribe(onNext: { [weak self] _ in self?.observePanGestureRecognizer() })
            .disposed(by: disBag)
    }
    
    public func observeContentOfSet() {
        
        scrollViewDidChangeContentOffset(myScrollView.isDragging)
        layoutSubviews()
    }
    
    public func observePanGestureRecognizer() {
        
        let gestureState = myScrollView.panGestureRecognizer.state
        if gestureState.isAnyOf([.ended, .cancelled, .failed]) {
            
            scrollViewDidChangeContentOffset(false)
        }
    }
    
    public func observeFrame() {
        
        layoutSubviews()
    }
    
    
    private func scrollViewDidChangeContentOffset(_ dragging: Bool) {
        
        if refreshState == .stopped && dragging {
            
            refreshState = .dragging
        } else if refreshState == .dragging && dragging == false {
            
            if myScrollView.contentInset.top + myScrollView.contentSize.height <= myScrollView.frame.size.height {//不够一屏
                
                guard self.myScrollView.contentOffset.y >= -self.myScrollView.contentInset.top else {
                    
                    refreshState = .stopped
                    return
                }
                refreshState = .animatingBounce
            }else {//超出一屏
                
                guard myScrollView.contentOffset.y >= myScrollView.contentSize.height - myScrollView.frame.size.height + myScrollView.contentInset.bottom else {
                    
                    refreshState = .stopped
                    return
                }
                refreshState = .animatingBounce
            }
            
        } else if refreshState.isAnyOf([.dragging, .stopped]) {
            
            //            let pullProgress: CGFloat = offsetY / MinOffsetToPull
            //            print("progress:",pullProgress)
        }
    }
    
}

extension UIGestureRecognizer.State {
    
    func isAnyOf(_ values: [UIGestureRecognizer.State]) -> Bool {
        return values.contains(where: { $0 == self })
    }
}
