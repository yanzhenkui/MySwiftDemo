//
//  ZKHomeViewController.swift
//  PhotoBrowser
//
//  Created by 闫振奎 on 15/3/15.
//  Copyright © 2015年 only. All rights reserved.
//

import UIKit


class ZKHomeViewController: UICollectionViewController {
    // MARK:- 定义模型数组属性:定义的同时初始化创建它,并懒加载
    lazy var shops : [ZKShop] = [ZKShop]()
    lazy var photoBrowserAnimator : ZKPhotoBrowserAnimator = ZKPhotoBrowserAnimator()
    
    // MARK:- 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData(0)
        
    }
}


// MARK:- 网络请求的方法
extension ZKHomeViewController {
    func loadData(offset : Int) {
        // 发送网络请求
        ZKNetworkTools.shareIntance.loadHomeData(offset) { (resultArray, error) -> () in
            // 1.校验错误
            if error != nil {
                return
            }
            
            // 2.取出可选类型中的数据
            guard let resultArray = resultArray else {
                return
            }
            
            // 3.将数据中的字典转成模型对象
            for dict in resultArray {
                let shop = ZKShop(dict: dict)
                self.shops.append(shop)
            }
            
            // 4.刷新数据
            self.collectionView?.reloadData()
        }
    }
}


// MARK:- collectionView的数据源方法
extension ZKHomeViewController {
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shops.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 1.由缓存池中获取
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeCell", forIndexPath: indexPath) as! ZKHomeViewCell
        
        // 2.如果缓存池中没有,根据标示符到stroyboard中注册
        
        // 3.设置数据
        cell.shop = shops[indexPath.row]
        
        // 4.下拉加载更多
        if indexPath.row == shops.count - 1 {
            loadData(shops.count)
        }
        
        return cell
    }
    
    // 代理方法
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 1.创建图片浏览控制器
        let photoBrowser = ZKPhotoBrowserViewController()
        
        // 2.设置控制器相关属性
        photoBrowser.shops = shops
        photoBrowser.indexPath = indexPath
        photoBrowserAnimator.indexPath = indexPath
        photoBrowserAnimator.presentedDelegate = self
        photoBrowserAnimator.dismissDelegate = photoBrowser
        
        // 2.1设置model控制器photoBrowser弹出的转场动画
        photoBrowser.modalPresentationStyle = .Custom
        photoBrowser.transitioningDelegate = photoBrowserAnimator

        // 3.弹出控制器
        presentViewController(photoBrowser, animated: true, completion: nil)
        
    }

}

// MARK:- 实现presentedDelegate的代理方法
extension ZKHomeViewController : PresentedProtocol {
    func getImageView(indexPath: NSIndexPath) -> UIImageView {
        // 1.创建UIImageView对象
        let imageView = UIImageView()
        
        // 2.设置图片
        let cell = collectionView?.cellForItemAtIndexPath(indexPath) as! ZKHomeViewCell
        imageView.image = cell.shopImageView.image
        
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
    
    func getStartRect(indexPath: NSIndexPath) -> CGRect {
        
        guard let cell = collectionView?.cellForItemAtIndexPath(indexPath) as? ZKHomeViewCell else {
            return CGRectZero
        }
        
        // 2.将cell的frame转换成所有屏幕的frame
        let startRect = collectionView!.convertRect(cell.frame, toCoordinateSpace: UIApplication.sharedApplication().keyWindow!)
        
        return startRect
    }
    
    func getEndRect(indexPath: NSIndexPath) -> CGRect {
        // 1.获取当前正在显示的cell
        let cell = collectionView?.cellForItemAtIndexPath(indexPath) as! ZKHomeViewCell
        
        // 2.获取image对象
        let image = cell.shopImageView.image
        
        return calculateImageViewFrame(image!)
    }
}

