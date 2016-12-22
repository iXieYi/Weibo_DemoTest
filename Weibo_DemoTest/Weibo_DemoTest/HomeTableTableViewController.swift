//
//  HomeTableTableViewController.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/11.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit
import SVProgressHUD
/// 微博cellId
private let StatusCellNormalId = "StatusCellNormalId"


class HomeTableTableViewController: VisitorTableViewController {
    //微博数据列表模型
    private lazy var lisViewtModel = StatusListViewModel()
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
    
    
    
    }
    
    
    private func loadData(){
    lisViewtModel.loadStatus { (isSuccess) -> () in
        
        if !isSuccess{
        
        SVProgressHUD.showInfoWithStatus("加载数据错误，请稍后再试")
        }
        print(self.lisViewtModel.statuslist)
        //刷新数据
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
        return lisViewtModel.statuslist.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusCellNormalId, forIndexPath: indexPath)
        
        cell.textLabel?.text = lisViewtModel.statuslist[indexPath.row].status.user?.screen_name
        return cell
    }

}
