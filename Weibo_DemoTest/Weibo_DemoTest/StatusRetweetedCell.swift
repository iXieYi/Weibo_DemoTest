//
//  StatusRetweetedCell.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/26.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit
//转发微博的cell
/*
- check list //改动列表
cell中需要修改的地方
controller :注册可重用cell
数据源中获取的cell的类型
行高

*/

class StatusRetweetedCell: StatusCell {
    
    //微博视图模型，子类继承自父类的属性，也需要使用override
    //不需要 super
    //先执行父类的 didset,再执行子类的didset
    
 override var viewModel:StatusViewModel?{
        didSet{
        //转发微博的文字
        retweetedLabel.text = viewModel?.retwwwtedText
        pictureView.snp_updateConstraints { (make) -> Void in
            //根据配图数量，决定配图视图的顶部间距
            let offset  = viewModel?.thumbnailUrls?.count > 0 ?StatusCellMargin :0
            make.top.equalTo(retweetedLabel.snp_bottom).offset(offset)
            }
        }
    
    }
    
    //MARK:懒加载控件
    //背景按钮
    private lazy var backButton: UIButton = {
    
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
    return button
    }()
    
    
   //转发文字
    private lazy var retweetedLabel:UILabel = UILabel(title: "转发微博",
        fontSize: 14,
        color: UIColor.darkGrayColor(),
        screenInset: StatusCellMargin)
   
}
// MARK: - 设置界面
extension StatusRetweetedCell{
    override func setupUI() {
        super.setupUI()
        //1、添加控件
        contentView.insertSubview(backButton, belowSubview: pictureView)
        contentView.insertSubview(retweetedLabel, aboveSubview: backButton)
        //2、自动布局
        //背景图片按钮
        backButton.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(contentLabel.snp_bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            make.bottom.equalTo(bottonView.snp_top)
        }
        //转发标签
        retweetedLabel.snp_makeConstraints { (make) -> Void in
         make.top.equalTo(backButton.snp_top).offset(StatusCellMargin)
         make.left.equalTo(backButton.snp_left).offset(StatusCellMargin)
            
        //配图
        pictureView.snp_makeConstraints { (make) -> Void in
                
                make.top.equalTo(retweetedLabel.snp_bottom).offset(StatusCellMargin)
                make.left.equalTo(retweetedLabel.snp_left)
                make.width.equalTo(300)
                make.height.equalTo(90)
            }
            
        }
        
    }
  








}