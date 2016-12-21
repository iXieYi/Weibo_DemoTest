//
//  WelcomeViewController.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/21.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {
//设置界面的视图层次结构
    override func loadView() {
        //直接使用背景图像设置为根视图，会直接将图片缩放，设置为整屏
        view = backImageView
        setupUI()
        
    }
//视图加载完成之后的后续处理，通常用来设置数据
    override func viewDidLoad() {
        super.viewDidLoad()
        //异步加载用户头像
        iconview.sd_setImageWithURL(UserAccountViewModel.sharedUserAccount.avatarURL, placeholderImage: UIImage(named: "avatar_default_big"))

        
    }
//视图已经显示，通常可以做动画、键盘等处理
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //1.更改约束->改变位置
        //更新已经设置过得约束,multipliedBy->只读属性只能在设置的时候使用，不能再做修改
        
        //使用自动布局开发，有一个原则：所有使用约束设置的控件，创建之后，不允许再设置frame
        //原因：自动布局系统，会根据设置的约束，自动计算控件的frame
        //在layoutSubView 中设置frame
        //如果程序员修改，会引起自动布局系统计算错误
        //工作原理：当有一个运行循环启动，自动布局系统会收集所有的约束变化，
        //在运行循环结束前，调用layoutSubView 函数统一设置Frame
        //如果希望某些约束，提前更新，使用layoutIfNeeded 函数自动布局系统提前更新收集到的约束变化
        
        iconview.snp_updateConstraints { (make) -> Void in
         make.bottom.equalTo(view.snp_bottom).offset(-view.bounds.height+200)
            
        }
        //2.动画
        welcomeLabel.alpha = 0
        UIView.animateWithDuration(1.2,
            delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: [], animations: { () -> Void in
                //修改所有可动画属性
               //自动布局动画
                self.view.layoutIfNeeded()//更新收集到的变化值，因为所有约束是加载在根视图上的，所以更新view就有动画了
                
            }){(_) -> Void in
            //动画结束时调用
              UIView.animateWithDuration(0.5, delay: 0, options: [], animations: { () -> Void in
                self.welcomeLabel.alpha = 1
                }, completion: { (_) -> Void in
            //标签显示时动画
                    print("OK")
              })
                
             }
        
    }
    
    
   //MARK: - 懒加载 -背景图像
    private lazy var backImageView:UIImageView = UIImageView(imageName: "new_feature_4")
    //用户头像
    private lazy var iconview:UIImageView = {
    let iv = UIImageView(imageName: "avatar_default_big")
    //设置圆角
     iv.layer.cornerRadius = 45
     iv.layer.masksToBounds = true

    return iv
    }()
    //欢迎标签，带默认值的参数可以随意删减
    private lazy var welcomeLabel:UILabel = UILabel(title: "欢迎归来", fontSize: 18)
    
}

//MARK： - 设置界面
extension WelcomeViewController{

    private func setupUI(){
    //1.添加控件
        view.addSubview(iconview)
        view.addSubview(welcomeLabel)
    //2.自动布局
        //头像
        iconview.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp_centerX)
            make.bottom.equalTo(view.snp_bottom).offset(-200)
            make.width.equalTo(90)
            make.height.equalTo(90)
        }
        //标签
        welcomeLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(iconview.snp_centerX)
            make.top.equalTo(iconview.snp_bottom).offset(16)
            
            
        }
    
    }




}