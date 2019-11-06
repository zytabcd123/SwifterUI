//
//  LookImageViewController.swift
//  secret
//
//  Created by mc on 2017/8/2.
//  Copyright © 2017年 mc. All rights reserved.
//

import UIKit
import Photos


open class LookImageViewController: UIViewController, IsInImageStoryboard {

    
    public var didDeleteBlock: ((Int) -> ())?
    
    fileprivate var appearTransition: Transition?
    fileprivate var disappearTransition: Transition?
    @IBOutlet fileprivate weak var myCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var numLabel: UILabel?
    @IBOutlet fileprivate weak var deleteBt: UIButton?

    fileprivate var isFirstLoading = true
    var type = LookImageViewType.non
    public var models = [LookImageModel]()
    public var currentIndex = 0 {
        didSet {
            
            self.updateNumTitle()
        }
    }
    
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        disappearTransition = nil
        print("viewDidDisappear.deinit")
    }
    
    deinit {
        transitioningDelegate = nil
        appearTransition = nil
        print("LookImageViewController.deinit")
    }


    open override func viewDidLayoutSubviews() {
        if isFirstLoading && models.count > 1 {
            myCollectionView.selectItem(at: IndexPath(item: currentIndex, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            isFirstLoading = false
        }
    }
    
    open func showAnimation(images: [LookImageModel], currentIndex: Int = 0) {
        self.models = images
        self.currentIndex = currentIndex
        
        let m = images[currentIndex]
        let f = getCurrentImageView()?.frame ?? imageFrame(size: m.animatImage?.size ?? UIScreen.size)
        appearTransition = nil
        appearTransition = Transition(m.animatImage, beforeImgFrame: m.frame, afterImgFrame: f)
        self.transitioningDelegate = appearTransition
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        self.updateNumTitle()
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        switch type {
        case .non:
            deleteBt?.removeFromSuperview()
        case .canDelete:
            break
        }
    }
    
    func updateNumTitle() {
        
        if models.count >= 2 {
            self.numLabel?.text = "\(currentIndex + 1)/\(models.count)"
        }else {
            self.numLabel?.text = nil
        }
    }
    
    @IBAction func deleteBtAction() {
        
        didDeleteBlock?(currentIndex)
        dismiss(animated: true, completion: nil)
    }
    
    // 慢移手势
    @IBAction func pan(_ pan: UIPanGestureRecognizer) {
        
        guard let currentImageView = getCurrentImageView(),
                  currentImageView.image != nil,
              let scrollView = currentImageView.superview as? UIScrollView
//                  scrollView.zoomScale != 1
        else {return}

        scrollView.delegate = nil
        
        let translation = pan.translation(in:  pan.view)
        var scale = 1 - translation.y / UIScreen.h
        scale = scale > 1 ? 1:scale
        scale = scale < 0 ? 0:scale
        switch pan.state {
        case .began:
            
            disappearTransition = nil
            disappearTransition = Transition()
            disappearTransition?.gestureRecognizer = pan
            self.transitioningDelegate = disappearTransition
            dismiss(animated: true, completion: nil)
            break
        case .changed:
            
            self.numLabel?.isHidden = true
            self.deleteBt?.isHidden = true
            currentImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            currentImageView.center = CGPoint(x: UIScreen.w/2 + translation.x * scale, y: UIScreen.h/2 + translation.y * scale)
        case .failed,.cancelled,.ended:
            
            if translation.y <= 100 {
                UIView.animate(withDuration: 0.2, animations: {
                    
                    currentImageView.center = CGPoint(x: UIScreen.w / 2, y: UIScreen.h / 2)
                    currentImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: { (finished: Bool) in
                    
                    currentImageView.transform = CGAffineTransform.identity
                    
                })
                
                let cell = myCollectionView.cellForItem(at: IndexPath(row: currentIndex, section: 0))
                scrollView.delegate = cell as! UIScrollViewDelegate?
                self.numLabel?.isHidden = false
                self.deleteBt?.isHidden = false
            }else {
                
                currentImageView.isHidden = true
                disappearTransition?.currentImage = models[currentIndex].animatImage
                disappearTransition?.currentImageViewFrame = currentImageView.frame
                disappearTransition?.beforeImageViewFrame =  models[currentIndex].frame
            }
        case .possible:
            break
        @unknown default:
            break
        }
    }
    
    fileprivate func getCurrentImageView() -> UIImageView? {
        if myCollectionView == nil {return nil}
        let cell = myCollectionView.cellForItem(at: IndexPath(row: currentIndex, section: 0)) as? LookImageScrollView
        return cell?.imageView
    }
}

extension LookImageViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        return CGSize(width: UIScreen.w, height: UIScreen.h)
    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return models.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let m = models[indexPath.item]
        let cell = LookImageScrollView.dequeue(from: collectionView, forIndexPath: indexPath)
        cell.model = m
        cell.didSingleTapBlock = { [unowned self] in
            
            self.showAnimation(images: self.models, currentIndex: self.currentIndex)
            self.dismiss(animated: true, completion: nil)
        }
        cell.didSaveImageBlock = { [unowned self]img in
            
            self.showActionSheet(nil, msg: nil, actions: ["Save Photo"], didSelectBlock: { (idx) in
                if idx == 0 {

                    save(image: img, block: { (asset) in
                        if asset != nil {
                            HUD.showInKeyWindow(.text, title: "Save success", delayHide: 2)
                        }else {
                            HUD.showInKeyWindow(.text, title: "Save falied", delayHide: 2)
                        }
                    })
                }
            })
        }
        return cell
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       
        currentIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    }
}
