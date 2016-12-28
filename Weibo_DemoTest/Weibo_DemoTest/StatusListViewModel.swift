//
//  StatusListViewModel.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/22.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import Foundation
import SDWebImage
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
            //5.缓存单张图片
            self.cacheSingleImage1(arrayM, finished: { (isSuccessed) -> () in
             print("缓存成功")
                
            })
        }
    }
    
    /// 缓存单张图片
    private func cacheSingleImage(datalist: [StatusViewModel]){
        
        
    //1.创建调度组
    let group = dispatch_group_create()
    let queue = dispatch_get_global_queue(0, 0)
    
    //缓存的数据长度
    var datalength = 0
    //2.遍历视图模型数组
        for vm in datalist{
        //判断图片数量是否是单张图片
            if vm.thumbnailUrls?.count != 1{
               continue
            }
//          print(vm.thumbnailUrls)
            
        //获取 url
        let url = vm.thumbnailUrls![0]
        
        
        
        dispatch_group_async(group, queue, { () -> Void in
            print("开始缓存图像\(url)")
           //SDWebImage -下载图像，缓存是自动完成的
            SDWebImageManager.sharedManager().downloadImageWithURL(
                url,
                options: [SDWebImageOptions.RefreshCached,SDWebImageOptions.RetryFailed],
                progress: nil,
                completed: { (image, _, _, _, _) -> Void in
                    //单张图片下载完成 - 计算长度
                    //下面做了image 是否有值，
                    if let img = image ,let data = UIImagePNGRepresentation(img){
                        //累加二进制数据长度
                        datalength += data.length
                        
                    }
            })

        
        })
            
       }
    //监听调度组完成
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            print("缓存完成\(datalength)")
            
            
        }

    
    
    }
    /// 缓存单张图片
    private func cacheSingleImage1(dataList: [StatusViewModel], finished: (isSuccessed: Bool)->()) {
        
        // 1. 创建调度组
        let group = dispatch_group_create()
        // 缓存数据长度
        var dataLength = 0
        
        // 2. 遍历视图模型数组
        for vm in dataList {
            
            // 判断图片数量是否是单张图片
            if vm.thumbnailUrls?.count != 1 {
                continue
            }
            
            // 获取 url
            let url = vm.thumbnailUrls![0]
            print("开始缓存图像 \(url)")
            
            // SDWebImage - 下载图像(缓存是自动完成的)
            // 入组 - 监听后续的 block
            dispatch_group_enter(group)
            
            // SDWebImage 的核心下载函数，如果本地缓存已经存在，同样会通过完成回调返回
            SDWebImageManager.sharedManager().downloadImageWithURL(
                url,
                options: [SDWebImageOptions.RefreshCached, SDWebImageOptions.RetryFailed],
                progress: nil,
                completed: { (image, _, _, _, _) -> Void in
                    
                    // 单张图片下载完成 － 计算长度
                    if let img = image,
                        let data = UIImagePNGRepresentation(img) {
                            
                            // 累加二进制数据的长度
                            dataLength += data.length
                    }
                    
                    
            })
            // 出组
            dispatch_group_leave(group)
        }
        
    
        // 3. 监听调度组完成
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            print("缓存完成 \(dataLength / 1024) K")
            
            // 完成回调 - 控制器才开始刷新表格
            finished(isSuccessed: true)
        }
    }
    
}