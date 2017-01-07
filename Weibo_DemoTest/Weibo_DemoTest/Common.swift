//
//  Common.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/13.
//  Copyright © 2016年 xieyi. All rights reserved.
//
/// 目的：提供全局共享属性、方法，类似于pch文件
import UIKit

/// MARK:- 全局通知定义
//切换根视图控制器通知 - 一定要与系统区别，一定要有前缀
let WBSwitchRootViewControllerNotification = "WBSwitchRootViewControllerNotification"

//选中照片的通知
let WBStatusSelectPhotoNotification = "WBStatusSelectPhotoNotification"
/// 选中照片的KEY -indexpath
let WBStatusSelectPhotoIndexPath = "WBStatusSelectPhotoIndexPath"
/// 图片数组 - url数组
let WBStatusSelectPhotoUrlKey = "WBStatusSelectPhotoUrlKey"

//全局外观渲染颜色->延展出皮肤的管理类，
let WBAppearanceTintColor = UIColor.orangeColor()
///MARK:-全局函数

/// 延迟在主线程执行的函数
///
/// - parameter delta:    延迟时间
/// - parameter callFunc: 要执行的闭包
func delay(delta:Double,callFunc:()->()){

    //延迟方法
    dispatch_after(
    dispatch_time(DISPATCH_TIME_NOW, Int64(delta * Double(NSEC_PER_SEC))),
    dispatch_get_main_queue()) {
        
    
        callFunc()
    }

}