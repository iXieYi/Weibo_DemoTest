//
//  OAuthViewController.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/15.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit
//用户登录控制器
class OAuthViewController: UIViewController {
private lazy var webView = UIWebView()
    //MARK：- 监听方法
    @objc private func close(){
    
    dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    //MARK： - 设置界面
    override func loadView() {
        view = webView
        //设置导航栏
        title = "登录新浪微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: "close")
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
