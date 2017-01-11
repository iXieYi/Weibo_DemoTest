//
//  PhotoBrowserViewController.swift
//  Weibo10
//
//  Created by male on 15/10/26.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit
import SVProgressHUD
/// 可重用 Cell 标示符号
private let PhotoBrowserViewCellId = "PhotoBrowserViewCellId"

/// 照片浏览器
class PhotoBrowserViewController: UIViewController {

    /// 照片 URL 数组
    private var urls: [NSURL]
    /// 当前选中的照片索引
    private var currentIndexPath: NSIndexPath
    
    // MARK: - 监听方法
    @objc private func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// 保存照片
    @objc private func save() {
        print("保存照片")
        //1.拿到图片
        //visibleCells是可见的cell的数组
        let cell = collectionView.visibleCells()[0] as!PhotoBrowserCell
        //imageView中很有可能因为网络原因没有图片 ->下载需要提示
        guard  let image = cell.imageView.image else{
        return
        }
        //保存图片
        UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
        
        
    }
  @objc private func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject?){
        let message = (error == nil) ? "保存成功" :"保存失败"
        SVProgressHUD.showInfoWithStatus(message)
    }
    // MARK: - 构造函数 属性都可以是必选，不用在后续考虑解包的问题
    init(urls: [NSURL], indexPath: NSIndexPath) {
        self.urls = urls
        self.currentIndexPath = indexPath
        
        // 调用父类方法
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //loadView是和xib和sb是等价的，主要的职责是创建视图层次结构，loadView函数执行完毕，view上的元素要全部创建完成
    //如果view  == nil 系统会在view的getter方法时，调用loadview，创建view
    
    override func loadView() {
        // 1. 设置根视图
        var rect = UIScreen.mainScreen().bounds
        rect.size.width += 20
        
        view = UIView(frame: rect)
        
        // 2. 设置界面
        setupUI()
        
    }
    //视图加载完成，才被调用，是在loadview之后才被调用
    //主要做数据加载，或者其他处理，市场上有些代码就将建立子控件的代码都在viewdidload中
    override func viewDidLoad() {
        super.viewDidLoad()
     //让collectionView 滚动到指定位置
    collectionView.scrollToItemAtIndexPath(currentIndexPath, atScrollPosition:.CenteredHorizontally, animated: false)
    }

    // MARK: - 懒加载控件
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: PhotoBrowserViewLayout())
    /// 关闭按钮
    private lazy var closeButton: UIButton = UIButton(title: "关闭", fontSize: 14, color: UIColor.whiteColor(), imageName: nil, backColor: UIColor.darkGrayColor())
    /// 保存按钮
    private lazy var saveButton: UIButton = UIButton(title: "保存", fontSize: 14, color: UIColor.whiteColor(), imageName: nil, backColor: UIColor.darkGrayColor())
    
    // MARK: - 自定义流水布局
    private class PhotoBrowserViewLayout: UICollectionViewFlowLayout {
        
        private override func prepareLayout() {
            super.prepareLayout()
            
            itemSize = collectionView!.bounds.size
            minimumInteritemSpacing = 0
            minimumLineSpacing = 0
            scrollDirection = .Horizontal
            
            collectionView?.pagingEnabled = true
            collectionView?.bounces = false
            
            collectionView?.showsHorizontalScrollIndicator = false
        }
    }
}

// MARK: - 设置 UI
private extension PhotoBrowserViewController {
    
    private func setupUI() {
        // 1. 添加控件
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)

        // 2. 设置布局
        collectionView.frame = view.bounds
        
        closeButton.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(view.snp_bottom).offset(-8)
            make.left.equalTo(view.snp_left).offset(8)
            make.height.equalTo(36)
            make.width.equalTo(100)
        }
        saveButton.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(view.snp_bottom).offset(-8)
            make.right.equalTo(view.snp_right).offset(-28)
            make.height.equalTo(36)
            make.width.equalTo(100)
        }
        
        // 3. 监听方法
        closeButton.addTarget(self, action: "close", forControlEvents: .TouchUpInside)
        saveButton.addTarget(self, action: "save", forControlEvents: .TouchUpInside)
        
        // 4. 准备控件
        prepareCollectionView()
    }
    
    /// 准备 collectionView
    private func prepareCollectionView() {
        // 1. 注册可重用 cell
        collectionView.registerClass(PhotoBrowserCell.self, forCellWithReuseIdentifier: PhotoBrowserViewCellId)
        
        // 2. 设置数据源
        collectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDataSource
extension PhotoBrowserViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowserViewCellId, forIndexPath: indexPath) as! PhotoBrowserCell
        
        cell.backgroundColor = UIColor.blackColor()
        cell.imageURL = urls[indexPath.item]
        //设置代理
        cell.photoDelegate = self
        return cell
    }
}
//MARK: - PhotoBrowserCellDelegate
extension PhotoBrowserViewController: PhotoBrowserCellDelegate{

    func photoBrowserCellDidTapImage() {
        close()
    }




}
