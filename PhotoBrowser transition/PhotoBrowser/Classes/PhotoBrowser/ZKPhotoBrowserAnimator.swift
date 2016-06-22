//
//  ZKPhotoBrowserAnimator.swift
//  PhotoBrowser
//
//  Created by 闫振奎 on 15/3/15.
//  Copyright © 2015年 only. All rights reserved.
//

import UIKit

// 1.定义弹出协议
protocol PresentedProtocol : class {
    func getImageView(IndexPath : NSIndexPath) -> UIImageView
    func getStartRect(indexPath : NSIndexPath) -> CGRect
    func getEndRect(indexPath : NSIndexPath) -> CGRect
}

// 2.定义消失协议
protocol DismissProtocol : class {
    func getImageView() -> UIImageView
    func getIndexPath() -> NSIndexPath
}

class ZKPhotoBrowserAnimator: NSObject {
    // MARK:- 定义属性
    var isPresented : Bool = false
    var indexPath : NSIndexPath?
    
    // 设置代理属性
    weak var presentedDelegate : PresentedProtocol?
    weak var dismissDelegate : DismissProtocol?
    
}


// MARK:- 实现photoBrowser的转场代理方法
extension ZKPhotoBrowserAnimator : UIViewControllerTransitioningDelegate {
    // 告诉弹出的动画交给谁去处理
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = true
        
        return self
    }
    
    // 告诉消失的动画交给谁去处理
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = false
        
        return self
    }
}


// MARK:- 实现photoBrowser的转场动画
extension ZKPhotoBrowserAnimator : UIViewControllerAnimatedTransitioning {
    // 1.决定动画执行时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 2.0
    }
    
    // 2.决定动画如何实现
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if isPresented {
            // 0.nil值校验
            guard let indexPath = indexPath, presentedDelegate = presentedDelegate else {
                return
            }
            
            // 1.获取弹出的View
            let presenttedView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            
            // 2.1 获取执行动画的imageView
            let imageView = presentedDelegate.getImageView(indexPath)
            transitionContext.containerView()?.addSubview(imageView)
            
            // 2.2.设置动画的起始位置
            imageView.frame = presentedDelegate.getStartRect(indexPath)
            
            // 2.3. 执行动画
                // 获取动画时间
            let duration = transitionDuration(transitionContext)
                // 设置containerView的背景色
            transitionContext.containerView()?.backgroundColor = UIColor.blackColor()
            UIView.animateWithDuration(duration, animations: { () -> Void in
                imageView.frame = presentedDelegate.getEndRect(indexPath)
                }, completion: { (_) -> Void in
                    // 将弹出的View添加到containerView中
                    transitionContext.containerView()?.addSubview(presenttedView)
                    imageView.removeFromSuperview()
                    transitionContext.containerView()?.backgroundColor = UIColor.clearColor()
                    transitionContext.completeTransition(true)
            })
            
        }else {
            // 1.控制校验
            guard let dismissDelegate = dismissDelegate, presentedDelegate = presentedDelegate else {
                return
            }
            
            // 2.取出消失的View
            let dismissView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            
            // 3.执行动画
                // 3.1 获取执行动画的imageView
            let imageView = dismissDelegate.getImageView()
            transitionContext.containerView()?.addSubview(imageView)
            
                // 3.2 取出indexPath
            let indexPath = dismissDelegate.getIndexPath()
            
                // 3.3 获取结束的位置
            let endRect = presentedDelegate.getStartRect(indexPath)
            
            dismissView?.alpha = endRect == CGRectZero ? 1.0 : 0.0
            
                // 3.4 执行动画
            let duration = transitionDuration(transitionContext)
            UIView.animateWithDuration(duration, animations: { () -> Void in
                if endRect == CGRectZero {
                    imageView.removeFromSuperview()
                    dismissView?.alpha = 0.0
                } else {
                    imageView.frame = endRect
                }
                }, completion: { (_) -> Void in
                    // 告诉系统动画执行结束,可以移除执行动画的View
                    transitionContext.completeTransition(true)
                    // 移除model出来的view
                    dismissView?.removeFromSuperview()
            })
        }
    }
}



