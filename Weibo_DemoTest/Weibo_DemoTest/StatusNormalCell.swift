//
//  StatusNormalCell.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/27.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit

//原创微博
class StatusNormalCell: StatusCell {
    
    
    
    //微博视图模型
   override var viewModel:StatusViewModel?{
        didSet{
        pictureView.snp_updateConstraints { (make) -> Void in
                //根据配图数量，决定配图视图的顶部间距
                let offset  = viewModel?.thumbnailUrls?.count > 0 ?StatusCellMargin :0
                make.top.equalTo(contentLabel.snp_bottom).offset(offset)
            }
        }
        
    }

    override func setupUI() {
    //若没有下面这句话，会提示没有办法安装约束，！！！
    //本质原因是没有创建控件，所导致的
       super.setupUI()
        
        
    //配图
        pictureView.snp_makeConstraints { (make) -> Void in

            make.top.equalTo(contentLabel.snp_bottom).offset(StatusCellMargin)
            make.left.equalTo(contentLabel.snp_left)
            make.width.equalTo(300)
            make.height.equalTo(90)
        }

    }
    
    
}
