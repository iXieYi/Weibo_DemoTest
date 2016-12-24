//
//  StatusBottom.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/22.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit
//底部视图
class StatusBottom: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
/// MARK: - 懒加载控件
    //转发按钮
    private lazy var retweetedButton:UIButton = UIButton(title: "  转发", fontSize: 12, color: UIColor.darkGrayColor(), imageName: "timeline_icon_retweet")
    //评论按钮
     private lazy var commentButton:UIButton = UIButton(title: "  评论", fontSize: 12, color: UIColor.darkGrayColor(), imageName: "timeline_icon_comment")
    //点赞按钮
     private lazy var likeButton:UIButton = UIButton(title: "  点赞", fontSize: 12, color: UIColor.darkGrayColor(), imageName: "timeline_icon_unlike")

}
//MARK: - 设置界面
extension StatusBottom{
    private func setupUI(){
    //0.设置视图背景颜色
    backgroundColor = UIColor(white: 0.9, alpha: 1.0)
    //1.设置界面
    addSubview(retweetedButton)
    addSubview(commentButton)
    addSubview(likeButton)
        
        
    //2.自动布局 - 有主次之分，先布局主要的，再布局次要的
        
    retweetedButton.snp_makeConstraints { (make) -> Void in
        
        make.left.equalTo(self.snp_left)
        make.top.equalTo(self.snp_top)
        make.bottom.equalTo(self.snp_bottom)
        
        }
        
    commentButton.snp_makeConstraints { (make) -> Void in
        
        make.top.equalTo(retweetedButton.snp_top)
        make.bottom.equalTo(retweetedButton.snp_bottom)
        make.left.equalTo(retweetedButton.snp_right)
        make.width.equalTo(retweetedButton.snp_width)
        }
        
    likeButton.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(commentButton.snp_top)
            make.bottom.equalTo(commentButton.snp_bottom)
            make.left.equalTo(commentButton.snp_right)
            make.right.equalTo(self.snp_right)
            make.width.equalTo(commentButton.snp_width)
        }
    
        
    //3.分割视图
        let sep1 = sepView()
        let sep2 = sepView()
        addSubview(sep1)
        addSubview(sep2)
    //布局
        let w  = 0.8   //iPhone 6 一个点是两个像素，6+ 是3个像素
        let scale = 0.4
        sep1.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(retweetedButton.snp_right)
            make.centerY.equalTo(retweetedButton.snp_centerY)
            make.width.equalTo(w)
            make.height.equalTo(retweetedButton.snp_height).multipliedBy(scale)
        }
        sep2.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(commentButton.snp_right)
            make.centerY.equalTo(commentButton.snp_centerY)
            make.width.equalTo(w)
            make.height.equalTo(commentButton.snp_height).multipliedBy(scale)
        }

    }
   //创建 分割视图线
    private func sepView()->UIView{
    let V = UIView()
    V.backgroundColor = UIColor.darkGrayColor()
    return V
    
    }
     /*创建 分割视图线(计算型属性),会让代码阅读产生困惑
    private var sepView:UIView{
        let V = UIView()
        V.backgroundColor = UIColor.darkGrayColor()
        return V
    }
    
  */
    
    
}