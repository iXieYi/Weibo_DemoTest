//
//  ComposeControllerViewController.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 17/1/4.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import UIKit
import SVProgressHUD
//MARK: - 撰写微博控制器
class ComposeControllerViewController: UIViewController {
    
    
    //表情键盘视图
    private lazy var emoticonView: EmoticonView = EmoticonView {[weak self] (emoticon) -> () in
        self?.textView.insertEmotion(emoticon)//解除循环管引用
    }


    //视图生命周期函数
    override func loadView() {
        
        view = UIView()
        setupUI()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //激活键盘
        textView.becomeFirstResponder()
    }
   

    
    //MARK: - 监听方法
    @objc private func close(){//关闭
    //关闭键盘
    textView.resignFirstResponder()
    dismissViewControllerAnimated(true, completion: nil)
        
    }
    @objc private func SendeStatus(){//发布微博
        
        print("发布微博")
        //1.获得文本内容
        let text = textView.emoticonText
        //2.发布微博
        NetworkTools.sharedTools.sendStatus(text) { (result, error) -> () in
            
            if error != nil {
               print("发布微博出错了")
                SVProgressHUD.showInfoWithStatus("您的网络不给力！")
               return
            }
            
            print(result)
            //关闭控制器
            self.close()
        }
    }
    //选择表情
    @objc private func selectEmoticon(){
    //如果使用的是系统键盘 nil
    print("选择表情\(textView.inputView)")
    //1.退出键盘
    textView.resignFirstResponder()
    //2.设置键盘
    textView.inputView = textView.inputView == nil ? emoticonView:nil
    //3.重新激活键盘
    textView.becomeFirstResponder()
    
    
    
    }
     //MARK: - 键盘处理
    @objc private func KeyboardChanged(n:NSNotification){
    
       print(n)
    //1.获取目标rect - 字典中的结构体是NSValue
       let rect = (n.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        //获取目标的动画时长
       let duration = (n.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        //动画曲线数值
      let curve = (n.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue
      
        
        let offset = -UIScreen.mainScreen().bounds.height + rect.origin.y
    //2.更新约束
        toolbar.snp_updateConstraints { (make) -> Void in
            
            make.bottom.equalTo(view.snp_bottom).offset(offset)
        }
        
    //3.动画 - UIView 块动画 本质上是对CAAnimation的包装
        UIView.animateWithDuration(duration) { () -> Void in
            //设置动画曲线
            //曲线值等于7的效果-> 如果之前的的动画没有完成，又启动了其他的动画，
            //会使得动画的图层直接运动到后续目标位置,一旦设置了7 会使得动画时长无效了，统一时长变为0.5s
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve)!)
            self.view.layoutIfNeeded()
            
        }
        //调试动画时长 - keypath 将动画添加到图层
        let anim = toolbar.layer.animationForKey("position")
        print("动画时长\(anim?.duration)")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加键盘通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "KeyboardChanged:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    deinit{
       //注销通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - 懒加载控件
    private lazy var toolbar:UIToolbar = UIToolbar()
    /// 文本视图
    private lazy var textView:UITextView = {
      let tv = UITextView()
      tv.font = UIFont.systemFontOfSize(18)
      tv.textColor = UIColor.darkGrayColor()
      tv.alwaysBounceVertical = true //允许垂直弹簧,垂直滚动
      tv.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag//拖拽关闭键盘
    return tv
    }()
   //占位标签
    private lazy var placeHoderLabel:UILabel = UILabel(title: "分享新鲜事...", fontSize: 18, color: UIColor.lightGrayColor())
    

}
//MARK: - UITextViewDelegate
extension ComposeControllerViewController:UITextViewDelegate{

    func textViewDidChange(textView: UITextView) {
        
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
        placeHoderLabel.hidden = textView.hasText()
    }
    


}



//设置界面: - 设置界面
private extension ComposeControllerViewController{
    func setupUI(){
    //1.设置背景颜色
    view.backgroundColor = UIColor.whiteColor()
    //2.设置控件
    prepareNavigationBar()
        
    //3.设置文本界面
    prepareTextView()
        
    //4.工具条
    prepareToolbar()
    //输入助理视图 - 当键盘退出时toolBar会消失！
    
    
    }
    
    
    //设置导航栏
    private func prepareNavigationBar(){
    //1.左右按钮
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: "close")
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .Plain, target: self, action: "SendeStatus")
    //禁用发布按钮(留后修改)
//        navigationItem.rightBarButtonItem?.enabled = false
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
    //准备文本框
    private func prepareTextView(){
    //1.添加控件
        view.addSubview(textView)
        textView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view.snp_top)
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
            make.bottom.equalTo(view.snp_bottom)
            
        }
        //textView没有占位文本
        //添加占位标签
        textView.addSubview(placeHoderLabel)
        placeHoderLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(textView.snp_top).offset(8)
            make.left.equalTo(textView.snp_left).offset(5)
            
        }
        
    }
    
    //准备工具条
    private func prepareToolbar(){
        //    1.添加控件
        view.addSubview(toolbar)
        toolbar.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        //2.设置自动布局
        toolbar.snp_makeConstraints { (make) -> Void in
            
            make.bottom.equalTo(view.snp_bottom)
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
            make.height.equalTo(44)
        }
        //3.添加按钮
        let itemSettings = [["imageName": "compose_toolbar_picture"],
            ["imageName": "compose_mentionbutton_background"],
            ["imageName": "compose_trendbutton_background"],
            ["imageName": "compose_emoticonbutton_background","actionName":"selectEmoticon"],
            ["imageName": "compose_addbutton_background"]]
        
        
        var items = [UIBarButtonItem]()
        
        
        
        for dict in itemSettings {
            
            let item = UIBarButtonItem(imageName: dict["imageName"]!, target: self, actionName: dict["actionName"])
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil))
            
        }
        items.removeLast()
        //一旦赋值做了一次拷贝
        toolbar.items = items
    }




}


