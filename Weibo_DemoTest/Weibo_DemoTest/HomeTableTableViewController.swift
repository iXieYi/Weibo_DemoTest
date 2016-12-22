//
//  HomeTableTableViewController.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/11.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit

class HomeTableTableViewController: VisitorTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if UserAccountViewModel.sharedUserAccount.logon{//如果用户没有登录
            //可选项:当visitorView存在时调用该方法
            visitorView?.setupInfo(nil, title: "关注一些人，回这里看看有什么惊喜")
        }
        loadData()
    }

    private func loadData(){
    
    NetworkTools.sharedTools.loadStatus { (result, error) -> () in
        
        if error != nil {
             print("出错了。。。")
            return
           }
        
        print(result)
     }
    
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
