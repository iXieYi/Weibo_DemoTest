//
//  StatusPictureView.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/25.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit
import SDWebImage

private let StatusPictureViewItemMargin:CGFloat = 8
/// 可重用标示符号
private let StatusPictureViewCellId =  "StatusPictureViewCellId"
//配图视图
class StatusPictureView: UICollectionView {
    //微博的视图模型
    var viewModel:StatusViewModel?{
        didSet{
            
        //自动计算大小（该方法不能被重写，因此会调用sizeThatFits 这个方法）
        sizeToFit()
        //刷新数据 -> 由于tableViewCell存在复用，导致collection图片显示错误,
        //当新的数据到来时，导致数据源方法没有被更新，因此需要人为的更新数据
        reloadData()   //重要！！！！！！！！
        }
    
    }
    //这个函数返回了之后会修改当前视图的大小
    override func sizeThatFits(size: CGSize) -> CGSize {
        
        return calaViewSize()
    }
    
    /// 构造函数
    init(){
    //重要啊！！！！！->UICollectionViewFlowLayout
    let layout = UICollectionViewFlowLayout()
    //知识点提示：collectionView中items 默认时候50 *50的
    //设置间距
    layout.minimumInteritemSpacing = StatusPictureViewItemMargin//每个小格的间距
    layout.minimumLineSpacing = StatusPictureViewItemMargin     // 每行的间距
        
    super.init(frame: CGRectZero, collectionViewLayout: layout)//构造函数之后，该控件才创建完成，方可访问
    
        
    if viewModel?.status.retweeted_status != nil{
        backgroundColor = UIColor(white: 0.95, alpha: 1.0)
    }else{
         backgroundColor = UIColor(white: 1, alpha: 1.0)
        }
   
    //设置数据源
    //自己当自己的数据源（数据元的定义：任何能实现数据源方法的对象，方可称为数据源）
    //应用场景：自定义视图的小框架
    dataSource = self
    
    //设置代理
    delegate = self
    
    //注册可重用Cell
    registerClass(StatusPictureViewCell.self, forCellWithReuseIdentifier: StatusPictureViewCellId)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
// MARK: - UICollectionViewDataSource数据源方法
extension StatusPictureView: UICollectionViewDataSource,UICollectionViewDelegate{
    /// 选中照片
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        print("点击照片:\(indexPath) \(viewModel?.thumbnailUrls)")
        //测试动画转场协议函数
//        PhotoBrowerPresentFromRect(indexPath)
//        PhotoBrowerPresentToRect(indexPath)
        
        
        //明确传递什么数据，传递用户当前URL数组，当前用户选中的索引
        //如何传递：通知1、名字（通知中心监听）
        //2、object：发送通知的同时传递对象（单值）、userinfo传递多值,使用的字典
        NSNotificationCenter.defaultCenter().postNotificationName(WBStatusSelectPhotoNotification,
            object: self,
            userInfo: [WBStatusSelectPhotoIndexPath:indexPath,WBStatusSelectPhotoUrlKey:viewModel!.thumbnailUrls!])
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel?.thumbnailUrls?.count ?? 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(StatusPictureViewCellId, forIndexPath: indexPath) as! StatusPictureViewCell
        
       cell.imageUrl = viewModel?.thumbnailUrls![indexPath.row]
        return cell
    }

    
}

//MARK: - 照片参看器的展现协议
extension StatusPictureView: PhotoBrowerPresentDelegate{
    /// 创建一个imageview 在参与动画
    func imageViewForPresent(indexpath: NSIndexPath) -> UIImageView {
        //1.内容填充模式
        let iv = UIImageView()
        iv.contentMode = .ScaleAspectFill
        iv.clipsToBounds = true
        
        //2.设置图像（缩略图缓存） 如果存在本地缓存就不会发起网络请求
        if let url = viewModel?.thumbnailUrls?[indexpath.item] {
            iv.sd_setImageWithURL(url)

        }
        return iv
    }
    /// 动画起始位置
    func PhotoBrowerPresentFromRect(indexpath: NSIndexPath) -> CGRect {
        //1、根据 indexpath 获得当前用户选中的cell
        let cell = self.cellForItemAtIndexPath(indexpath)
        //2、通过cell知道cell对应的在屏幕上放的准确位置
        //在不同屏幕间，坐标系的转换,self 是cell的父视图
       let rect =  self.convertRect((cell?.frame)!, toCoordinateSpace: UIApplication.sharedApplication().keyWindow!)
        //测试rect位置
//        let v = UIView(frame:rect)
//        v.backgroundColor = UIColor.redColor()
        
//        let v = imageViewForPresent(indexpath)
//        v.frame = rect
//        
//        UIApplication.sharedApplication().keyWindow?.addSubview(v)
//        print(rect)
        
        return rect
    }
    /// 目标位置
    func PhotoBrowerPresentToRect(indexpath: NSIndexPath) -> CGRect {
        //根据缩略图的大小等比例计算目标的位置
        guard let key = viewModel?.thumbnailUrls?[indexpath.item].absoluteString else{
        
        return CGRectZero
        }
        //从sdWebimage获取本地缓存图片
        guard let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key)else{
           return CGRectZero
        }
        //根据图像大小计算全屏大小
        let w = UIScreen.mainScreen().bounds.width
        let h = image.size.height * w / image.size.width
        
        //对高度进行额外处理
        let screenHeight = UIScreen.mainScreen().bounds.height
        var y:CGFloat = 0
        if h < screenHeight {//图片过短，垂直居中显示
            y = (screenHeight - h) * 0.5
        }
        
        
            
        let rect = CGRect(x: 0, y: y, width: w, height: h)
        
//        let v = imageViewForPresent(indexpath)
//        v.frame = rect
//        UIApplication.sharedApplication().keyWindow?.addSubview(v)
        
        return rect
    }
    
    
}


// MARK: - 计算视图大小
extension StatusPictureView{
    /// 计算视图大小函数
    private func calaViewSize()->CGSize{
        //1.准备
        //每行的照片数量
        let rowCount:CGFloat = 3.0
        
        let maxWidth = UIScreen.mainScreen().bounds.width - 2 * StatusCellMargin
        let itemWidth = (maxWidth - 2 * StatusPictureViewItemMargin) / rowCount
        
        //2.设置layout 的itemSize
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        //3.获取图片数量
        let count = viewModel?.thumbnailUrls?.count ?? 0
        
        //4.计算
        //1>没有图片
        if count == 0{
        
        return CGSizeZero
        }
        //2>一张图片
        if count == 1{
        var size = CGSize(width: 150, height: 120)
        //利用SDWebImage提取检测本地的缓存图像 key - url 完整字符型串
        //面试题：SDWebImage是如何缓存文件名的？ 对完整url‘MD5’
            if let key = viewModel?.thumbnailUrls?.first?.absoluteString{
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key)
//                print(image)
                
            size = image.size
            }
            //图片过窄
            size.width = size.width < 40 ? 40: size.width
            //过宽的图片
            if size.width > 300{
                let w:CGFloat = 300
                let h = size.height * w / size.width
                size = CGSize(width: w, height: h)
            
            }
            
            layout.itemSize = size
            //配图视图的大小
            return size
        }
        //3> 4张图片 2 * 2大小
        if count == 4{
        
        let w = 2 * itemWidth + StatusPictureViewItemMargin
            
            return CGSize(width: w, height: w)
        
        }
        //4>其他图片 - 按照9宫格来显示(2\3\5\6\7\8\9 这几种情况）
        //计算出行数
        
        let row = CGFloat((count - 1) / Int(rowCount) + 1 )//小公式
        let h = row * itemWidth + (row - 1) * StatusPictureViewItemMargin
        let w = rowCount * itemWidth + (rowCount - 1) * StatusPictureViewItemMargin
        
        return CGSize(width: w, height: h)
        
    }
    
}
/// MARK: - 配图Cell
private class StatusPictureViewCell:UICollectionViewCell{
    
    var imageUrl:NSURL? {
        didSet{
    
        iconView.sd_setImageWithURL(imageUrl,
            placeholderImage: nil,//调用oc框架时，可选和必选不严格
            options:[SDWebImageOptions.RetryFailed,//默认超时时长15S,一旦超时会计入黑名单
                SDWebImageOptions.RefreshCached])//如果URL 不变，图像变
        
        }
    }
    //重写构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI(){
    //1.添加控件
    contentView.addSubview(iconView)
    
    //2.设置布局 ->应为cell会变化，不同的cell大小可能不一样,因此需要使用自动布局
    iconView.snp_makeConstraints { (make) -> Void in
        make.edges.equalTo(contentView.snp_edges)
        
        }

    
    
    }
    
    //MARK: - 懒加载控件
    private lazy var iconView:UIImageView = {
    
    let iv = UIImageView()
    //设置填充模式
        iv.contentMode =  UIViewContentMode.ScaleAspectFill
        //设置裁切图片
        iv.clipsToBounds = true
         return iv
    
    }()



}




