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
let StatusCellNormalId = "StatusCellNormalId"
//转发微博的可重用id
let StatusCellRetweetedId = "StatusCellRetweetedId"


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
        
    //注册原创微博cell
    tableView.registerClass(StatusNormalCell.self, forCellReuseIdentifier: StatusCellNormalId)
        
    //注册可重用转发cell
    tableView.registerClass(StatusRetweetedCell.self, forCellReuseIdentifier:StatusCellRetweetedId)
    //取消分割线
        tableView.separatorStyle = .None
    //临时行高
        //1、预估行高  - 尽量准确这样布局效率就越高
        tableView.estimatedRowHeight = 400
        
        
        
        //2、自动计算行高 - 需要一个自上而下的自动布局控件 ，指定一个向下的约束
//        tableView.rowHeight = UITableViewAutomaticDimension
    /*解释说明
        1、从上自下计算控件的位置
        2、从下自上，按照底部的约束挤到最合适的位置
        3、在cell中找一个之上而下能找到的控件，指定其底部约束，最后才能得到自动布局的行高
        4、在使用自动布局的时候，绝大数出现问题是因为，约束加多了
        */
    
    }
    
    
    private func loadData(){
    lisViewtModel.loadStatus { (isSuccess) -> () in
        
        if !isSuccess{
        
        SVProgressHUD.showInfoWithStatus("加载数据错误，请稍后再试")
        }
//        print(self.lisViewtModel.statuslist)
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
        
        //下面这句话不会调用行高方法，不推荐使用
        // tableView.dequeueReusableCellWithIdentifier()
        //获取视图模型
        let vm = lisViewtModel.statuslist[indexPath.row]
        
        //下面这句话会调用行高计算代码
        let cell = tableView.dequeueReusableCellWithIdentifier(vm.cellId, forIndexPath: indexPath) as! StatusCell // 多态的应用
        
//        cell.textLabel?.text = lisViewtModel.statuslist[indexPath.row].status.user?.screen_name
        cell.viewModel = vm
        return cell
    }
    
    //tableView行高变化需要写这个代理方法
    //tableView的行高 -会被计算
    /*
   》 设置了预估行高的前提下：
      当前显示的行高方法会被调用3次，不同版本的cell会有所不同
      1、使用预估行高，会计算预估的contentSize
      2、根据预估的行高，判断计算次数，顺序计算每一行的行高，更新contentSize
      3、如果预估行高过大，超出预估范围，顺序计算后续行高，一直到填满屏幕退出，同时更新contentSize
      4、使用预估行高，每个cell显示前需要计算，单个cell效率是低的，整体效率高
      执行顺序
       行数 -> 每个[cell -> 行高]
    
    预估行高：尽量靠近
    
   》 没设置预估行高时：
      1.会计算所有行的高度
      2.再计算显示行的高度
    执行顺序
    行数->行高->cell
    为什么要调用所有行高方法呢，UITableview继承自UIscrollView
    表格视图滚动非常流畅—>需要提前计算出contentSize
    */
    //苹果官方文档指出，如果行高是固定值，就不要实现行高的代理方法
    //实际开发中行高一定是需要缓存的
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        //1.视图模型
        let vm = lisViewtModel.statuslist[indexPath.row]
        
        return vm.rowHeight
        
        
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("选中行\(indexPath)")
    }
}
