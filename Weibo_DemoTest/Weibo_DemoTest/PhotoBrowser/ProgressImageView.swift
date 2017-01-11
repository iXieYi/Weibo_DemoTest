//
//  ProgressImageView.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 17/1/11.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import UIKit
import SVProgressHUD
/// 带进度的图像视图
//面试题：如果在UIImageView的 drawRect中绘图会怎样
//不会执行该函数
class ProgressImageView: UIImageView {
    
    //进度值0-1之间
    var progress:CGFloat = 0 {
        didSet{
        progressView.progress = progress
        }
    }
    //MARK：- 懒加载控件
    private lazy var progressView:ProgressView = ProgressView()
    //一旦给系统指定了构造函数，系统就不在指定默认的构造函数
    init(){
    super.init(frame: CGRectZero)
    
    setupUI()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
    
    addSubview(progressView)
    progressView.backgroundColor = UIColor.clearColor()
    //布局
    progressView.snp_makeConstraints { (make) -> Void in
        make.edges.equalTo(self.snp_edges)
        
        }
    
    }

}

/// 进度视图
private class ProgressView:UIView{

   //内部使用的进度值
    var progress:CGFloat = 0.7 {
        didSet{
            //重绘制视图
            setNeedsDisplay()
            
        }
    }

 //rect == bounds,绘进度的图
    override func drawRect(rect: CGRect) {
        
        let center = CGPoint(x: rect.width*0.5, y: rect.height * 0.5)
        let r = min(rect.width, rect.height) * 0.5
        let start = CGFloat(-M_PI_2)
        let end = start + progress * 2 * CGFloat(M_PI)
        //画弧线
        //1.中心点
        //2.半径
        //3.起始弧度
        //4.结束弧度
        //5.是否逆时针
        let path = UIBezierPath(arcCenter: center, radius: r, startAngle: start, endAngle: end, clockwise: true)
        //添加到中心点的连线 ->目的是为了实现良好的填充
        path.addLineToPoint(center)
        path.closePath()
        UIColor(white: 1.0, alpha: 0.3).setFill()

        path.fill()
        
    }


}

