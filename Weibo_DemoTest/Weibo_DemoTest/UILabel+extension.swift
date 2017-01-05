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
    /// - screenInset :相对于屏幕左右的缩进，默认为0，居中显示，如果设置就左对齐
    /// - returns: UILabel 
    ///参数后面的的值是参数的默认值，如果不传递，就使用默认值，打括号时先敲半个才能出来
    convenience init(title:String,fontSize:CGFloat = 14,color:UIColor = UIColor.darkGrayColor(),screenInset: CGFloat = 0){
        self.init()
        text = title
        textColor = color // 设定了默认值
        
        font = UIFont.systemFontOfSize(fontSize)
        numberOfLines = 0
        if screenInset == 0 {
        textAlignment = NSTextAlignment.Center
        }else{
            //设置 文本 换行宽度
            preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 2 * screenInset
            textAlignment = .Left
        }
        sizeToFit()
        
    }



}
