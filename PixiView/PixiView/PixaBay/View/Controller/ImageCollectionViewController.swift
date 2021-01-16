//
//  ImageCollectionViewController.swift
//  PixiView
//
//  Created by tcs on 16/01/21.
//

import UIKit

class ImageCollectionViewController: UICollectionViewController {
    
    var index: IndexPath?
    var photoArray: [UIImage]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PixiView"
        self.navigationItem.backButtonTitle = ""
        setUpCollectionView()
    }
    
    func setUpCollectionView() {
        self.collectionView.register(UINib(nibName: "BigImageCell", bundle: nil), forCellWithReuseIdentifier: "BigImageCell")
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        calculateCollectionCellHeight()
    }
    
    func calculateCollectionCellHeight() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        collectionView.collectionViewLayout = layout
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photoArray?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BigImageCell", for: indexPath) as? BigImageCell
        //cell?.setCellData(index: indexPath.row, photoArray: photoArray)
        cell?.showImage(image: photoArray?[index?.row ?? 0] ?? UIImage())
        //collectionView.scrollToItem(at: index ?? IndexPath(), at: .centeredHorizontally, animated: false)
        return cell ?? UICollectionViewCell()
    }
}

extension ImageCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
