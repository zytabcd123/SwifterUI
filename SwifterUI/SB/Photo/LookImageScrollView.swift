//
//  LookImageScrollView.swift
//  secret
//
//  Created by mc on 2017/8/2.
//  Copyright © 2017年 mc. All rights reserved.
//

import UIKit

class LookImageScrollView: UICollectionViewCell, UIScrollViewDelegate {
    

    var didSingleTapBlock: (() -> ())?
    var didSaveImageBlock: ((UIImage) -> ())?
    lazy var imageView = UIImageView()
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.addSubview(imageView)
            imageView.center = scrollView.center
            Queue.main.execute {
                let single = UITapGestureRecognizer(target: self, action: #selector(LookImageScrollView.singleTapAction(_:)))
                self.scrollView.addGestureRecognizer(single)
                let double = UITapGestureRecognizer(target: self, action: #selector(LookImageScrollView.autoResize(_:)))
                double.numberOfTapsRequired = 2
                self.scrollView.addGestureRecognizer(double)
                single.require(toFail: double)
                
                let long = UILongPressGestureRecognizer(target: self, action: #selector(LookImageScrollView.longPressAction(_:)))
                self.scrollView.addGestureRecognizer(long)
            }
        }
    }
    
    var model: LookImageModel? = nil {
        didSet {
            
            spinner.startAnimating()
            model?.request(block: { [weak self](image) in
                
                self?.image = image
                self?.spinner.stopAnimating()
            })
        }
    }


    @IBAction func autoResize(_ sender: UITapGestureRecognizer) {
        if scrollView.zoomScale != scrollView.minimumZoomScale {
            return UIView.animate(withDuration: 0.3, animations: { self.scrollView.zoomScale = self.scrollView.minimumZoomScale })
        }
        
        let pointInView = sender.location(in: imageView)
        var newZoomScale = scrollView.zoomScale * 2
        
        newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
        
        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRect(x: x, y: y, width: w, height: h);
        scrollView.zoom(to: rectToZoomTo, animated: true)
    }
    
    @objc func longPressAction(_ sender: UITapGestureRecognizer) {

        guard sender.state == .ended,
              let img = self.image else {return}
        didSaveImageBlock?(img)
    }

    @IBAction func singleTapAction(_ sender: UITapGestureRecognizer) {
        
        didSingleTapBlock?()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollView.centerContentView()
    }

    fileprivate var image: UIImage? {
        get { return imageView.image }
        set {

            imageView.backgroundColor = .clear
            imageView.contentMode = .scaleToFill
        
            imageView.image = newValue
            imageView.frame = imageFrame(size: newValue?.size ?? .zero)
            scrollView.contentSize = imageView.frame.size
        }
    }
}

extension UIScrollView {
    
    fileprivate func centerContentView() {
        
        guard let contentView = subviews.first else { return }
        let boundsSize = bounds.size
        var contentsFrame = contentView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        contentView.frame = contentsFrame
    }
}

func imageFrame(size: CGSize) -> CGRect {
    if size.width > UIScreen.w {
        let height = UIScreen.w * (size.height / size.width)
        if height <= UIScreen.h {
            
            return CGRect(x: 0, y: UIScreen.h/2 - height/2, width: UIScreen.w, height: height)
        }else {
            
            return CGRect(x: 0, y: 0, width: UIScreen.w, height: height)
        }
    }else {
        let w = size.width / 2
        let h = size.height / 2
        return CGRect(x: UIScreen.w/2 - w/2, y: UIScreen.h/2 - h/2, width: w, height: h)
    }
}

