//
//  StatusCell.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/22.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit
//微博cell
class StatusCell: UITableViewCell {
    var viewModel:StatusViewModel?{
        didSet{
        
        
        }
    
    }
    //构造函数
    //style 参数可以设置系统的样式
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        setupUI()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK:- 懒加载控件
    //顶部视图
    private lazy var topView:StatusTop = StatusTop()
    //微博正文
    private lazy var contentLabel: UILabel = UILabel(title: "微博正文", fontSize: 15)
    //底部视图
    private lazy var bottonView:StatusBottom = StatusBottom()
    
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

    private func setupUI(){
    //1.添加控件
    contentView.addSubview(topView)
        
        
    //2.自动布局
    topView.snp_makeConstraints { (make) -> Void in
        
        make.top.equalTo(contentView.snp_top)
        make.left.equalTo(contentView.snp_left)
        make.right.equalTo(contentView.snp_right)
        //TODO: - 修改高度
        make.height.equalTo(60)
        }
    
    }

}
