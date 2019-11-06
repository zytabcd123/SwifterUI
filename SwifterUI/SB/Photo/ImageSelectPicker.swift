//
//  ImageSelectPicker.swift
//  secret
//
//  Created by mc on 2017/9/12.
//  Copyright © 2017年 mc. All rights reserved.
//

import Photos
import RxSwift
import RxCocoa

fileprivate func getAlbums() -> [ImageSelectPicker.Section] {
    
    let s = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
    let c = s.objects(at: IndexSet(integersIn: 0..<s.count))
    
    let s1 = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
    let c1 = s1.objects(at: IndexSet(integersIn: 0..<s1.count))
    
    let abs = c.map({ ImageSelectPicker.Section($0, $0.asset)}) + c1.map({ ImageSelectPicker.Section($0, $0.asset)})
    return abs.filter({$0.asset.count > 0})
}

open class ImageSelectPicker: BaseViewController, IsInImageStoryboard {
    
    var didSelectedBlock: ((_ photos: [PHAsset]) -> ())?
    typealias Section = (collection: PHAssetCollection, asset: PHFetchResult<PHAsset> )

    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    

    lazy var albums: [Section] = {
        return getAlbums()
    }()
    var index = 0
    var photos: PHFetchResult<PHAsset> {
        return albums.item(at: index)?.asset ?? PHFetchResult<PHAsset>()
    }
    var selecteds = [PHAsset]()
    var limit = 9
    var disBag = DisposeBag()

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        updateItemSize()
        if !app.isPhotoLibraryDenied {
            
            showAlert("访问相册权限被拒绝，请点击设置按钮打开相册权限", actions: ["取消","设置"]) { (idx) in
                if idx == 1 {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                }
            }
            return
        }else if photos.count <= 0 {
            
            PHPhotoLibrary.requestAuthorization({ [weak self] (st) in
                if st == .denied {
                    DispatchQueue.main.async {
                        self?.showAlert( "访问相册权限被拒绝，请点击设置按钮打开相册权限", actions: ["取消","设置"]) { (idx) in
                            if idx == 1 {
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                            }
                        }
                    }
                }else {
                    self?.albums = getAlbums()
                    DispatchQueue.main.async {
                        self?.myCollectionView.reloadData()
                    }
                }
            })
        }
        titleLabel.text = albums.first?.collection.localizedTitle
    }
    
    
    @IBAction func didEnterAction() {
        
        PHCachingImageManager().startCachingImages(for: selecteds, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: nil)
        didSelectedBlock?(selecteds)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didShowAction(bt: UIButton) {
    
        bt.isSelected = true
        let vc = AlbumSelectPicker.fromStoryboard()
        self.present(vc, animated: true, completion: nil)
        vc.albums = albums
        vc.didSelectedBlock = { [unowned self](idx, s) in
            
            self.index = idx
            self.myCollectionView.reloadData()
            self.myCollectionView.scrollsTo(.top)
            self.titleLabel.text = s
        }
        vc.didCancelBlock = {
            bt.isSelected = false
        }
    }
    
    private func updateItemSize() {
        
        let viewWidth = view.bounds.size.width
        
        let desiredItemWidth: CGFloat = 100
        let columns: CGFloat = max(floor(viewWidth / desiredItemWidth), 4)
        let padding: CGFloat = 1
        let itemWidth = floor((viewWidth - (columns - 1) * padding) / columns)
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        if let layout = myCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = itemSize
            layout.minimumInteritemSpacing = padding
            layout.minimumLineSpacing = padding
        }
    }
}



extension ImageSelectPicker: UICollectionViewDelegate, UICollectionViewDataSource, CanGetImage {
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count + 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            
            let cell = ImageSelectCell.dequeue(from: collectionView, forIndexPath: indexPath)
//            cell.photoView.image = #imageLiteral(resourceName: "camera")
            cell.photoView.contentMode = .center
            cell.selectedBt.isHidden = true
            return cell
        }
        let p = photos.object(at: indexPath.item - 1)
        
        let cell = ImageSelectCell.dequeue(from: collectionView, forIndexPath: indexPath)
        cell.photoView.setAssetImage(ass: p, size: CGSize(width: 320, height: 320))
        cell.photoView.contentMode = .scaleAspectFill
        cell.selectedBt.isHidden = false
        cell.selectedBt.isSelected = selecteds.contains(p)
        cell.selectedBt.rx.tap
            .subscribe(onNext: { [weak self] in
                
                self?.selectedItem(indexPath: indexPath)
            })
            .disposed(by: cell.reuseDisposeBag)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0 {
            
            getImage(sourceType: .camera)
                .subscribe(onNext: { (image) in
                    guard let img = image else {return}
                    save(image: img, block: { [weak self](asset) in
                        guard let s = asset else {return}
                        self?.selecteds.append(s)
                        self?.didEnterAction()
                    })
                })
                .disposed(by: disBag)
        }else {
            let assets = photos.objects(at: IndexSet(integersIn: 0..<photos.count))
            let window = UIApplication.shared.keyWindow
            let s = assets.enumerated().map({ (idx, m) -> LookImageModel in
                
                let cell = collectionView.cellForItem(at: IndexPath(item: idx + 1, section: indexPath.section)) as? ImageSelectCell
                let rect1 = cell?.convert(cell?.frame ?? .zero, from: collectionView)
                let rect2 = cell?.convert(rect1 ?? .zero, to: window) ?? .zero
                
                return LookImageModel(asset: m, image: cell?.photoView.image, frame: rect2)
            })
            
            lookImages(images: s, currentIndex: indexPath.item - 1)
        }
    }
    
    fileprivate func selectedItem(indexPath: IndexPath) {
        
        let p = photos.object(at: indexPath.item - 1)
        if let idx = selecteds.firstIndex(of: p) {
            selecteds.remove(at: idx)
        }else {
            if selecteds.count < limit {
                selecteds.append(p)
            }else {
                HUD.showInKeyWindow(.text, title: "You can choose at most \(limit) pictures", delayHide: 2)
            }
        }
        myCollectionView.reloadItems(at: [indexPath])
    }
}

extension Array {
    
    fileprivate func item(at index: Index) -> Element? {
        guard startIndex..<endIndex ~= index else { return nil }
        return self[index]
    }
}


