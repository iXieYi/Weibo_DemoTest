//
//  StatusListViewModel.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/22.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import Foundation

//微博数据列表模型->封装网络的方法

class StatusListViewModel {
    
/// 微博数据数组 -上拉、下拉刷新
    lazy var statuslist = [StatusViewModel]()
    //加载网路数据
    func loadStatus(finished:(isSuccess:Bool)->()){
    
        NetworkTools.sharedTools.loadStatus { (result, error) -> () in
            
            if error != nil {
                print("出错了。。。")
                finished(isSuccess: false)
                return
            }
            //转成数组
            guard let array = result!["statuses"] as? [[String:AnyObject]] else{
                
                print("数据格式错误")
                finished(isSuccess: false)
                return
            }
            //便历数组，字典转模型
            //1.可变数组
            var arrayM = [StatusViewModel]()
            //2.遍历数组
            for dict in array{
                arrayM.append(StatusViewModel(status:Status(dict: dict)))
            }
            //3.拼接数据
           self.statuslist = arrayM + self.statuslist
            
            //4.完成回调
           finished(isSuccess: true)
            
        }

    
    }
    
}