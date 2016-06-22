//
//  ZKHomeViewCell.swift
//  PhotoBrowser
//
//  Created by 闫振奎 on 15/3/15.
//  Copyright © 2015年 only. All rights reserved.
//

import UIKit
import SDWebImage

class ZKHomeViewCell: UICollectionViewCell {
    @IBOutlet weak var shopImageView: UIImageView!
    var shop : ZKShop? {
        didSet {
            // 1.校验模型是否有值
            guard let shop = shop else {
                return
            }
            
            // 2.取出图片的URLString
            guard let url = NSURL(string: shop.q_pic_url) else {
                return
            }
            
            // 3.设置图片
            let placeHolderImage = UIImage(named: "empty_picture")
            
            shopImageView .sd_setImageWithURL(url, placeholderImage: placeHolderImage)
        }
    }
}
