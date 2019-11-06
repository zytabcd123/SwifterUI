//
//  CanGetImage.swift
//  theatre
//
//  Created by luojie on 16/11/8.
//  Copyright © 2016年 @天意. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Photos

public protocol CanGetImage {}
extension CanGetImage where Self: UIViewController {
    
    public func getImage(sourceType: UIImagePickerController.SourceType, allowsEditing: Bool = true) -> Observable<UIImage?> {
        
        let vc = UIImagePickerController()
        vc.sourceType = sourceType
        vc.allowsEditing = allowsEditing
        let imgStr = allowsEditing ? convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage) : convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)

        Queue.main.execute { self.present(vc, animated: true, completion: nil) }

        let didCancel = vc.rx.didCancel.flatMapLatest { Observable<UIImage?>.empty() }
        let didFinish = vc.rx.didFinishPickingMediaWithInfo.map { $0[imgStr] as? UIImage }

        return Observable.of(didCancel, didFinish)
                         .merge()
    }
    
    public func getVideo(sourceType: UIImagePickerController.SourceType) -> Observable<URL?> {
        let vc = UIImagePickerController()
        vc.sourceType = sourceType
        vc.mediaTypes = ["public.movie"]
        vc.videoMaximumDuration = 20
        
        Queue.main.execute { self.present(vc, animated: true, completion: nil) }
        
        let didCancel = vc.rx.didCancel.flatMapLatest { Observable<URL?>.empty() }
        let mediaURL = convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaURL)
        let didFinish = vc.rx.didFinishPickingMediaWithInfo.map { $0[mediaURL] as? URL }
        
        return Observable.of(didCancel, didFinish)
            .merge()
        
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
