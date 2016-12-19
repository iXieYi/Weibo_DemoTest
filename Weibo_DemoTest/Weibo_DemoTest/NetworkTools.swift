//
//  NetworkTools.swift
//  AFN_Swift
//
//  Created by 谢毅 on 16/12/15.
//  Copyright © 2016年 xieyi. All rights reserved.
//
/*微博开发信息
App Key：3054595708
App Secret：32f56a9f8658891771048eccfd563ca7
授权回调页：http://www.baidu.com
取消授权回调页：http://www.baidu.com
*/
import UIKit
import AFNetworking //swift使用框架时，需要导入框架的文件夹名
//枚举
enum XieYiRequestMethod:String{
    case GET = "GET"
    case POST = "POST"



}

//MARK:网络工具
class NetworkTools: AFHTTPSessionManager {
    
    //MARK: - 应用程序信息(变量的首字母小写，类的首字母大写)
   private let app_Key = "3054595708"
   private let app_Secret = "32f56a9f8658891771048eccfd563ca7"
   private let redirectURL = "http://www.baidu.com"
    ///类似于OC的typedefine,网络请求完成回调
    typealias XYRequestCallBack = (result:AnyObject?,error:NSError?)->()
    
    //单例
    static let sharedTools: NetworkTools = {
    
    let tools = NetworkTools(baseURL:nil)
    //设置反序列化 -Swift 系统会自动将OC框架中的NSSet转化为Set
    //通过该方式进行第三方框架的支持
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
    return tools
    }()
    
    private var tokenDict: [String: AnyObject]?{
        //判断TOKEN是否有效
        if let token = UserAccountViewModel.sharedUserAccount.accessToken{
            
        return ["access_token":token]
        }
        return nil
    }
}

//MARK - OAuth 用户相关方法
extension NetworkTools{
    /// 加载用户信息
    ///
    /// - parameter uid:          uid
    /// - parameter access_Token: accessToken
    /// - parameter fininshed:    完成回调
    /// -see [http://open.weibo.com/wiki/2/users/show](http://open.weibo.com/wiki/2/users/show)
    
    func loadUserInfo(uid:String,fininshed:XYRequestCallBack){
    
        guard var params = tokenDict else{
        //如果字典为空通知调用方
            fininshed(result: nil, error: NSError(domain: "cn.itcast.error", code: -1001, userInfo: ["message":"token nil"]))
            return
        
        }
        
    let urlString = "https://api.weibo.com/2/users/show.json"
    params["uid"] = uid
        request(.GET, URLString: urlString, parameters: params, finished: fininshed)
    
    }

    
    
    
}



//MARK - OAuth 相关方法
extension NetworkTools{
/// OAuth 授权URL
//下面这个注释可以将网址链接在使用 “option”+click时直接打开浏览器
/// - see: [http://open.weibo.com/wiki/Oauth2/authorize](http://open.weibo.com/wiki/Oauth2/authorize)
    var oauthURL:NSURL{
    let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_Key)&redirect_uri=\(redirectURL)"
    return NSURL(string: urlString)!
    }
    
    
    ///加载授权
    ///
    /// - parameter code: 授权码
    /// - see: [http://open.weibo.com/wiki/OAuth2/access_token](http://open.weibo.com/wiki/OAuth2/access_token)
    func loadAccessToken(code:String,finished:XYRequestCallBack){
    
    let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id":app_Key,
                     "client_secret":app_Secret,
                     "grant_type":"authorization_code",
                     "code":code,
                     "redirect_uri":redirectURL]
        //AFN默认的格式是JSON,会直接反序列化
        request(.POST, URLString: urlString, parameters: params, finished: finished)
    
        /***********
        测试返回的数据内容
        //1>设置相应的数据格式，二进制的
        //如果是NSnumber类型，在做kVC时非常重要
        responseSerializer = AFHTTPResponseSerializer()
        //2>发起网络请求
        POST(urlString, parameters: params, progress: nil, success: { (_, result) -> Void in
            
        //将二进制数据装换成字符串
        let json = NSString(data: result as! NSData, encoding: NSUTF8StringEncoding)
         print(json)
            /*
            {"access_token":"2.00RKQx9Gisli1D43dcc6e0d2TtmJkC",
            "remind_in":"157679999",
            "expires_in":157679999,
            "uid":"5924657893"}
            */
            }, failure: nil)
        *******/
    }

}


//MARK: - 封装AFN网络方法,将其私有化
extension NetworkTools{
//parameters:参数是要可选项，调用时才能穿nil
    
    /// 网路请求
    ///
    /// - parameter method:     Get/POST
    /// - parameter URLString:  URLString
    /// - parameter parameters: 参数字典
    /// - parameter finished:   完成回调
  private  func request(method:XieYiRequestMethod, URLString:String,parameters:[String:AnyObject]?,finished:(result:AnyObject?,error:NSError?)->()){
    
        //定义成功回调,当做参数进行传递
        let Success = {(task:NSURLSessionDataTask?, result:AnyObject?) -> Void in
           finished(result: result, error: nil)
        }
        
        //定义失败回调
        let failure = {(task:NSURLSessionDataTask?, error:NSError) -> Void in
            //在网络开发时，错误不需要提供给用户，但错误一定要输出
            finished(result: nil, error: error)

        }
        
        
        
        if method == XieYiRequestMethod.GET{
            
            GET(URLString, parameters: parameters, progress:nil, success: Success, failure: failure)
        }else{
        
           POST(URLString, parameters: parameters, progress:nil, success: Success, failure: failure)
        
        }
        

    }
}