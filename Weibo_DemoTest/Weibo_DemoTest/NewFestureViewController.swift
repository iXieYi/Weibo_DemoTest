//
//  NewFestureViewController.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/20.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit
import SnapKit


//可重用cellId
private let WBNewFestureViewCellId = "WBNewFestureViewCellId"
//新特性图片数量
private let WBNewFestureImageCount = 4
class NewFestureViewController: UICollectionViewController {
    //懒加载属性，必须要在控制器被实例化之后才会被创建，因此这里不可以调用懒加载属性
    
    //构造函数
    init(){
        //调用父类指定的构造函数,一定要使用这个 ：UICollectionViewFlowLayout
    let layout = UICollectionViewFlowLayout()
        
        
    layout.itemSize = UIScreen.mainScreen().bounds.size
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .Horizontal
    
    //这里是一个构造函数，以后控件才会被创建
    super.init(collectionViewLayout: layout)
    collectionView?.pagingEnabled = true
    collectionView?.bounces = false //弹框效果
    collectionView?.showsHorizontalScrollIndicator = false //关闭水平滚动器
        
    
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //7.0以后隐藏状态栏，控制器分别设置，默认是NO
    override func prefersStatusBarHidden() -> Bool {
        
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // 自定义cell时，在注册的时候也要替换掉响应的类属性
        self.collectionView!.registerClass(NewFeatureCell.self, forCellWithReuseIdentifier: WBNewFestureViewCellId)

        
    }

    // MARK: UICollectionViewDataSource

    //每个分组中格子数量
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return WBNewFestureImageCount
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(WBNewFestureViewCellId, forIndexPath: indexPath) as! NewFeatureCell

        
         cell.imageIndex = indexPath.item
//        Configure the cell
        cell.backgroundColor =  indexPath.item%2 == 0 ? UIColor.redColor():UIColor.blueColor()
        
        return cell
    }
    
//scrollview 停止滚动的方法
  override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //在最后一页调用动画方法
        //利用contentOffset 计算页数
      let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
       //判断是否是最后一页
    if page != WBNewFestureImageCount-1{
        return
      }
    
    //cell播放动画
  let cell = collectionView?.cellForItemAtIndexPath(NSIndexPath(forItem: page, inSection: 0)) as!NewFeatureCell
    //显示动画，在同有个文件中，私有属性没有限制
    cell.showButtonAnim()
    
    }
}


//MARK：-新特性 cell
private class NewFeatureCell: UICollectionViewCell{
    
    //图像属性
    private var imageIndex: Int = 0{
        didSet{ //属性变化时，设置图片显示
        iconView.image = UIImage(named: "new_feature_\(imageIndex+1)")
//            showButtonAnim()
            //显示隐藏必须在这里，因为每次切换个cell都会调用这个方法，
            //而不能在SetupUI中调用该方法，应为cell存在重用，
            //会使得往回切换cell时出现按钮动画
            startButton.hidden = true
        }
    }
    @objc private func clickstartButton(){
    
        print("开始体验")
    }
    //显示按钮动画
    private func showButtonAnim(){
    startButton.hidden = false
    startButton.transform = CGAffineTransformMakeScale(0, 0)
    startButton.userInteractionEnabled = false    //动画时禁止交互
    UIView.animateWithDuration(1.6,                       //动画时长
                              delay: 0,                   //延时时间
                              usingSpringWithDamping: 0.7,//弹力系数 0~1,越小越弹
                              initialSpringVelocity: 10,  //初始速度 模拟重力加速度
                              options: [],                //动画选项
                              animations: { () -> Void in
                                self.startButton.transform = CGAffineTransformIdentity//初始形变矩阵
                                
        }) { (_) -> Void in
            print("OK")
            self.startButton.userInteractionEnabled = true //控件开始被交互
        }
    }
    override init(frame:CGRect){
    super.init(frame: frame)
    //提问：frame 的大小,是layout 的itemSize指定的
    setupUI()
    
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
    //1.添加控件
        addSubview(iconView)
        addSubview(startButton)
    //2.指定自动布局
        iconView.frame = bounds
    
startButton.snp_makeConstraints { (make) -> Void in
        make.centerX.equalTo(self.snp_centerX)
    //  multipliedBy 乘积显示高度的百分比
        make.bottom.equalTo(self.snp_bottom).multipliedBy(0.7)
    
    //3.监听按键
    startButton.addTarget(self, action: "clickstartButton", forControlEvents: .TouchUpInside)
    
        }
    }
    
//懒加载控件
    //图像
    private lazy var iconView:UIImageView = UIImageView()
    //启动按钮
    private lazy var startButton:UIButton = UIButton(title: "开始体验", color: UIColor.whiteColor(), imageName: "new_feature_finish_button")

}

