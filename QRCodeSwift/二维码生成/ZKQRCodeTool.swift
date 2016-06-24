//
//  XMGQRCodeTool.swift
//  二维码生成
//
//  Created by 闫振奎 on 16/3/3.
//  Copyright © 2016年 only. All rights reserved.
//

import UIKit

class ZKQRCodeTool: NSObject {
    
    
    
    class func createQRCodeImage(str: String,size: CGFloat, iconImage: UIImage?) -> UIImage {
        
        // 1. 创建一个生成二维码的滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        // 1.1 恢复滤镜默认设置
        filter?.setDefaults()
        
        // 2. 设置滤镜的输入数据
        let data = str.dataUsingEncoding(NSUTF8StringEncoding)
        filter?.setValue(data, forKey: "inputMessage")
        
        // 3. 从滤镜中获取图片
        let image = filter?.outputImage
        let imageUI = createBigImage(image!, size: size)
        
        
        if iconImage == nil
        {
            return imageUI
        }else
        {
            return createImage(imageUI, iconImage: iconImage)!
        }
        
        
    }
    
    
    private class func createImage(bgImage: UIImage?, iconImage: UIImage?) -> UIImage?
    {
    
        if bgImage == nil || iconImage == nil
        {
            return nil
        }
        // 1.开启图片上下文
        UIGraphicsBeginImageContext(bgImage!.size)
        // 2.绘制背景
        bgImage!.drawInRect(CGRect(origin: CGPointZero, size: bgImage!.size))
        // 3.绘制图标
        let w:CGFloat = 50
        let h = w
        let x = (bgImage!.size.width - w) * 0.5
        let y = (bgImage!.size.height - h) * 0.5
        iconImage!.drawInRect(CGRect(x: x, y: y, width: w, height: h))
        // 4.取出图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 5.关闭上下文
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    /**
     根据CIImage生成指定大小的高清UIImage
     :param: image 指定CIImage
     :param: size    指定大小
     :returns: 生成好的图片
     */
    private class func createBigImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = CGRectIntegral(image.extent)
        let scale: CGFloat = min(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent))
        
        // 1.创建bitmap;
        let width = CGRectGetWidth(extent) * scale
        let height = CGRectGetHeight(extent) * scale
        let cs: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
        let bitmapRef = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, cs, 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImageRef = context.createCGImage(image, fromRect: extent)
        
        CGContextSetInterpolationQuality(bitmapRef,  CGInterpolationQuality.None)
        CGContextScaleCTM(bitmapRef, scale, scale);
        CGContextDrawImage(bitmapRef, extent, bitmapImage);
        
        // 2.保存bitmap到图片
        let scaledImage: CGImageRef = CGBitmapContextCreateImage(bitmapRef)!
        
        return UIImage(CGImage: scaledImage)
    }
    
    
}
