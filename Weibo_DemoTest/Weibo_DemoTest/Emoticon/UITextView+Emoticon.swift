//
//  UITextView+Emoticon.swift
//  表情键盘
//
//  Created by 谢毅 on 17/1/4.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import UIKit
/*
代码复合： - 对重构完成的代码进行检查
1.修改注释：
2.确认是否需要进一步重构
3.再一次检查方法和返回值

*/
extension UITextView{

    /// 表情图片字符串
    ///
    /// - returns: 完整字符串内容
    var emoticonText:String {
        
        let attrText = attributedText
        
        var strM = String()
        //遍历属性文本
        attrText.enumerateAttributesInRange(
            NSRange(location: 0, length: attrText.length),//设置遍历范围
            options: []) { (dict, range, _) -> Void in
                //分段循环调试技巧
                
                //如果字典中包含  NSTextAttachment 说明是图片
                //否则是字符串，可以通过range 获得
                //如何在attachment中包含该“哈哈”
                if let attachment = dict["NSAttachment"] as? EmoticonAttchment{
                    
                    print("图片\(attachment.emoticon)")
                    strM += attachment.emoticon.chs ?? ""
                }else{
                    
                    let str = (attrText.string as NSString).substringWithRange(range)
                    
                    strM += str
                }
        }
        return strM
    }

    
    
    
    //插入表情符号
    func insertEmotion(em:Emoticon){
        
        //    text = em.chs
        //1.空白表情
        if em.isEmpty {
            
            return
        }
        //2.删除按钮
        if em.isRemoved{
            deleteBackward()
            
            return
        }
        //3.Emoji
        if let emoji = em.emoji {
            
            replaceRange(selectedTextRange!, withText: emoji)
            
            return
        }
        //4.图片表情
        insertImageEmotion(em)
        
        //5.通知 代理 文本发生变化了 - textViewDidChange “?”代理如果什么都没有实现，更安全
         delegate?.textViewDidChange?(self)
        
    }
    /// 插入图片表情
    private func insertImageEmotion(em:Emoticon){
         //1.图片属性文本
        let imageText = EmoticonAttchment(emoticon: em).imageText(font!)
        //2.插入到属性文本 ->装换成可变文本
        let strM = NSMutableAttributedString(attributedString: attributedText)
        //3.插入图片
        strM.replaceCharactersInRange(selectedRange, withAttributedString: imageText)
        //4.替换属性文本(全部替换过)
        //1>记录光标位置
        let range = selectedRange
        //2>替换文本
        attributedText = strM
        //3>恢复光标,length是表示之前选中的文本信息，在之后显示的长度，因为是替换掉的，所以设置为零
        selectedRange = NSRange(location: range.location + 1, length: 0)
        
    }


}
