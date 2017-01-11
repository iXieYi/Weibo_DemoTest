//
//  PhotoBrowserCell.swift
//  Weibo10
//
//  Created by male on 15/10/26.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD


protocol PhotoBrowserCellDelegate: NSObjectProtocol{
    func photoBrowserCellDidTapImage()
}



/// 照片查看 Cell
class PhotoBrowserCell: UICollectionViewCell {
    
    weak var photoDelegate: PhotoBrowserCellDelegate?
    //MARK: - 监听方法
    func tagImage(){
    print("关闭")
    photoDelegate?.photoBrowserCellDidTapImage()
    
    }
    
    //手势识别 是对touch的一个封装 UIscrollview 支持捏合手势，一般做过手势监听的控件，都会屏蔽掉touch事件
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("lalala")
    }
    
    
    //MARK: - 图像地址
    var imageURL: NSURL? {
        didSet {
            
            guard let url = imageURL else {
                return
            }
            
            // 0. 恢复 scrollView
            resetScrollView()
            
            // 1. url 缩略图的地址
            // 1> 从磁盘加载缩略图的图像
            let placeholderImage  = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(url.absoluteString)
            setPlaceHoder(placeholderImage)
            placeHolder.setNeedsDisplay() //能主动调用draw
            // 2. 异步加载大图 - sd_webImage 有一个功能，一但设置了 url，准备异步加载
            // 清除之前的图片/如果之前的图片也是异步下载，但是没有完成，取消之前的异步操作！
            //几乎所有的第三方框架，进度回调都是异步的
            //进度回调的频率非常高，如果在主线程上，会造成线程kadun
            //使用进度回调，要求界面上的经度变化的UI不多，而且不会频繁的更新
            imageView.sd_setImageWithPreviousCachedImageWithURL(bmiddleURL(url), placeholderImage: nil, options: [SDWebImageOptions.RetryFailed,SDWebImageOptions.RefreshCached], progress: { (current, total) -> Void in
                
//                print("\(current)  \(total)")
                //更新进度
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.placeHolder.progress = CGFloat(current) / CGFloat(total)
                })
                
                }) { (image, _, _,_) -> Void in
                //判断图像是否下载成功
                    if image == nil{
                    SVProgressHUD.showInfoWithStatus("网络不给力")
                    return
                    }
                //隐藏占位图像
                 self.placeHolder.hidden  = true
                // 设置图像视图位置
                self.setPositon(image)
            }

        }
        
        
    
    }
    /// 设置占位图像的内容
    ///
    /// - parameter image: 本地缓存的缩略图，如果下载失败，image就为空
    private func setPlaceHoder(image:UIImage?){
        placeHolder.hidden = false            //初始化时显示
        placeHolder.image = image              // 1> 设置缩略图的图像
        placeHolder.sizeToFit()                  // 2> 设置大小
        placeHolder.center = scrollView.center   // 3> 设置中心点
    
    }
    
    private func resetScrollView() {
        /// 重设 imageView 内容属性 -scrollview在缩放的时候，
        //是调整代理方法返回的视图，tranfrom来实现的
        imageView.transform = CGAffineTransformIdentity
        /// 重设 scrollView 内容属性
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.contentOffset = CGPointZero
        scrollView.contentSize = CGSizeZero
    }
    
    /// 设置 imageView 的位置
    ///
    /// - parameter image: image
    /// - 长/短图
    private func setPositon(image: UIImage) {
        // 自动设置大小
        let size = self.displaySize(image)
        
        // 判断图片高度
        if size.height < scrollView.bounds.height {
            // 上下局中显示 - 调整 frame 的 x/y，一旦缩放，影响滚动范围
            imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            // 内容边距 － 会调整控件位置，但是不会影响控件的滚动
            let y = (scrollView.bounds.height - size.height) * 0.5
            scrollView.contentInset = UIEdgeInsets(top: y, left: 0, bottom: 0, right: 0)
        } else {
            imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            scrollView.contentSize = size
        }
    }
    
    /// 根据 scrollView 的宽度计算等比例缩放之后的图片尺寸
    ///
    /// - parameter image: image
    ///
    /// - returns: 缩放之后的 size
    private func displaySize(image: UIImage) -> CGSize {
        
        let w = scrollView.bounds.width
        let h = image.size.height * w / image.size.width
        
        return CGSize(width: w, height: h)
    }
    
    /// 返回中等尺寸图片 URL
    ///
    /// - parameter url: 缩略图 url
    ///
    /// - returns: 中等尺寸 URL
    private func bmiddleURL(url: NSURL) -> NSURL {
        print(url)
        
        // 1. 转换成 string
        var urlString = url.absoluteString
        
        // 2. 替换单词
        urlString = urlString.stringByReplacingOccurrencesOfString("/thumbnail/", withString: "/bmiddle/")
        
        return NSURL(string: urlString)!
    }
    
    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 1. 添加控件
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(placeHolder)
        
        // 2. 设置位置
        var rect = bounds
        rect.size.width -= 20
        scrollView.frame = rect
        
        // 3. 设置 scrollView 缩放
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
        
        //4.添加手势识别
        let tap = UITapGestureRecognizer(target: self, action: "tagImage")
        //UIImageView 默认是不支持用户交互的
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
       
    }
    
    // MARK: - 懒加载控件
    lazy var scrollView: UIScrollView = UIScrollView()
    lazy var imageView: UIImageView = UIImageView()
    private lazy var placeHolder:ProgressImageView = ProgressImageView()//占位图像
    
}

// MARK: - UIScrollViewDelegate
extension PhotoBrowserCell: UIScrollViewDelegate {
    
    /// 返回被缩放的视图
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    /// 缩放完成后执行一次
    ///
    /// - parameter scrollView: scrollView
    /// - parameter view:       view 被缩放的视图
    /// - parameter scale:      被缩放的比例
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        print("缩放完成 \(view) \(view?.bounds)")
        
        var offsetY = (scrollView.bounds.height - view!.frame.height) * 0.5
        offsetY = offsetY < 0 ? 0 : offsetY
        
        var offsetX = (scrollView.bounds.width - view!.frame.width) * 0.5
        offsetX = offsetX < 0 ? 0 : offsetX
        
        // 设置间距
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
    
    /// 只要缩放就会被调用
    /**
        a d => 缩放比例
        a b c d => 共同决定旋转
        tx ty => 设置位移
    
        定义控件位置 frame = center + bounds * transform
    */
    func scrollViewDidZoom(scrollView: UIScrollView) {
        print(imageView.transform)
    }
    
}
