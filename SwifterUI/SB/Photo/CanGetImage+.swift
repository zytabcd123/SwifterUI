//
//  CanGetImage+.swift
//  apc
//
//  Created by uke on 2019/3/21.
//  Copyright © 2019 @天意. All rights reserved.
//

import Foundation
import Photos
import RxSwift

public protocol IsInImageStoryboard: IsInStoryboard {}
extension IsInImageStoryboard {
    public static var storyboardName: String { return "Image" }
}

extension CanGetImage where Self: UIViewController {
    
    public func showSelectedImage(limit: Int = 9, selecteds: [PHAsset] = [PHAsset]()) -> Observable<([PHAsset])> {
        return Observable.create { observer in
            
            let vc = ImageSelectPicker.fromStoryboard()
            self.present(vc, animated: true, completion: nil)
            vc.selecteds = selecteds
            vc.limit = limit
            vc.didSelectedBlock = { (ps) in
                observer.onNext((ps))
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    public func lookImages(images: [LookImageModel], currentIndex: Int = 0, type: LookImageViewType = .non, delete: ((Int) -> ())? = nil) {
        
        self.view.endEditing(true)
        let vc = LookImageViewController.fromStoryboard()
        vc.showAnimation(images: images, currentIndex: currentIndex)
        vc.type = type
        vc.didDeleteBlock = delete
        present(vc, animated: true, completion: nil)
    }
}
