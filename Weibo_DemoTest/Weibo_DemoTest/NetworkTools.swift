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
    
//    private var tokenDict: [String: AnyObject]?{
//        //判断TOKEN是否有效
//        if let token = UserAccountViewModel.sharedUserAccount.accessToken{
//            
//        return ["access_token":token]
//        }
//        return nil
//    }
}

//MARK: - 发布微博
extension NetworkTools{
    /// 发布微博
    ///
    /// - parameter status:   微博文本
    /// - parameter image:   上传图片
    /// - parameter finished: 完成回调
    /// - see:[http://open.weibo.com/wiki/2/statuses/update](http://open.weibo.com/wiki/2/statuses/update)
    /// -see:[http://open.weibo.com/wiki/2/statuses/upload](http://open.weibo.com/wiki/2/statuses/upload)
    func sendStatus(status:String,image:UIImage?,finished:XYRequestCallBack){
    
        //1.创建参数字典
        var params = [String: AnyObject]()
    
        
        //2.设置设置参数
        params["status"] = status
        
        //3.判断是否上传图片
        if image == nil {
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        
        //3.发起网络请求
        tokenRequest(.POST, URLString: urlString, parameters: params, finished: finished)
        }else{
        
        let urlString = "https://upload.api.weibo.com/2/statuses/upload.json"
        let data = UIImagePNGRepresentation(image!)
        upload(urlString, data: data!, name: "pic", parameters: params, finished: finished)
        
        }
        
}


}


//MARK: - 微博数据相关方法
extension NetworkTools{
    /// 加载微博数据
    ///
    /// - parameter since_id:若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    /// - parameter  max_id :若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
    /// - parameter finished: 完成回调
    /// - see [http://open.weibo.com/wiki/2/statuses/home_timeline](http://open.weibo.com/wiki/2/statuses/home_timeline)
    func loadStatus(since_id since_id:Int, max_id:Int, finished:XYRequestCallBack){
        //1.创建参数字典
        var params = [String: AnyObject]()
   
        if since_id > 0 {         //判断是否下拉
            
        params["since_id"] = since_id
            
        }else if max_id > 0 {     //判断是否是上拉刷新
        //TODO: - 稍后演示
        params["max_id"] = max_id - 1
        
        }
    //2.准备网络参数
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
    //3.发起网络请求
        tokenRequest(.GET, URLString: urlString, parameters: params, finished: finished)
    }


}
//MARK: - OAuth 用户相关方法
extension NetworkTools{
    /// 加载用户信息
    ///
    /// - parameter uid:          uid
    /// - parameter fininshed:    完成回调
    /// -see [http://open.weibo.com/wiki/2/users/show](http://open.weibo.com/wiki/2/users/show)
    
    func loadUserInfo(uid:String,fininshed:XYRequestCallBack){
    
        //1.创建参数字典
        var params = [String: AnyObject]()
        
     //处理网络参数
    let urlString = "https://api.weibo.com/2/users/show.json"
    params["uid"] = uid
        tokenRequest(.GET, URLString: urlString, parameters: params, finished: fininshed)
    
    }

    
    
    
}



//MARK: - OAuth 相关方法
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


//MARK: - 封装AFN网络方法(将其私有化)
extension NetworkTools{
    /// 使用token 进行网络请求
    ///
    /// - parameter method:     Get/POST
    /// - parameter URLString:  URLString
    /// - parameter parameters: 参数字典
    /// - parameter finished:   完成回调
    private func tokenRequest(method:XieYiRequestMethod, URLString:String,var parameters:[String:AnyObject]?,finished:XYRequestCallBack){
        
    //1.设置token 参数 ->将token 添加到字典中
        
        guard let token = UserAccountViewModel.sharedUserAccount.accessToken else{
            
            //token无效
            //如果字典为空通知调用方
            finished(result: nil, error: NSError(domain: "cn.itcast.error", code: -1001, userInfo: ["message":"token nil"]))
            return
        }
        //设置parameters字典
        //判断参数字典是否有值
        if parameters == nil{
        
            parameters = [String:AnyObject]()
        
        }
        parameters!["access_token"] = token
        
    //2.发起网络请求
        request(method, URLString: URLString, parameters: parameters, finished: finished)
    
    
    
    }
    
    
    
    
    /// 向parameters字典中追加token 字典
    ///
    /// - parameter parameters: 参数字典
    ///
    /// - returns: 是否追加成功
    private func appendToken(var parameters:[String:AnyObject]?)->Bool{
    
    parameters!["access_token"] = "123"
    return true
    }
    
    /// 网路请求
    ///
    /// - parameter method:     Get/POST
    /// - parameter URLString:  URLString
    /// - parameter parameters: 参数字典
    //              parameters:参数是要可选项，调用时才能传nil
    /// - parameter finished:   完成回调
  private  func request(method:XieYiRequestMethod, URLString:String,parameters:[String:AnyObject]?,finished:XYRequestCallBack){
    
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
    
    //上传图片文件
    private func upload(URLString:String,data:NSData,name:String,var parameters:[String:AnyObject]?,finished:XYRequestCallBack){
        
        //设置token字典
        
        //1.设置token 参数 ->将token 添加到字典中
        
        guard let token = UserAccountViewModel.sharedUserAccount.accessToken else{
            
            //token无效
            //如果字典为空通知调用方
            finished(result: nil, error: NSError(domain: "cn.itcast.error", code: -1001, userInfo: ["message":"token nil"]))
            return
        }
        //设置parameters字典
        //判断参数字典是否有值
        if parameters == nil{
            
            parameters = [String:AnyObject]()
            
        }
        parameters!["access_token"] = token
        
        
        //1.data:yao 上传文件的二进制数据
        //2.name:是服务器的定义的字段名称，后台接口文档会提示
        //3.file:是保存在服务器的文件名，单通常可以随意写 - 根据上传的文件生成缩略图，中等，高清图
        //保存在不同路径，并且自动生成文件名，filename 是HTTP定义的属性
        //mineType / contentType 是客户端告诉服务器的准确类型 -大类型/小类型
        //image/jpg image/gif image/png text/plain text/html application/json
        //如果不想告诉服务器准确类型的话，可以使用：application/octet-stream(8进制的流)
        
        
        POST(URLString, parameters: parameters, constructingBodyWithBlock: { (formData) -> Void in
            formData.appendPartWithFileData(data, name: name, fileName: "xxx", mimeType: "application/octet-stream")
            }, progress: nil, success: { (_, result) -> Void in
                
                finished(result: result, error: nil)
            }) { (_, error) -> Void in
                print(error)
                finished(result: nil, error: error)
           }
    
    
    
    }
}