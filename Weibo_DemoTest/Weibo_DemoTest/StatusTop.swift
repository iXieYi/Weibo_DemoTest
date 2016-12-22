//
//  StatusTop.swift
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
//顶部视图
class StatusTop: UIView {
    //MARK:构造
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:- 懒加载控件
    //头像
    private lazy var iconView:UIImageView = UIImageView(imageName: "avatar_default_big")
    //姓名
    private lazy var namelabel:UILabel = UILabel(title: "王老五", fontSize: 14)
    //会员等级
    private lazy var memberIconView:UIImageView = UIImageView(imageName: "common_icon_membership_level1")
    //vip
    private lazy var vipIconView:UIImageView = UIImageView(imageName: "avatar_vip")
    //发布时间
    private lazy var timeLabel:UILabel = UILabel(title: "现在", fontSize: 11, color: UIColor.orangeColor())
    //来源
    private lazy var sourceLabel:UILabel = UILabel(title: "来源", fontSize: 11)
    

}
extension StatusTop{
    private func setupUI(){
    
    backgroundColor = UIColor(white: 0.95, alpha: 1.0)
    //自头像
    addSubview(iconView)
    addSubview(namelabel)
    addSubview(memberIconView)
    addSubview(vipIconView)
    addSubview(timeLabel)
    addSubview(sourceLabel)
    
    //自动布局
    //1.头像
    iconView.snp_makeConstraints { (make) -> Void in
    make.top.equalTo(self.snp_top).offset(StatusCellMargin)
    make.left.equalTo(self.snp_left).offset(StatusCellMargin)
    make.width.equalTo(StatusCellIconWidth)
    make.height.equalTo(StatusCellIconWidth)
        }
    //2.名称
    namelabel.snp_makeConstraints { (make) -> Void in
    make.top.equalTo(iconView.snp_top)
    make.left.equalTo(iconView.snp_right).offset(StatusCellMargin)
    //3.会员等级
    memberIconView.snp_makeConstraints(closure: { (make) -> Void in
    make.left.equalTo(namelabel.snp_right).offset(StatusCellMargin)
    make.top.equalTo(namelabel.snp_top)
        
    })
    //4.vip等级
    vipIconView.snp_makeConstraints(closure: { (make) -> Void in
    make.centerX.equalTo(iconView.snp_right)
    make.centerY.equalTo(iconView.snp_bottom)
    })
    //5.发布时间
    timeLabel.snp_makeConstraints(closure: { (make) -> Void in
        make.bottom.equalTo(iconView.snp_bottom)
        make.left.equalTo(iconView.snp_right).offset(StatusCellMargin)
    })
    //6.来源
    sourceLabel.snp_makeConstraints(closure: { (make) -> Void in
        make.left.equalTo(timeLabel.snp_right).offset(StatusCellMargin)
        make.bottom.equalTo(iconView.snp_bottom)
    })
    
        }
    
    }


}
