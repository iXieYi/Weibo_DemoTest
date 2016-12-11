//
//  MainTabBarController.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/11.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        //创建所有控制器需要的按键
        super.viewWillAppear(animated)
        //将自定义的按键添加到最前端
        
    }
    //MARK: - 懒加载
    private lazy var composedButton:UIButton = {
        //自定义样式按键
        let button = UIButton()
        button.setImage(UIImage(named: ""), forState:UIControlState.Normal)
        button.setImage(UIImage(named: ""), forState: UIControlState.Highlighted)
        button.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: ""), forState: UIControlState.Highlighted)
        //根据图片大小调整尺寸
        button.sizeToFit()
        return button
        
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}

//MARK: - 设置界面
extension MainTabBarController{
    
    private func setupComposedButton() {
        //1.添加按钮
    
        
        
    }
    
    
    
    
    
    
}
