//
//  ImageSelector.swift
//  secret
//
//  Created by mc on 2017/7/28.
//  Copyright © 2017年 mc. All rights reserved.
//

import Foundation
import Photos
import RxSwift
import RxCocoa

let allPhotos: PHFetchResult<PHAsset> = {
    let op = PHFetchOptions()
    op.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    return PHAsset.fetchAssets(with: .image, options: op)
}()

fileprivate let fastOptions: PHImageRequestOptions = {
    let op = PHImageRequestOptions()
    op.resizeMode = .fast
    op.deliveryMode = .fastFormat
    op.isSynchronous = true
    return op
}()

fileprivate let exactOptions: PHImageRequestOptions = {
    let op = PHImageRequestOptions()
    op.resizeMode = .exact
    op.deliveryMode = .highQualityFormat
    op.isSynchronous = true
    return op
}()


extension UIImageView {
    public func setAssetImage(ass: PHAsset?, size: CGSize, placeholder: UIImage? = nil) {
        
        image = placeholder
        guard let asset = ass else {return}
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .default, options: fastOptions) { [weak self](img,  _) in

            self?.image = img
        }
    }
}

extension PHAsset {
    
    public func image(block: @escaping (UIImage?) -> ()) {
        
        print("原始分辨率:",self.pixelWidth, self.pixelHeight,"压缩分辨率", self.scaleSize)
        PHImageManager.default().requestImage(for: self, targetSize: scaleSize, contentMode: .default, options: exactOptions) { (img, _) in
            block(img)
        }
    }
    
    public func image(compressionQuality: CGFloat) -> Observable<Data?> {
        return Observable.create { observer in
            
            self.image(block: { (img) in
                
                guard let i = img else {
                    observer.onNext(nil)
                    observer.onCompleted()
                    return
                }
                let d = i.jpegData(compressionQuality: compressionQuality)
                print("压缩70%质量", ByteCountFormatter.string(fromByteCount: Int64(d?.count ?? 0), countStyle: .memory))
                observer.onNext(d)
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    public var scaleSize: CGSize {

        guard !isLong else {return CGSize(width: pixelWidth, height: pixelHeight)}
        let scale = 1024.0 / CGFloat(max(pixelHeight, pixelWidth))
        return min(1024, pixelWidth, pixelHeight) >= 1024
            ? CGSize(width: CGFloat(pixelWidth) * scale, height: CGFloat(pixelHeight) * scale)
            : CGSize(width: pixelWidth, height: pixelHeight)
    }
    
    /// 长图
    public var isLong: Bool {
        print((max(pixelWidth, pixelHeight) / min(pixelWidth, pixelHeight)))
        return (max(pixelWidth, pixelHeight) / min(pixelWidth, pixelHeight)) >= 3
    }
}

extension PHAssetCollection {
    
    var asset: PHFetchResult<PHAsset> {
        let op = PHFetchOptions()
        op.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return PHAsset.fetchAssets(in: self, options: op)
    }
}

class AlbumTableCell: UITableViewCell {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoView.image = nil
    }
}

class ImageSelectCell: UICollectionViewCell {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var selectedBt: UIButton!
    override func prepareForReuse() {
        super.prepareForReuse()
        photoView.image = nil
    }
}
