//
//  ZKPhotoBrowserCell.swift
//  PhotoBrowser
//
//  Created by 闫振奎 on 15/3/15.
//  Copyright © 2015年 only. All rights reserved.
//

import UIKit
import SDWebImage

class ZKPhotoBrowserCell: UICollectionViewCell {
    // MARK:- 定义属性
    var shop : ZKShop? {
        didSet {
            // 1.nil值校验
            guard let shop = shop else {
                return
            }
            
            // 2.取出image对象
            var image = SDWebImageManager.sharedManager().imageCache.imageFromMemoryCacheForKey(shop.q_pic_url)
            
            if image == nil {
                image = UIImage(named: "empty_picture")
            }
            
            // 3.根据图片计算UIImageView的frame
            photoImageView.frame = calculateImageViewFrame(image)
            
            // 4.设置imageView的图片
            guard let url = NSURL(string: shop.z_pic_url) else {
                photoImageView.image = image
                return
            }
            
            photoImageView.sd_setImageWithURL(url, placeholderImage: image) { (image, _, _, _) -> Void in
                self.photoImageView.frame = calculateImageViewFrame(image)
            }
            
        }
    }
    
    // MARK:- 懒加载属性
    lazy var photoImageView : UIImageView = UIImageView()

    
    // MARK:- 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(photoImageView)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.addSubview(photoImageView)
    }

}



// MARK:- 根据图片计算ImageView的frame
extension ZKPhotoBrowserCell {
     
}



