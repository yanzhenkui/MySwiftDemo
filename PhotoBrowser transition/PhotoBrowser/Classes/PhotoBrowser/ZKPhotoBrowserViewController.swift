//
//  ZKPhotoBrowserViewController.swift
//  PhotoBrowser
//
//  Created by 闫振奎 on 15/3/15.
//  Copyright © 2015年 only. All rights reserved.
//

import UIKit

// MARK:- 点击进入图片浏览器控制器时,要将模型和下标都传递进来
class ZKPhotoBrowserViewController: UIViewController {
    // MARK:- 定义的属性
    var indexPath : NSIndexPath?
    var shops : [ZKShop]?
    let photoCellID : String = "photoCellID"
    
    // MARK:- 懒加载的属性
    lazy var closeBtn : UIButton = UIButton()
    lazy var saveBtn : UIButton = UIButton()
    lazy var collectionView : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: ZKPhotoBrowserLayout())
    
    // MARK:- 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 0.设置图片间距(注意:必须要先修改view的frame,再设置view子控件,UI界面)
        view.frame.size.width += 15
        
        // 1.设置UI界面
        setUpUI()
        
        // 2.滚动到对应的位置
        collectionView.scrollToItemAtIndexPath(indexPath!, atScrollPosition: .Left, animated: true)
        

    }
}


extension ZKPhotoBrowserViewController {
    func setUpUI() {
        // 1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        // 2.设置子控件位置
        collectionView.frame = view.bounds
        let margin : CGFloat = 20
        let btnW : CGFloat = 90
        let btnH : CGFloat = 32
        let closeBtnY : CGFloat = UIScreen.mainScreen().bounds.height - margin - btnH
        let saveBtnX : CGFloat = UIScreen.mainScreen().bounds.width - btnW - margin
        
        closeBtn.frame = CGRect(x: margin, y: closeBtnY, width: btnW, height: btnH)
        saveBtn.frame = CGRect(x: saveBtnX, y: closeBtnY, width: btnW, height: btnH)
        
        
        // 3.设置相关属性
        prepareBtn(closeBtn, title: "关 闭", action: "closeBtnClick")
        prepareBtn(saveBtn, title: "保 存", action: "saveBtnClick")
        prepareCollectionView()
        
    }
    
    func prepareBtn(btn : UIButton , title : String , action : String) {
        btn.backgroundColor = UIColor.darkGrayColor()
        btn.setTitle(title, forState: .Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        btn.addTarget(self, action: Selector(action), forControlEvents: .TouchUpInside)
    }
    
    func prepareCollectionView() {
        // 设置数据源
        collectionView.dataSource = self
        collectionView.delegate = self 
        
        // 注册Cell
        collectionView.registerClass(ZKPhotoBrowserCell.self, forCellWithReuseIdentifier: photoCellID)
    }
   
}


// MARK:- 监听事件
extension ZKPhotoBrowserViewController {
    @objc private func closeBtnClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func saveBtnClick() {
        // 1.取出正在显示的图片
        let cell = collectionView.visibleCells().first as! ZKPhotoBrowserCell
        guard let image = cell.photoImageView.image else {
            return
        }
        
        // 2.保存图片
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        closeBtnClick()
    }
}


// MARK:- collection数据源和代理方法
extension ZKPhotoBrowserViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // ?? : 处理可选链,如果可选链中有一个可选类型没有值,那么直接使用 ?? 后面的值
        return self.shops?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 1.创建Cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoCellID, forIndexPath: indexPath) as! ZKPhotoBrowserCell
        
        // 2.设置Cell的内容
        cell.shop = shops![indexPath.row]

        return cell
    }
    
    // 点击当前collectionView的Cell时,退出当前Model控制器
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        closeBtnClick()
    }
    
}


// MARK:- 实现dismissProtocol的代理方法
extension ZKPhotoBrowserViewController : DismissProtocol {
    func getImageView() -> UIImageView {
        // 1.创建UIImageView
        let imageView = UIImageView()
        
        // 2.设置imageView的image
        let cell = collectionView.visibleCells().first as! ZKPhotoBrowserCell
        imageView.image = cell.photoImageView.image
        
        // 3.设置imageView的frame
        imageView.frame = cell.photoImageView.frame
        
        // 4.设置imageView的属性
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
    
    func getIndexPath() -> NSIndexPath {
        let cell = collectionView.visibleCells().first as! ZKPhotoBrowserCell
        
        return collectionView.indexPathForCell(cell)!
    }
}
