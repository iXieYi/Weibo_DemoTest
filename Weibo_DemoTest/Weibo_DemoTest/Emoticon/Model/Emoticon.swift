//
//  Emoticon.swift
//  表情键盘
//
//  Created by 谢毅 on 16/12/31.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit
//表情模型
class Emoticon: NSObject {
    /// 发送给服务器的表情字符串
    var chs:String?
    /// 在本地显示的字符串 + 加表情包路径
    var png:String?
    /// emoticon 的字符串编码
    var code:String?{
        didSet{
            emoji = code?.emoji
            
        }
    }

    //emoji 的字符串
    var emoji:String?    //完整路径
    //删除按钮标记
    var isRemoved = false
    init(isRemoved:Bool) {
        self.isRemoved = isRemoved
    }
    
    //是否空白标记
    var isEmpty = false
    init(isEmpty:Bool) {
        self.isEmpty = isEmpty
    }
    
    
    
    
    
    var imagePath:String{
        if png == nil {
            
            return ""
        }
        //拼接完整路径
       
        return  NSBundle.mainBundle().bundlePath + "/Emoticons.bundle/" + png!
    
    }
    
    init(dict:[String: AnyObject]){
        super.init()

        setValuesForKeysWithDictionary(dict)
        
    
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    
    override  var description:String {
        
    let keys = ["chs","png","code","isRemoved"]
        
    return dictionaryWithValuesForKeys(keys).description
        
    
    }
}
