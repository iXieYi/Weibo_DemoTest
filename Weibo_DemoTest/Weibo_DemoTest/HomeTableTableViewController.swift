//
//  HomeTableTableViewController.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/11.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit

/// 微博cellId
private let StatusCellNormalId = "StatusCellNormalId"


class HomeTableTableViewController: VisitorTableViewController {

    //微博数据
    var datalist:[Status]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserAccountViewModel.sharedUserAccount.logon{//如果用户没有登录
            //可选项:当visitorView存在时调用该方法
            visitorView?.setupInfo(nil, title: "关注一些人，回这里看看有什么惊喜")
        }
        prepareTableView()
        loadData()
    }
    
/// 准备表格数据
    private func prepareTableView(){
    //注册可重用cell
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: StatusCellNormalId)
    //
    
    
    
    }
    
    
    private func loadData(){
    
    NetworkTools.sharedTools.loadStatus { (result, error) -> () in
        
        if error != nil {
             print("出错了。。。")
            return
           }
        //转成数组
        guard let array = result!["statuses"] as? [[String:AnyObject]] else{
        
            print("数据格式错误")
            return
        }
        //便历数组，字典转模型
        //1.可变数组
        var arrayM = [Status]()
        //2.遍历数组
        for dict in array{
        arrayM.append(Status(dict: dict))
        }
        
        //3.测试
        print(arrayM)
        
        self.datalist = arrayM
        //4.刷新数据
        self.tableView.reloadData()
        
     }
    
   }
    
    

    

    

   }
//MARK:-实现数据源方法
extension HomeTableTableViewController{
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datalist?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusCellNormalId, forIndexPath: indexPath)
        
        cell.textLabel?.text = datalist![indexPath.row].text
        return cell
    }

}
