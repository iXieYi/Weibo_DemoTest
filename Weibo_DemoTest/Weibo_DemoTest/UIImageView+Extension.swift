//
//  UIImageView+Extension.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/13.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit

extension UIImageView{
    /// 便利构造函数
    ///
    /// - parameter imageName: 图片名称
    ///
    /// - returns: UIImageView
    convenience init(imageName:String){
    self.init(image: UIImage(named:imageName))
    }
    



}
