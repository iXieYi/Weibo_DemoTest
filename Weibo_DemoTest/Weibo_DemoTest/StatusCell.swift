//
//  StatusCell.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/22.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit
/// 微博Cell中控件的间距数值
let StatusCellMargin:CGFloat = 12
//定义微博头像的宽度
let StatusCellIconWidth:CGFloat = 35

//微博cell
class StatusCell: UITableViewCell {
    
    //微博的视图模型
    var viewModel:StatusViewModel?{
        didSet{
        topView.viewModel = viewModel
        contentLabel.text = viewModel?.status.text
            
        //测试修改配图视图高度 -> cell视图存在复用，若动态的修改其约束高度会使得，cell自动计算过变得不准
        //设置配置视图 - 设置视图模型之后 - 配图视图有能力计算大小
            
        pictureView.viewModel = viewModel
            
        pictureView.snp_updateConstraints { (make) -> Void in
//           print("配图视图大小：\(pictureView.bounds)")
           make.height.equalTo(pictureView.bounds.height)
        //宽度约束- > 直接设置宽度数值，如果这时候其他地方再次设置，有参照的值会使得约束设置冲突
        //自动布局系统不知道，该依据那个设置视图大小
        make.width.equalTo(pictureView.bounds.width)
        //根据配图数量，决定配图视图的顶部间距
//            let offset  = viewModel?.thumbnailUrls?.count > 0 ?StatusCellMargin :0
//            make.top.equalTo(contentLabel.snp_bottom).offset(offset)
            }
        }
    
    }
    /// 根据指定的视图模型指定行高
    ///
    /// - parameter ViewModel: 视图模型
    ///
    /// - returns: 返回视图模型对应的行高
    func rowHeight(VM:StatusViewModel)->CGFloat{
    //1.记录视图模型 -> 会调用的上方didSet 设置内容和更新约束
        viewModel = VM
    //2.强制更新所有约束 - >所有控件都会被计算正确
        contentView.layoutIfNeeded()
    //3.返回底部视图的最大高度
        return CGRectGetMaxY(bottonView.frame)
    
    }
    //构造函数
    //style 参数可以设置系统的样式
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        setupUI()
        //设置cell选中时后的样式 （快捷键查看文件属性，方法列表 ctrl + 6 支持智能搜索和匹配）
        selectionStyle = .None
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK:- 懒加载控件
    //顶部视图
    private lazy var topView:StatusTop = StatusTop()
    //微博正文
     lazy var contentLabel: UILabel = UILabel(title: "微博正文", fontSize: 15, screenInset: StatusCellMargin)
    //配图视图
     lazy var pictureView:StatusPictureView = StatusPictureView()
    //底部视图
     lazy var bottonView:StatusBottom = StatusBottom()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK: - 设置界面使用
extension StatusCell{

     func setupUI(){
    //1.添加控件
    contentView.addSubview(topView)
    contentView.addSubview(contentLabel)
    contentView.addSubview(pictureView)
    contentView.addSubview(bottonView)
//    bottonView.backgroundColor = UIColor.redColor()
    
        
    //2.自动布局
    //顶部视图
    topView.snp_makeConstraints { (make) -> Void in
        
        make.top.equalTo(contentView.snp_top)
        make.left.equalTo(contentView.snp_left)
        make.right.equalTo(contentView.snp_right)
        //TODO: - 修改高度
        make.height.equalTo(2*StatusCellMargin + StatusCellIconWidth)
        }
    
    //正文内容标签
        contentLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(topView.snp_bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView.snp_left).offset(StatusCellMargin)
//            make.right.equalTo(contentView.snp_right).offset(StatusCellMargin)
            
        }
    //底部视图
        bottonView.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(pictureView.snp_bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            make.height.equalTo(44)
            //指定向下的约束
//            make.bottom.equalTo(contentView.snp_bottom)
        }
    }

}


