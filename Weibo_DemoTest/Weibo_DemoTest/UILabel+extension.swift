//
//  UILabel+extension.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/13.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit

extension UILabel{
    ///便利构造函数
    ///
    /// - parameter title:    标题
    /// - parameter fontSize: 字体
    /// - parameter color:    color ,默认深灰色
    ///
    /// - returns: UILabel 
    ///参数后面的的值是参数的默认值，如果不传递，就使用默认值，打括号时先敲半个才能出来
    convenience init(title:String,fontSize:CGFloat = 14,color:UIColor = UIColor.darkGrayColor()){
        self.init()
        text = title
        textColor = color // 设定了默认值
        font = UIFont.systemFontOfSize(fontSize)
        numberOfLines = 0
        textAlignment = NSTextAlignment.Center
    }





}
