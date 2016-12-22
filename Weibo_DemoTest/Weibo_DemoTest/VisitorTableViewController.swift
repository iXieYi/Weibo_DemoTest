//
//  VisitorTableViewController.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/11.
//  Copyright © 2016年 xieyi. All rights reserved.
//
/// SVProgressHUB


import UIKit

class VisitorTableViewController: UITableViewController {
/// 用户登录标记
    private var userLogin =  UserAccountViewModel.sharedUserAccount.logon
/// 访客视图
    //每个控制器有各自不同的访客视图
    var visitorView: VisitorView? //定义属性可以为外界控制器所访问
    //不能使用懒加载的原因是：在每个子控制器中，都会对visitorView进行判断，如果使用
    //懒加载，当判断为空时，访客视图依旧会被创建出来
    //lazy var visitorView: VisitorView? = VisitorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userLogin ?super.loadView():setupVisitorView()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        print(visitorView)
    }
    @objc func setupVisitorView(){
        
    visitorView = VisitorView()
    //设置代理
    //    visitorView?.delegate = self
     view = visitorView
    //添加监听方法
        visitorView?.registerButton.addTarget(self, action: "visitorViewDidRegister", forControlEvents: .TouchUpInside)
        visitorView?.loginButton.addTarget(self, action: "visitorViewDidLogin", forControlEvents: .TouchUpInside)

    //设置导航栏按钮,plain 是为纯文本提供的样式
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .Plain, target: self, action: "visitorViewDidRegister")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .Plain, target: self, action: "visitorViewDidLogin")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
}

//MARK: - 访客视图监听方法
extension VisitorTableViewController{
    
    func visitorViewDidRegister() {
       
        print("注册")
        
    }
    
    func visitorViewDidLogin() {
    print("登录")
    let vc = OAuthViewController()
    let nav = UINavigationController(rootViewController: vc)
    
    presentViewController(nav, animated: true, completion: nil)
    }
    
    
    
    
}

