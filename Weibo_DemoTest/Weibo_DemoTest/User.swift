//
//  User.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/22.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit

//用户模型
class User: NSObject {
//用户UID
    var id: Int = 0
//用户昵称
    var screen_name: String?
//用户头像地址
    var profile_image_url:String?
//认证用户类型
    var verified_type: Int = 0
//会员等级
    var mbrank: Int = 0

    init(dict:[String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    override var description:String{
    let key = ["id","screen_name","profile_image_url","verified_type","mbrank"]
    
        return dictionaryWithValuesForKeys(key).description
    }
}
