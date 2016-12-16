//
//  UserAccount.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/16.
//  Copyright © 2016年 xieyi. All rights reserved.
//
//用户账户模型，一般模型都是设置继承于NSObject
import UIKit

class UserAccount: NSObject,NSCoding
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
    
    //MARK: -保存当前对象
    func saveUserAccount(){
        
    //1.保存路径
    var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last!
    //2.拼接文件名
    //Xcode7 beta5以后 stringByAppendingPathComponent，方法归nsstring所有了
    //单纯的 as 在swift 三个地方将会被使用 桥接
       //1.string as NSString
       //2.NSArray as [array]
       //3.NSDictionary as [String : AnyObject]
    path = (path as NSString).stringByAppendingPathComponent("account.plist")
    //在实际开发中一定要保证文件存下了
        
        print(path)
    //3.保存归档
    NSKeyedArchiver.archiveRootObject(self, toFile: path)
    
    
    }
//MARK: - 归档和解档
    /// 归档，将当前对象保存到磁盘上时，将对象编码成二进制数据 - 同网络序列化相似
    ///
    /// - parameter aCoder: 编码器
     func encodeWithCoder(aCoder: NSCoder)
    {
    
    aCoder.encodeObject(access_token, forKey: "access_token")
    aCoder.encodeObject(expiresDate, forKey: "expiresDate")
    aCoder.encodeObject(uid, forKey: "uid")
    aCoder.encodeObject(screen_name, forKey: "screen_name")
    aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    
    }
    /// 解档 - 从磁盘加载二进制文件，转化为对象时调用 - 跟网络的反序列化相似
    ///
    /// - parameter aDecoder: aDecoder 解码器
    ///
    /// - returns: 当前对象
    ///required 只在解档中使用 - 没有继承性，只能解出当前的类对象
     required init?(coder aDecoder: NSCoder){
    
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expiresDate = aDecoder.decodeObjectForKey("expiresDate") as? NSDate
        uid = aDecoder.decodeObjectForKey("uid") as? String
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    
    }
}
/// 在extsion中只能写便利构造函数，不能写指定构造函数
///同时在其中不能定义存储型属性，这样会修改类的结构，






