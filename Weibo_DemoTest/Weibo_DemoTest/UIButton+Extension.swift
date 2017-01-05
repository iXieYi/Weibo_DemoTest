//
//  UIButton+Extension.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/11.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit
 
extension UIButton{

    
    /// - 便利构造函数
    ///
    /// - parameter imageName:     图像名称
    /// - parameter backImageName: 背景图片
    ///
    /// - returns: UIButton
    ///备注:如果图像名称使用“” 会报： CUICatalog: Invalid asset name supplied 错误
    convenience init(imageName:String,backImageName:String?) {
        self.init()
        setImage(UIImage(named: imageName), forState:UIControlState.Normal)
        setImage(UIImage(named: imageName+"_highlighted"), forState: UIControlState.Highlighted)
        if let backImageName = backImageName{
        
        setBackgroundImage(UIImage(named: backImageName), forState: UIControlState.Normal)
        setBackgroundImage(UIImage(named: backImageName+"_highlighted"), forState: UIControlState.Highlighted)
            
        }
        
        //根据图片大小调整尺寸
        sizeToFit()
        
    }
    
    ///按键便利构造函数
    ///
    /// - parameter title:         按钮标题
    /// - parameter color:         字体颜色
    /// - parameter backimageName: 图片名称
    ///
    /// - returns: UIButton
    convenience init(title:String,color:UIColor,backimageName:String){
        self.init()
            setTitle(title, forState: UIControlState.Normal)
            setTitleColor(color, forState: UIControlState.Normal)
            setBackgroundImage(UIImage(named:backimageName), forState: UIControlState.Normal)
            sizeToFit()
        }
    
    ///按键便利构造函数
    ///
    /// - parameter title:     按钮标题
    /// - parameter color:     字体颜色
    /// - parameter fonySize:  字体大小
    /// - parameter imageName: 图片名称
    ///
    /// - returns: UIButton
    convenience init(title:String,fontSize:CGFloat,color:UIColor,imageName:String){
        self.init()
        
        setTitle(title, forState: UIControlState.Normal)
        setTitleColor(color, forState: UIControlState.Normal)
        setImage(UIImage(named:imageName), forState: UIControlState.Normal)
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        sizeToFit()
    }
    
}