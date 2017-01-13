//
//  PhotoBrowserAnimator.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 17/1/11.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import UIKit
//MARK:- 展现的动画的协议
protocol PhotoBrowerPresentDelegate:NSObjectProtocol{

    /// 指定indexPath 对应的imageView，用来做动画效果
    func imageViewForPresent(indexpath:NSIndexPath)->UIImageView
    /// 动画转场的起始位置
    func PhotoBrowerPresentFromRect(indexpath:NSIndexPath)->CGRect
    //  动画转场的目标位置
    func PhotoBrowerPresentToRect(indexpath:NSIndexPath)->CGRect

}
//MARK: - 解除动画协议
protocol PhotoBrowserDismissDelegate:NSObjectProtocol{
    //解除转场图像视图（包含起始位置）
    func imageViewForDismiss() ->UIImageView
    
    //解除转场图像索引
    func indexPathForDismiss() ->NSIndexPath
}


//MARK: - 提供动画转场的代理

class PhotoBrowserAnimator: NSObject,UIViewControllerTransitioningDelegate {
   
    //展现的代理
    weak var presentDelegate: PhotoBrowerPresentDelegate?
    //解除代理
    weak var dismissDelegate: PhotoBrowserDismissDelegate?
    //动画图像的的索引
    var indexpath:NSIndexPath?
    //是否model展现标记
    private var isPresented = false
    
    //设置代理相关参数
    func setDelegateParams(presentDelegate:PhotoBrowerPresentDelegate,
        indexPath:NSIndexPath,
        dimissDelegate:PhotoBrowserDismissDelegate)
    {
        self.presentDelegate = presentDelegate
        self.dismissDelegate = dimissDelegate
        self.indexpath = indexPath
    }
    
    
    
    //返回提供model 展现的动画对象
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    //返回退出控制器的动画对象
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
    
    
}

//MARK: - UIViewControllerAnimatedTransitioning
//实现具体的动画方法
extension PhotoBrowserAnimator: UIViewControllerAnimatedTransitioning{
    //设置时长
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    //实现具体的动画效果 - 一旦自定义了该方法，所有的动画方法就要手动实现了
    //transitionContext：转场动画的上下文
    //1.容器视图 - 会将modal 要展现的视图包装在容器视图中
    //存放的视图要显示 - 必须指定大小，不会通过自动布局填满屏幕
    //2.viewControllForKey: FromVC / ToVC
    //3.FromView / ToView
    //4.completeTransition: 必须要调用，才能告诉系统转场结束了，可以进行下一步操作了
    //如果不调用会使得系统停留在这里不做任何操作，认为转场还未结束
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        //自动布局系统不会对根视图做任何约束
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        print(fromVC)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        print(toVC)

        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        print(fromView)
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        print(toView)
        
        
        isPresented ? presentAnimation(transitionContext) :dismissAnimation(transitionContext)
        
        
    }
    
    /// 解除转场动画
    private func dismissAnimation(transitionContext: UIViewControllerContextTransitioning){
    //gurad let 会把属性变成局部变量，后续的闭包中不在需要self,也不需要考虑解包
        guard let presentDelegate = presentDelegate,
            dismissDelegate = dismissDelegate else{
        
        return
        }
    //1.获取要dimiss的控制器视图
    let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
    fromView.removeFromSuperview()
        
    //2.获取图像视图
    let iv = dismissDelegate.imageViewForDismiss()
    //添加容器视图
    transitionContext.containerView()?.addSubview(iv)
    
    //3.获取dismiss 的indexpath
        let indexpath = dismissDelegate.indexPathForDismiss()
        
    UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
        
       //让iv运动到目标位置
        iv.frame = presentDelegate.PhotoBrowerPresentFromRect(indexpath)
        
        }) { (_) -> Void in
            //将iv从父视图中删除
            iv.removeFromSuperview()
            //告诉系统动画完成
            transitionContext.completeTransition(true)
        }
    }
    
    //展现动画
    private func presentAnimation(transitionContext: UIViewControllerContextTransitioning){
        
        guard let presentDelegate = presentDelegate,indexpath = indexpath else{
            return
        }
        //1.目标视图
         //1>.获取modal要展现的控制器的根视图
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        //2>.将视图添加到视图容器中
        transitionContext.containerView()?.addSubview(toView)

        //2.图像视图
        let iv = presentDelegate.imageViewForPresent(indexpath)
        iv.frame = presentDelegate.PhotoBrowerPresentFromRect(indexpath)
        //添加到容器视图中
        
        transitionContext.containerView()?.addSubview(iv)
        
        toView.alpha = 0
        //3.开始动画
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            //指定了一个目标位置
            iv.frame = presentDelegate.PhotoBrowerPresentToRect(indexpath)
            toView.alpha = 1.0
            }) { (_) -> Void in
               // 将图像视图删除
                iv.removeFromSuperview()
               //告诉系统转场动画完成
                transitionContext.completeTransition(true)
        }
    
    }



}