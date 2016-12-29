//
//  WeiBoRefresh.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/28.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit
private let WeiBoRefreshoffset:CGFloat = -60
/// 自定义刷新控件 - 负责处理刷新逻辑
class WeiBoRefresh: UIRefreshControl {
    
    //MARK: - 重写系统方法
    override func endRefreshing() {
        super.endRefreshing()
        //停止动画
        refreshView.stopAnimation()
    }
    //主动触发开始刷新动画 - 不会触发监听方法
    override func beginRefreshing() {
      super.beginRefreshing()
        refreshView.startAnimation()
        
    }
    
    //保证代码和Xib开发都能使用到该UI搭建方法
    
    
    //MARK: -KVO监听方法
    /*
    
    1.始终待在屏幕上
    2.下拉时frame.y值一直在变小，上推时一直在不变大
    3.默认y是为0的
    */
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if frame.origin.y > 0{
          return
        }
        //判读是否正在刷新
        if refreshing{
        refreshView.startAnimation()
        return
        }
        
        
        if frame.origin.y < WeiBoRefreshoffset && !refreshView.roateFlag {
        print("反过来")
        refreshView.roateFlag = true
            
        }else if frame.origin.y >= WeiBoRefreshoffset && refreshView.roateFlag {
          print("转过去")
          refreshView.roateFlag = false
        }
//        print(frame)
    }
    //MARK: - 构造函数
    override init() {
        
        super.init()
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
        setupUI()
    }
    private func setupUI(){
    //设置TintColor
     tintColor = UIColor.clearColor()//隐藏菊花
     //添加控件
    addSubview(refreshView)
    //自动布局  - 从xib 指定的控件需要指定大小约束
        refreshView.snp_makeConstraints { (make) -> Void in
            
            make.centerX.equalTo(self.snp_centerX).offset(-refreshView.bounds.size.width/2)
            make.centerY.equalTo(self.snp_centerY).offset(-refreshView.bounds.size.height/2 - 5)
            make.size.equalTo(refreshView.bounds.size)
        }
    //使用KVO监听位置变化 - 主队列，当主线程有任务就不调度队列中的任务执行
    //当前运行循环中所有代码执行完毕之后，运行循环结束前，开始监听
    //方法触发，会在下一次运行循环开始时！
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
        self.addObserver(self, forKeyPath: "frame", options: [], context: nil)
        }
       
        
    }
    
    deinit{
        
    //注销监听方法
    self.removeObserver(self, forKeyPath: "frame")
    }
    //MARK: - 懒加载控件
    private lazy var refreshView = WBRefreshView.refreshView()
   

}
/// 刷新视图 - 负责处理-动画显示
class WBRefreshView:UIView {
    
    
    
    @IBOutlet weak var loadingIcon: UIImageView!
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var tipIconView: UIImageView!
    //旋转标记
    var roateFlag = false {
        didSet{
        rotateTipIcon()
        
        }
    
    }
    
    
    //类方法,从xib加载 视图方法
    class func refreshView()-> WBRefreshView{
    //推荐使用UINib的方式加载Xib,会比loadFrom bundle 好一些
    let nib = UINib(nibName: "WBRefreshView", bundle: nil)
        
     return nib.instantiateWithOwner(nil, options: nil)[0] as! WBRefreshView
    }
/// 旋转图标动画
    private func rotateTipIcon(){
    //旋转动画 - 特点顺时针优先 + 就近原则
    var angle = CGFloat(M_PI)
        angle += roateFlag ? -0.00000001 :0.0000001
    UIView.animateWithDuration(0.5) { () -> Void in
        
        self.tipIconView.transform = CGAffineTransformRotate(self.tipIconView.transform,CGFloat(angle))
        }
    }
    //开始播放加载动画
    private func startAnimation(){
        tipView.hidden = true
        //判断动画是否已经被添加
        let key = "transform.rotation"
        if (loadingIcon.layer.animationForKey(key) != nil){
          
          return
        }
        print("动画已经播放")
        let anim = CABasicAnimation(keyPath: key)
        anim.toValue = 2 * M_PI
        anim.repeatCount = MAXFLOAT //重复
        anim.duration = 0.5 //一圈需要的时间
        anim.removedOnCompletion = false
        loadingIcon.layer.addAnimation(anim, forKey: key)
        
    
    }
    //停止加载动画
    private func stopAnimation(){
       tipView.hidden = false
      loadingIcon.layer.removeAllAnimations()
    
    }
    
}