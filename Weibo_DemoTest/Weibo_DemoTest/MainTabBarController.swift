//
//  MainTabBarController.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/11.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    // MARK: - 监听方法
    /// 点击撰写按钮
    /// 如果`单纯`使用 `private` 运行循环将无法正确发送消息，导致崩溃
    /// 如果使用 @objc 修饰符号，可以保证运行循环能够发送此消息，即使函数被标记为 private
    @objc private func clickbtn(){
    
    print("点了")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    addChildViewControllers()
    setupComposedButton()
        
    }
    override func viewWillAppear(animated: Bool) {
        //创建所有控制器需要的按键
        super.viewWillAppear(animated)
        //将自定义的按键添加到最前端
        tabBar.bringSubviewToFront(composedButton)
    }
    //MARK: - 懒加载
    private lazy var composedButton:UIButton = UIButton(imageName: "tabbar_compose_icon_add", backImageName: "tabbar_compose_button")
    

}

//MARK: - 设置界面
extension MainTabBarController{
/// 设置按钮
    private func setupComposedButton() {
        //1.添加按钮
        tabBar.addSubview(composedButton)
        //2.调整按钮
        let count = childViewControllers.count
        let w = tabBar.bounds.width/CGFloat(count) - 1
        composedButton.frame = CGRectInset(tabBar.bounds, 2*w, 0)
        composedButton.addTarget(self, action: "clickbtn", forControlEvents: .TouchUpInside)
        
    }
    //添加所有控制器
    private func addChildViewControllers() {
//    //设置图片渲染颜色，能用颜色设置就用颜色设置，能减少内存的消耗
//        tabBar.tintColor = UIColor.orangeColor()
    //标准的多态应用

    addChildViewController(HomeTableTableViewController(), title: "首页", imageName: "tabbar_home")
    addChildViewController(MessagTableViewController(), title: "消息", imageName: "tabbar_message_center")
    addChildViewController(UIViewController())
    addChildViewController(DiscoverTableViewController(), title: "发现", imageName: "tabbar_discover")
    addChildViewController(ProfileTableViewController(), title: "我的", imageName: "tabbar_profile")
    
    
    }
    
    
    /// 添加单个控制器
    ///
    /// - parameter vc:        控制器
    /// - parameter title:     标题
    /// - parameter imageName: 图片名称
    private func addChildViewController(vc:UIViewController,title:String,imageName:String) {
        //设置每一个子控制器的图片
        //let vc =  HomeTableTableViewController()
        //设置标题
        vc.title = title
        vc.tabBarItem.image = UIImage(named: imageName)
        
        //设置控制器
        let nav = UINavigationController(rootViewController: vc)
        addChildViewController(nav)
        
        
    }
   
    
    
    
}
