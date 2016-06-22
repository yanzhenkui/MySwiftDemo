//
//  AppDelegate.swift
//  PhotoBrowser
//
//  Created by 闫振奎 on 15/3/15.
//  Copyright © 2015年 only. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

}



// 根据一个图片计算放大之后的frame
func calculateImageViewFrame(image : UIImage) -> CGRect {
    let imageViewW = UIScreen.mainScreen().bounds.width
    let imageViewH = imageViewW / image.size.width * image.size.height
    let imageViewX : CGFloat = 0
    let imageViewY : CGFloat = (UIScreen.mainScreen().bounds.height - imageViewH) * 0.5
    
    return CGRect(x: imageViewX, y: imageViewY, width: imageViewW, height: imageViewH)
}

