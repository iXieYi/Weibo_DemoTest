//
//  ComposeControllerViewController.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 17/1/4.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import UIKit
//MARK: - 撰写微博控制器
class ComposeControllerViewController: UIViewController {

    //视图生命周期函数
    override func loadView() {
        
        view = UIView()
        setupUI()
    }
    //MARK: - 监听方法
    @objc private func close(){//关闭
    
    dismissViewControllerAnimated(true, completion: nil)
        
    }
    @objc private func SendeStatus(){//发布微博
        
        print("发布微博")
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}

//设置界面: - 设置界面
private extension ComposeControllerViewController{
    func setupUI(){
    //1.设置背景颜色
    view.backgroundColor = UIColor.whiteColor()
    //2.设置控件
    prepareNavigationBar()
    
    }
    //设置导航栏
    private func prepareNavigationBar(){
    //1.左右按钮
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: "close")
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .Plain, target: self, action: "SendeStatus")
    //2.标题视图
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 36))
//        titleView.backgroundColor = UIColor.redColor()
        navigationItem.titleView = titleView
        //navigationItem.titleView 指向 titleView强引用，后续的修改类似于指针内容的修改
    //3.添加子控件
        let titleLabel = UILabel(title: "发布微博", fontSize: 15)
        
        let nameLabel = UILabel(title: UserAccountViewModel.sharedUserAccount.account?.screen_name ?? "", fontSize: 13, color: UIColor.lightGrayColor())
    
        titleView.addSubview(titleLabel)
        titleView.addSubview(nameLabel)
    //4.自动布局
        titleLabel.snp_makeConstraints { (make) -> Void in
            
            make.centerX.equalTo(titleView.snp_centerX)
            make.top.equalTo(titleView.snp_top)
            
        }
        nameLabel.snp_makeConstraints { (make) -> Void in
            
            make.centerX.equalTo(titleView.snp_centerX)
            make.bottom.equalTo(titleView.snp_bottom)
            
        }
        
    }




}


