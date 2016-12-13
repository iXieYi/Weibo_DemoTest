//
//  VisitorView.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/12.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit

///访客视图

//代理协议
protocol VisitorViewDelegate:NSObjectProtocol{
    
/// 注册
    func visitorViewDidRegister()
/// 登录
    func visitorViewDidLogin()
}
/// 访客视图处理 - 用户未登录界面显示
class VisitorView: UIView {
    //定义代理，weak一旦被释放，会变成nil weak 因此不能使用let修饰
    weak var delegate:VisitorViewDelegate?
    
    @objc private func clickLogin(){
     
        delegate?.visitorViewDidLogin()
    
    }
    @objc private func clickRegister(){
    
       delegate?.visitorViewDidRegister()
    
    }
    //MARK: -设置视图信息
    /// 设置视图信息
    ///
    /// - parameter imageName: 图片名称，首页设置为nil
    /// - parameter title:     消息文字
    
    func setupInfo(imageName:String?,title:String){
    messageLabel1.text = title
        guard let imgName = imageName else{
            startAnim()
            return
        }
    iconView.image = UIImage(named:imageName!)
        //隐藏小房子
        homeIconView.hidden = true
       //将遮罩图像移动到底层
      sendSubviewToBack(maskIconView)
    }
    private func startAnim(){
    
    let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2*M_PI
        anim.repeatCount = MAXFLOAT //设置其不停旋转
        anim.duration = 20 //20秒动画时长
        //可以用在不断重复的动画上，当动画绑定的图层视图被销毁时，动画会自动被销毁
        anim.removedOnCompletion = false //表示完成之后不删除动画，解决当用户切换视图又返回时动画会停止的问题
        //添加到图层上
        iconView.layer.addAnimation(anim, forKey: nil)
    }
    
    //MARK:- 构造函数
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
//        setupUI()
    }
   //MARK: - 懒加载控件
   //图标，使用image:构造函数创建的imageView默认就是image的大小
    //小滚动
    private lazy var iconView:UIImageView = UIImageView(imageName: "visitordiscover_feed_image_smallicon")
    //遮罩
    private lazy var maskIconView:UIImageView = UIImageView(imageName: "visitordiscover_feed_mask_smallicon")
    //小房子
    private lazy var homeIconView:UIImageView = UIImageView(imageName:"visitordiscover_feed_image_house")
    
    //消息文字(在便利构造函数中实现)
    private lazy var messageLabel1:UILabel = UILabel(title: "")
    
    //登陆按钮
    private lazy var loginButton:UIButton = UIButton(title: "登录", color:UIColor.orangeColor() , imageName: "common_button_white_disable")
    
    //注册按钮
    private lazy var registerButton:UIButton = UIButton(title: "注册", color:UIColor.orangeColor() , imageName: "common_button_white_disable")
    
    
    
}
//类似于OC的分类，分类中不能定义 存储性的数据，swift也是如此的
//私有属性放在代码下端，便于空间的添加，避免跨度太大
extension VisitorView{
/// 设置界面
    private func setupUI(){
    //1.添加界面，按图层顺序添加
     addSubview(iconView)
     addSubview(maskIconView)
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
        /// @param .CenterX 需要图标设置的限制参数(约束属性)
        /// @param .Equal   是否等于（约束关系）
        /// @param self     该视图的参照物（参照视图）
        /// @param .CenterX 参照物对应类别的限制参数（参照属性）
        /// @param 1.0      公式中的放大倍数
        /// @param 0        约束数值
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

        //4.注册按钮
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .Right, relatedBy: .Equal, toItem: messageLabel1, attribute: .CenterX, multiplier: 1.0, constant: -30))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .Top, relatedBy: .Equal, toItem: messageLabel1, attribute: .Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 36))
        
        //5.登陆按钮
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .Left, relatedBy: .Equal, toItem: messageLabel1, attribute: .CenterX, multiplier: 1.0, constant: 30))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .Top, relatedBy: .Equal, toItem: messageLabel1, attribute: .Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 36))
        //6.遮罩
        /*
        
        VFL:可视化格式语言
        H  : 水平方向
        V  : 垂直方向
        |  :边界(与方向连用，以确定是哪个方向上的边界)
        [] :包装控件
        views :是一个字典，[名字：控件名] -VFL 字符串中表示控件字符串(名称是为了知道去设置哪个控件的约束)
        metrics:是一个字典，[名字：NSNumber] -VFL 字符串中表示某一个数值
        */
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[mask]-0-|", options:[], metrics:nil, views: ["mask":maskIconView]))
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[mask]-(btnHeight)-[regbtn]", options:[], metrics:["btnHeight":-36], views: ["mask":maskIconView,"regbtn":registerButton]))
        //设置背景颜色,设置灰度图，目前UI元素中大多使用灰度图和纯色图（安全色）
        backgroundColor = UIColor(white: 237.0/255.0, alpha: 1.0)
    //添加监听方法
        registerButton.addTarget(self, action: "clickRegister", forControlEvents: .TouchUpInside)
        loginButton.addTarget(self, action: "clickLogin", forControlEvents: .TouchUpInside)
        
        
        
    }


}