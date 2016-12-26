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
    var pic_urls:[[String: String]]?  //微博配图数组，thumbnail_pic
    //字典转模型的嵌套
    var user:User?  //用户模型,使用KVC时，Value是一个字典，会直接给属性装换成字典
    var retweeted_status:Status? //被转发的微博
    
    init(dict:[String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)//会执行setValue方法
        
    }
    override func setValue(value: AnyObject?, forKey key: String) {
        //判断key 是否是User
        if key == "user"{
            if let dict = value as? [String: AnyObject]{
            
                user = User(dict: dict)
            }
            return //表示一旦是user就不交给kvc做了
        }
        //判断key 是否是retweeted_status
        if key == "retweeted_status"{
            if let dict = value as? [String: AnyObject]{
            
            retweeted_status = Status(dict: dict)
            
            }
        return
        }
        
        //kvc会把新建的属性对象又变成字典
        super.setValue(value, forKey: key)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    override var description: String{
    let key = ["id","text","created_at", "source","user","pic_urls","retweeted_status"]
    return dictionaryWithValuesForKeys(key).description
    }
}
