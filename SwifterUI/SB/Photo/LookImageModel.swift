//
//  LookImageModel.swift
//  secret
//
//  Created by mc on 2017/8/2.
//  Copyright © 2017年 mc. All rights reserved.
//

import Foundation
import Photos
import SDWebImage

public enum LookImageViewType {
    case non, canDelete
}

public class LookImageModel: NSObject {
    
    public var url: URL?
    public var asset: PHAsset?
    public var animatImage: UIImage?
    public var frame = CGRect.zero
   
    
    public init(url: URL?, image: UIImage?, frame: CGRect) {
        self.url = url
        self.animatImage = image
        self.frame = frame
    }
    
    public init(asset: PHAsset?, image: UIImage?, frame: CGRect) {
        self.asset = asset
        self.animatImage = image
        self.frame = frame
    }
}

extension LookImageModel {

    public func request(block: @escaping (_ image: UIImage?) -> () ) {
        
        switch (url, asset) {
        case let (url?, _):
            
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil, completed: { (img, _, _, _, _, _) in
                block(img)
            })
        case let (_, asset?):
            
            let op = PHImageRequestOptions()
            op.resizeMode = .exact
            op.deliveryMode = .highQualityFormat
            PHCachingImageManager.default().requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: op, resultHandler: { (img, dic) in
                block(img)
            })
        default:
            block(nil)
        }
    }
}

extension LookImageModel {
    
    public var valid: Bool {
        switch (url, asset) {
        case (_?, _): return true
        case (_, _?): return true
        default: return false
        }
    }
}
