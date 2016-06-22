//
//  ZKHomeCollectionViewLayout.swift
//  PhotoBrowser
//
//  Created by 闫振奎 on 15/3/15.
//  Copyright © 2015年 only. All rights reserved.
//

import UIKit

class ZKHomeCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        
        // 1.计算一些常量变量
        let margin : CGFloat = 10.0
        let cols : CGFloat = 3
        let cellWH : CGFloat = (UIScreen.mainScreen().bounds.width - (cols + 1) * margin) / cols
        
        // 2.设置布局
        itemSize = CGSize(width: cellWH, height: cellWH)
        minimumInteritemSpacing = margin
        minimumLineSpacing = margin
        
        // 3.设置collectionView的内边距
        collectionView?.contentInset = UIEdgeInsets(top: margin + 64, left: margin, bottom: margin, right: margin)
        
    }
}
