//
//  VisitorView.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/12.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit
/// 访客视图处理 - 用户未登录界面显示
class VisitorView: UIView {
    //initWithFrame 是UIView指定的构造函数
    //使用纯代码开发
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupUI()
    }
    //使用SB或者xib开发加载的函数
    required init?(coder aDecoder: NSCoder) {
        //如果使用sb开发这个视图，会直接奔溃
        fatalError("init(coder:) has not been implemented")
        setupUI()
    }
   //MARK: - 懒加载控件
   //图标，使用image:构造函数创建的imageView默认就是image的大小
    //小滚动
    private lazy var iconView:UIImageView = UIImageView(image: UIImage(named:"visitordiscover_feed_image_smallicon"))
    //遮罩
    private lazy var maskIconView:UIImageView = UIImageView(image: UIImage(named:"visitordiscover_feed_mask_smallicon"))
    //小房子
    private lazy var homeIconView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    //消息文字
    private lazy var messageLabel1:UILabel = {
        let label = UILabel()
        label.text = "我亲爱的主人您还未登陆，好多新鲜有趣的事在等着你呢"
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.Center
        return label
    }()
    //登陆按钮
    private lazy var loginButton:UIButton = {
    let button = UIButton()
        button.setTitle("登陆", forState: UIControlState.Normal)
//        button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
    button.setBackgroundImage(UIImage(named:"common_button_white_disable"), forState: UIControlState.Normal)
        return button
    }()
    
    //注册按钮
    private lazy var registerButton:UIButton = {
        let button = UIButton()
        button.setTitle("注册", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named:"common_button_white_disable"), forState: UIControlState.Normal)
        return button
    }()
    
    
}

extension VisitorView{
/// 设置界面
    private func setupUI(){
    //1.添加界面
     addSubview(iconView)
//     addSubview(maskIconView)
     addSubview(homeIconView)
     addSubview(messageLabel1)
     addSubview(registerButton)
     addSubview(loginButton)
        
    //2.添加自动布局
    /* 自动布局的公式
        "view1.attr1 = view2.attr2 * multiplier + constant"
        添加约束要添加在其父视图上，子视图需要有统一的参照物
    */
        
    //translatesAutoresizingMaskIntoConstraints默认是ture支持setFrame方式设置控件，false表示设置支持自动布局设置控件位置
        //（纯代码设置自动布局时必须加上）
        for v in subviews{//遍历所有子视图，使用自动布局
        v.translatesAutoresizingMaskIntoConstraints = false
        }
        //1.图标
        /// 水平方向上的限制
        ///
        /// @param iconView 需要布局的图标
        /// @param .CenterX 需要图标设置的限制参数
        /// @param .Equal   是否等于
        /// @param self     该视图的参照物
        /// @param .CenterX 参照物对应类别的限制参数
        /// @param 1.0      公式中的放大倍数
        /// @param 0        偏移量
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0))
        //垂直方向上的限制
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: -60))
        //2.小房子
        addConstraint(NSLayoutConstraint(item: homeIconView, attribute: .CenterX, relatedBy: .Equal, toItem: iconView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: homeIconView, attribute: .CenterY, relatedBy: .Equal, toItem: iconView, attribute: .CenterY, multiplier: 1.0, constant: 0))
        //3.消息文字(参照转轮，水平居中，在其底部)
        addConstraint(NSLayoutConstraint(item: messageLabel1, attribute: .CenterX, relatedBy: .Equal, toItem: iconView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: messageLabel1, attribute: .Top, relatedBy: .Equal, toItem: iconView, attribute: .Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: messageLabel1, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 224))
        addConstraint(NSLayoutConstraint(item: messageLabel1, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 36))

        //注册按钮
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .Right, relatedBy: .Equal, toItem: messageLabel1, attribute: .CenterX, multiplier: 1.0, constant: -30))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .Top, relatedBy: .Equal, toItem: messageLabel1, attribute: .Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 36))
        
        //登陆按钮
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .Left, relatedBy: .Equal, toItem: messageLabel1, attribute: .CenterX, multiplier: 1.0, constant: 30))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .Top, relatedBy: .Equal, toItem: messageLabel1, attribute: .Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 36))
    
    }


}