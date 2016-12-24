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
    tableView.registerClass(StatusCell.self, forCellReuseIdentifier: StatusCellNormalId)
    //取消分割线
        tableView.separatorStyle = .None
    //临时行高
        //1、预估行高
        tableView.estimatedRowHeight = 200
        //2、自动计算行高 - 需要一个自上而下的自动布局控件 ，指定一个向下的约束
        tableView.rowHeight = UITableViewAutomaticDimension
    /*解释说明
        1、从上自下计算控件的位置
        2、从下自上，按照底部的约束挤到最合适的位置
        3、在cell中找一个之上而下能找到的控件，指定其底部约束，最后才能得到自动布局的行高
        */
    
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusCellNormalId, forIndexPath: indexPath) as! StatusCell
        
//        cell.textLabel?.text = lisViewtModel.statuslist[indexPath.row].status.user?.screen_name
        cell.viewModel = lisViewtModel.statuslist[indexPath.row]
        return cell
    }

}
