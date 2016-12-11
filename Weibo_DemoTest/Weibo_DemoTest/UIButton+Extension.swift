//
//  UIButton+Extension.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/11.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit
 
extension UIButton{
/// 便利构造函数
    convenience init(imageName:String,backImageName:String) {
        self.init()
        setImage(UIImage(named: imageName), forState:UIControlState.Normal)
        setImage(UIImage(named: imageName+"_highlighted"), forState: UIControlState.Highlighted)
        setBackgroundImage(UIImage(named: backImageName), forState: UIControlState.Normal)
        setBackgroundImage(UIImage(named: backImageName+"_highlighted"), forState: UIControlState.Highlighted)
        //根据图片大小调整尺寸
        sizeToFit()
        
    }
}