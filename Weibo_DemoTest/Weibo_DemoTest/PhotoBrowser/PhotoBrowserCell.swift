//
//  PhotoBrowserCell.swift
//  Weibo10
//
//  Created by male on 15/10/26.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit
import SDWebImage

/// 照片查看 Cell
class PhotoBrowserCell: UICollectionViewCell {
    
    var imageURL: NSURL? {
        didSet {
            
            guard let url = imageURL else {
                return
            }
            
            // 0. 恢复 scrollView
            resetScrollView()
            
            // 1. url 缩略图的地址
            // 1> 从磁盘加载缩略图的图像
            imageView.image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(url.absoluteString)
            // 2> 设置大小
            imageView.sizeToFit()
            // 3> 设置中心点
            imageView.center = scrollView.center
            
            // 2. 异步加载大图 - sd_webImage 有一个功能，一但设置了 url，准备异步加载
            // 清除之前的图片/如果之前的图片也是异步下载，但是没有完成，取消之前的异步操作！
            imageView.sd_setImageWithURL(bmiddleURL(url)) { (image, _, _, _) in
                
                // 设置图像视图位置
                self.setPositon(image)
            }
        }
    }
    
    /// 重设 scrollView 内容属性
    private func resetScrollView() {
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
        
        // 2. 设置位置
        var rect = bounds
        rect.size.width -= 20
        scrollView.frame = rect
        
        // 3. 设置 scrollView 缩放
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
    }
    
    // MARK: - 懒加载控件
    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var imageView: UIImageView = UIImageView()
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
