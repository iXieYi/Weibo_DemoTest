//
//  OAuthViewController.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/15.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit
//用户登录控制器
class OAuthViewController: UIViewController{
private lazy var webView = UIWebView()
    //MARK：- 监听方法
    @objc private func close(){
    
    dismissViewControllerAnimated(true, completion: nil)
    
    }
    //自动填充用户名和密码
    //web注入，以代码的方式向web界面添加内容
    @objc private func autoFill(){
        let js = "document.getElementById('userId').value = '13138181385';"+"document.getElementById('passwd').value = 'a0123456789b';"
        //让webview加载js函数
        webView.stringByEvaluatingJavaScriptFromString(js)
    
    
    }
    //MARK： - 设置界面
    override func loadView() {
        //设置代理来监听网页的跳转
        webView.delegate = self
        
        view = webView
        //设置导航栏
        title = "登录新浪微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: "close")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", style: .Plain, target: self, action: "autoFill")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //在开发中，如果使用纯代码开发，视图最好都指定背景颜色，如果为nil会影响渲染效率
        view.backgroundColor = UIColor.whiteColor()
        //加载页面
        webView.loadRequest(NSURLRequest(URL:  NetworkTools.sharedTools.oauthURL))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: -UIWebViewDelegate
extension OAuthViewController:UIWebViewDelegate{
    ///将要加载的请求时
    ///
    /// - parameter webView:        webView
    /// - parameter request: 将要加载的请求，返回false不加载，返回true 继续加载
    /// - parameter navigationType: 页面跳转的方式
    ///
    /// - returns: 返回false不加载，返回true 继续加载
    ///通常ios代理方法中，返回true很正常，返回false 就说明有问题
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //目标是过滤非微博网页
        guard let url  = request.URL where url.host == "www.baidu.com" else{
            return true
        }
        
        //2.到此处一定是百度地址，从url中判断code=是否存在，存在就说明有授权码
        guard let query = url.query where query.hasPrefix("code=")  else{
        
        print("取消授权")
        return false
        }
        //3.从query中提取后面的授权码
       let code = query.substringFromIndex("code=".endIndex)
//        //主机地址
//        print(url.host)
//        //查询字符串
//        print(url.query)
        print("授权码是:\(code)")
//        print("授权码是"+code)
        
        //4.加载accessToken
        UserAccountViewModel.sharedUserAccount.loadAccessToken(code) { (isSuccess) -> () in
            
            if !isSuccess{
            print("失败了")
            return
            }
            
            print("成功了")
            //登录成功后将界面取消
            //不会立即销毁 dismissViewControllerAnimated
            self.dismissViewControllerAnimated(false){//当控制器完全被销毁后才执行通知，不然会出现多次创建控制器的现象
                //通知中心是同步的,一旦发送通知，会先执行监听方法，直到结束后，才会执行后续代码
                NSNotificationCenter.defaultCenter().postNotificationName(WBSwitchRootViewControllerNotification, object: "welcome")//"welcome",以区别通知类型
                }
//            print(UserAccountViewModel.sharedUserAccount.account)
                print("come here")
        }
        return false
    }
}





