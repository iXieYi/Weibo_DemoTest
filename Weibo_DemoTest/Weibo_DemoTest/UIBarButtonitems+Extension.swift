//
//  UIBarButtonitems+Extension.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 17/1/5.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import UIKit
extension UIBarButtonItem{
    /// 便利构造函数
    ///
    /// - parameter imageName:  图像名
    /// - parameter target:     监听对象
    /// - parameter actionName: 监听图像名
    ///
    /// - returns: UIbutton
    convenience init(imageName:String,target:AnyObject?,actionName:String?) {
        
        let button = UIButton(imageName: imageName, backImageName: nil)
        //判断actionName
        if let actionName = actionName{
            //按钮监听方法传入字符串变量时，应该注意转换
            button.addTarget(target, action:Selector(actionName), forControlEvents: .TouchUpInside)
            
        }
     self.init(customView: button)
        
}




}
