//
//  UserAccount.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/16.
//  Copyright © 2016年 xieyi. All rights reserved.
//
//用户账户模型，一般模型都是设置继承于NSObject
import UIKit

class UserAccount: NSObject
{
/// 用户授权的唯一票据，用于调用微博的开放接口，同时也是第三方应用验证微博用户登录的唯一票据，第三方应用应该用该票据和自己应用内的用户建立唯一影射关系，来识别登录状态，不能使用本返回值里的UID字段来做登录识别。
    var access_token: String?
/// access_token的生命周期，单位是秒数
    //一旦赋值马上修改，在OC中可以使用，重写Set方法
    var expires_in: NSTimeInterval = 0{//一般的数据类型是需要初始化赋值的
        didSet{
            //计算过期日期
        expiresDate = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    var remind_in:String?
/// 过期日期,一旦从服务器获得过期日期的时间时，立刻计算准确的日期
    var expiresDate:NSDate?
    
/// 授权用户的UID，本字段只是为了方便开发者，减少一次user/show接口调用而返回的，第三方应用不能用此字段作为用户登录状态的识别，只有access_token才是用户授权的唯一票据。
    var uid: String?
    var screen_name:String? //用户昵称
    var avatar_large:String? //用户头像地址（大图），180×180像素
    
    //初始化调用的方法
    init(dict:[String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    override var description: String{
    let key = ["access_token","expires_in","expiresDate","uid","avatar_large","screen_name"]
        
    return "\(dictionaryWithValuesForKeys(key))"
    //或者使用：dictionaryWithValuesForKeys(keys).description
    }
    
}
