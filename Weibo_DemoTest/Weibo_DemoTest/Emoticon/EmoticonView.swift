//
//  EmoticonView.swift
//  表情键盘
//
//  Created by 谢毅 on 16/12/30.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit
private let EmoticonViewCellId = "EmoticonViewCellId"
/// MARK: - 表情键盘视图
class EmoticonView: UIView {
    
    //选中表回调
    private var selectedEmotionCallBack:(emoticon:Emoticon)->()
    //MARK: - 监听方法
    @objc private func clickItems(items:UIBarButtonItem){
    
    
    print("tag \(items.tag)")
    let indexPath = NSIndexPath(forItem: 0, inSection: items.tag)
    //滚动collectionView
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: true)
        
    }
    init(selectionEmoticon:(emoticon:Emoticon)->()) {
        //记录闭包属性
        selectedEmotionCallBack = selectionEmoticon
        var rect = UIScreen.mainScreen().bounds
        rect.size.height = 226
        //调用父类的构造函数
        super.init(frame:rect)
        backgroundColor = UIColor.whiteColor()
        setupUI()
        //滚动到第一页
        let index = NSIndexPath(forItem: 0, inSection: 1)
        //主线程有任务时就不调度该工作，当任务循环快要结束时，调用该方法
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.collectionView.scrollToItemAtIndexPath(index, atScrollPosition: .Left, animated: false)
            
        }

    }
   

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 懒加载控件
    private lazy var collectionView:UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: EmoticonLayout())
    
    
    //MARK: - 工具条
    private lazy var toolbar:UIToolbar = UIToolbar()
    
    //取表情包数组
    private lazy var packages = EmoticonManager.shareManager.package
    
    //MARK: - 表情布局(类中类，只允许被包含类的使用)
    private class EmoticonLayout: UICollectionViewFlowLayout{
        //collectionView 第一次布局的时候自动的被调用
        //collectionView 尺寸已经被设置好216 toolbar 36
        //如果在iphone + 屏幕宽度414,如果toolbar 设置44,只能显示两行
        
        private override func prepareLayout() {
            //重要写下面这个！！！！
            super.prepareLayout()
            
            let col:CGFloat = 7
            let row:CGFloat = 3
           
            let w = collectionView!.bounds.width / col
            //如果在iphone4的屏幕，只能显示两行
            let margin  = (collectionView!.bounds.height - row * w) * 0.499
            itemSize = CGSize(width: w, height: w)
            minimumInteritemSpacing = 0
            minimumLineSpacing = 0
            sectionInset = UIEdgeInsets(top: margin, left: 0, bottom: margin, right: 0)
           //设置水平滚动时索引排序是垂直排序的
            scrollDirection = .Horizontal
            collectionView?.pagingEnabled = true
            collectionView?.bounces = false
            collectionView?.showsHorizontalScrollIndicator = false
        }
        
    
    
    }
    
}
//MARK: - 设置界面
//用private 修饰的 extension,内部所有函数都是私有的
private extension EmoticonView{
    /// 设置界面
     func setupUI(){
    //1.添加控件
       addSubview(toolbar)
       addSubview(collectionView)
        
        
    //2.自动布局
        toolbar.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.snp_bottom)
            make.left.equalTo(self.snp_left)
            make.right.equalTo(self.snp_right)
            
            make.height.equalTo(44)
            
        }
    
        collectionView.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(self.snp_top)
            make.bottom.equalTo(toolbar.snp_top)
            make.left.equalTo(self.snp_left)
            make.right.equalTo(self.snp_right)

        }
    //3.准备控件
        prepareToolbar()
        prepareCollectionView()
    }
    /// 准备工具栏
    func prepareToolbar(){
   //1.设置按钮内容
        var items = [UIBarButtonItem]()
        toolbar.tintColor = UIColor.darkGrayColor()
        //toolBar 通常是一组功能相近的操作，只是操作的类型不同，通常利用tag 来区分
        var index = 0
        for p in packages{
            
        items.append(UIBarButtonItem(title: p.group_name_cn, style: .Plain, target: self, action: "clickItems:"))
            items.last?.tag = index++
        //添加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil))
            
            
        }
        items.removeLast()
    //2.设置items
        toolbar.items = items
    }
    /// 准备CollectionView
    func prepareCollectionView(){
        //表情键盘背景颜色
        collectionView.backgroundColor = UIColor.whiteColor()
    
    //注册
    collectionView.registerClass(EmoticonViewCell.self, forCellWithReuseIdentifier: EmoticonViewCellId)
    //设置数据源
        collectionView.dataSource = self
    //设置代理
        collectionView.delegate = self
        
    
    }

}
//数据源方法
extension EmoticonView:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        print(indexPath)
        let em = packages[indexPath.section].emoticons[indexPath.item]
        //执行回调代码
        selectedEmotionCallBack(emoticon: em)
    }

    //返回分组数量 - 表情包数量
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return packages.count
        
    }
    //返回每个表情包中表情的数量
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return packages[section].emoticons.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(EmoticonViewCellId, forIndexPath: indexPath) as! EmoticonViewCell
//        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.blueColor() :UIColor.greenColor()
//        cell.emoticonButton.setTitle("\(indexPath.item)", forState: .Normal)
        cell.emoticon = packages[indexPath.section].emoticons[indexPath.item]
        return cell
        
    }
    //MARK: - 表情视图 cell
    private class EmoticonViewCell: UICollectionViewCell{
        //表情模型
        var emoticon:Emoticon?{
            didSet{
            
            emoticonButton.setImage(UIImage(contentsOfFile: emoticon!.imagePath), forState: .Normal)
            //设置emoji 
            //cell存在复用，如果下面代码多了if emoticon?.emoji != nil{},可能会导致，当emoji显示了之后
            //再次加载图片表情时，因为cell的复用导致的，正常图片表情出现emoji
                
             //设置删除按钮
                if emoticon!.isRemoved{
                    
                    emoticonButton.setImage(UIImage(named: "compose_emotion_delete"), forState: .Normal)
                    
                    
                }
            emoticonButton.setTitle(emoticon?.emoji, forState: .Normal)
            
            }
        
        
        }
        
        //MARK: - 构造函数
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            contentView.addSubview(emoticonButton)
            emoticonButton.backgroundColor = UIColor.whiteColor()
            emoticonButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            emoticonButton.frame = CGRectInset(bounds, 4, 4)//内缩4个像素点
            //字体的大小和高度相近(code字符串表情的大小调节)
            emoticonButton.titleLabel?.font = UIFont.systemFontOfSize(32)
            //取消按钮交互
            emoticonButton.userInteractionEnabled = false
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        //MARK: - 懒加载控件 - 
        private lazy var emoticonButton:UIButton = UIButton()
    
    
    }

}





