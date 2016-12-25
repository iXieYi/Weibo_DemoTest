//
//  StatusPictureView.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/25.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit

private let StatusPictureViewItemMargin:CGFloat = 8

//配图视图
class StatusPictureView: UICollectionView {
    //微博的视图模型
    var viewModel:StatusViewModel?{
        didSet{
            
        //自动计算大小（该方法不能被重写，因此会调用sizeThatFits 这个方法）
        sizeToFit()
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
        
    super.init(frame: CGRectZero, collectionViewLayout: layout)
    backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        //TODO:- 临时指定大小
        if count == 1{
        let size = CGSize(width: 150, height: 120)
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

