//
//  Status.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/22.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit
/// 微博数据模型

class Status: NSObject {
    
    var id:Int = 0         //微博ID
    var text:String?       //微博信息内容
    var created_at:String? //微博创建时间
    var source:String?     //微博来源
    
    
    init(dict:[String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    override var description: String{
    let key = ["id","text","created_at", "source"]
    return dictionaryWithValuesForKeys(key).description
    }
}
