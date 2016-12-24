//
//  StatusPictureView.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/25.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit
//配图视图
class StatusPictureView: UICollectionView {
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
