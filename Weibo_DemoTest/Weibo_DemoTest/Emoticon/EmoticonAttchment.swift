//
//  EmoticonAttchment.swift
//  表情键盘
//
//  Created by 谢毅 on 17/1/4.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import UIKit
/// 表情附件
class EmoticonAttchment: NSTextAttachment {
    /// 表情模型
    var emoticon:Emoticon
    ///将当前附件中的emoticon 装换成属性文本
    func imageText(font:UIFont)->NSAttributedString{
    
        //线高-> lineHeight:表示字体的高度
        let lineHeigth = font.lineHeight
        //设定frame =  center + bounds * transform
        //bounds（x，y） = contentoffset bounds也是可以修改偏移的
        image = UIImage(contentsOfFile: emoticon.imagePath)
        bounds = CGRect(x: 0, y: -4, width: lineHeigth, height: lineHeigth)
        //获得图片文本
        let imageText = NSMutableAttributedString(attributedString: NSAttributedString(attachment: self))
        
        //添加字体 -UIKit.frameWork 第一个头文件之中 > 解决图片表情大小不一的问题
        imageText.addAttribute(NSFontAttributeName, value: font, range: NSRange(location: 0, length: 1))
    
        return imageText
    }
    
    
    
    init(emoticon:Emoticon){
    
        self.emoticon = emoticon
        super.init(data: nil, ofType: nil)
    
    
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
