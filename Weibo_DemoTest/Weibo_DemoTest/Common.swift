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
//全局外观渲染颜色->延展出皮肤的管理类，
let WBAppearanceTintColor = UIColor.orangeColor()