//
//  UIImage+.swift
//  apc
//
//  Created by ovfun on 2017/1/3.
//  Copyright © 2017年 @天意. All rights reserved.
//

import Foundation
import Photos

public func save(image: UIImage, block: ((PHAsset?) -> ())?) {
    var localId: String?
    PHPhotoLibrary.shared().performChanges({
        let result = PHAssetChangeRequest.creationRequestForAsset(from: image)
        let assetPlaceholder = result.placeholderForCreatedAsset
        //保存标志符
        localId = assetPlaceholder?.localIdentifier
    }) { (isSuccess: Bool, error: Error?) in
        guard let id = localId else {
            Queue.main.execute {
                block?(nil)
            }
            return
        }
        if isSuccess {
            print("保存成功!")
            Queue.main.execute {
                block?(PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil).firstObject)
            }
            saveIntuCustom(assetId: id)
        } else {
            Queue.main.execute {
                block?(nil)
            }
            print("保存失败：", error?.localizedDescription ?? "没有错误信息")
        }
    }
}

fileprivate func saveIntuCustom(assetId: String) {
    guard let colle = customAlbum else {return}
    let asset = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
    
    do{
        try PHPhotoLibrary.shared().performChangesAndWait {
            let r = PHAssetCollectionChangeRequest(for: colle)
            r?.insertAssets(asset, at: IndexSet(integer: 0))
        }
    }catch {
        print("保存失败：", error.localizedDescription)
    }
}

fileprivate var customAlbum: PHAssetCollection? {
    
    let name = app.displayName!
    let s = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
    let cs = s.objects(at: IndexSet(integersIn: 0..<s.count))
    
    if let album = cs.filter({ $0.localizedTitle == name }).first {
        return album
    }
    
    var localId: String?
    try? PHPhotoLibrary.shared().performChangesAndWait {
        localId = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name).placeholderForCreatedAssetCollection.localIdentifier
    }
    guard let id = localId else {return nil}
    return PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [id], options: nil).firstObject
}

public extension UIImage {
    
    /// 使用颜色创建图片
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(cgImage: image.cgImage!)
    }
}

extension UIImage {
    
    /// 压缩图片质量 默认压缩率0.75
    public func compressed(quality: CGFloat = 0.75) -> UIImage? {
        guard let data = compressedData(quality: quality) else {
            return nil
        }
        return UIImage(data: data)
    }
    
    /// 压缩图片质量 默认压缩率0.75
    public func compressedData(quality: CGFloat = 0.5) -> Data? {
        return self.jpegData(compressionQuality: quality)
    }
    
    public func cropped(to rect: CGRect) -> UIImage {
        guard rect.size.height < self.size.height && rect.size.height < self.size.height else {
            return self
        }
        guard let cgImage: CGImage = self.cgImage?.cropping(to: rect) else {
            return self
        }
        return UIImage(cgImage: cgImage)
    }
    

    /// 等比例缩放
    ///
    /// - Parameter toHeight: 指定缩放高度
    /// - Returns: 缩放后图片
    public func scaled(toHeight: CGFloat) -> UIImage? {
        let scale = toHeight / self.size.height
        let newWidth = self.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: toHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 等比例缩放
    ///
    /// - Parameter toHeight: 指定缩放宽度
    /// - Returns: 缩放后图片
    public func scaled(toWidth: CGFloat) -> UIImage? {
        let scale = toWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: toWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    public func scaled(_ scale: CGFloat) -> UIImage? {
        let w = self.size.width * scale
        let h = self.size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: w, height: h), false, 0)
        self.draw(in: CGRect(x: 0, y: 0, width: w, height: h))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 填充背景色
    public func filled(withColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()
        guard let context = UIGraphicsGetCurrentContext() else {
            return self
        }
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        guard let mask = self.cgImage else {
            return self
        }
        context.clip(to: rect, mask: mask)
        context.fill(rect)
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return self
        }
        UIGraphicsEndImageContext()
        return newImage
    }
    
    public var square: UIImage? {
        
        let w = min(size.width, size.height)
        let f = (max(size.width, size.height) - w) / 2

        let x = (size.width > size.height) ? f : 0
        let y = (size.width > size.height) ? 0 : f
        return cropped(to: CGRect(x: x, y: y, width: w, height: w))
    }
    
}
