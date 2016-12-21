//
//  UserAccountViewModel.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/16.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import Foundation

//用户账号视图模型 - 没有父类
/*
模型通常继承自 NSobject  -> 可以使用KVC设置属性，简化对象构造
如果没有父类，所有的内容都要从头创建
作用：封装“业务逻辑的” 、通常没有复杂的逻辑


*/
class UserAccountViewModel {
    
    //单例 -解决重复从沙盒读取文件，提高效率
    static let sharedUserAccount = UserAccountViewModel()
    
    //用户模型
    var account:UserAccount?
    //MARK:-计算型属性，封装小的业务逻辑
    //返回有效的token 
    var accessToken:String?{
        if !isExpired{
        
        return account?.access_token
            
        }
    
    return nil
    }
    //用户登录标记,计算型属性
    var logon: Bool{
    //1.token有值
        
    //2.如果没有过期
        
     return account?.access_token != nil && !isExpired
    
    }
    
   
    /// 用户头像
    var avatarURL:NSURL{
    return NSURL(string: account?.avatar_large ?? "")!
    
    }
    
    
    //计算型属性（类似于有返回值的函数）->归档保存的属性
    //OC中可以通过只读属性，或函数的方式实现
    private var accountPath: String{
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last!
        return (path as NSString).stringByAppendingPathComponent("account.plist")
    }
    
    /*上面的函数写法
    private var accountPath（）->String{
    let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last!
    return (path as NSString).stringByAppendingPathComponent("account.plist")
    }
    */
    
    /// 判断账户是否过期
    private var isExpired:Bool{
        
    //自己改写日期，以验证逻辑是否正确,如果给负数，就会返回比当前时间早的日期
    //account?.expiresDate = NSDate(timeIntervalSinceNow: -3600)
        //与当前系统日期比较
    //下面两个问号，account 如果为nil,就不会调用后面的属性，后面的比较也不会继续 
     if  account?.expiresDate?.compare(NSDate()) == NSComparisonResult.OrderedDescending//降序
     {
        
        //如果没有过期
        return false
     }else{
        //如果过期放回ture
        return true
        }
    }
    
    //构造函数 -私有化，要求外部只能通过单例常量访问，不能直接访问
  private init(){
    //从沙盒解档
    account = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? UserAccount
    //判断token是否过期
        if isExpired{
    print("已经过期")
    //如果过期，清空解档数据
        account = nil
        }
        
        print(account)
    
    }
}

//用户账户相关的网络方法
extension UserAccountViewModel{
    //加载token
    func loadAccessToken(code:String,finished:(isSuccess:Bool)->()){
        //加载accessToken
        NetworkTools.sharedTools.loadAccessToken(code) { (result, error) -> () in
            
            //1>.出错处理
            if error != nil {
                print("出错了")
                finished(isSuccess: false)
                return
            }
            //2>.输出结果
            //在Swift中任何的anyobject,必须装换类型->as 类型
            
             self.account = UserAccount(dict:result as! [String: AnyObject])
            //            print(account)
            
            self.loadUserInfo(self.account!,finished: finished)
        }
    
    
    }
    //加载用户信息
    private func loadUserInfo(account:UserAccount,finished:(isSuccess:Bool)->()){
        NetworkTools.sharedTools.loadUserInfo(account.uid!) { (result, error) -> () in
            
            if error != nil{
                print("出错了")
                finished(isSuccess: false)
                return
            }
            //提示：如果使用if let 或者guard let,as均使用'？'
            //1.判断result 一定有内容，2.一定是字典
            guard let dict = result as? [String: AnyObject] else{
                print("格式错误")
                 finished(isSuccess: false)
                return
            }
            
            account.screen_name = dict["screen_name"] as? String
            account.avatar_large = dict["avatar_large"] as? String
            //保存对象
//            account.saveUserAccount()
            NSKeyedArchiver.archiveRootObject(account, toFile: self.accountPath)
            print(self.accountPath)
            //完成回调
            finished(isSuccess: true)
        }
        
    }


}


