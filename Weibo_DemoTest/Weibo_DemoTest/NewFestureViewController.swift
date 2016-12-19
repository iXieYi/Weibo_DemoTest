//
//  NewFestureViewController.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/20.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: WBNewFestureViewCellId)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    //每个分组中格子数量
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return WBNewFestureImageCount
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(WBNewFestureViewCellId, forIndexPath: indexPath)
    
        // Configure the cell
        cell.backgroundColor =  indexPath.item%2 == 0 ? UIColor.redColor():UIColor.blueColor()
        return cell
    }

    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
