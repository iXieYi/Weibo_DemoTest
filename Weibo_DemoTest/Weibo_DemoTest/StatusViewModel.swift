//
//  StatusViewModel.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/22.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit

//微博视图模型 - 处理单条微博业务逻辑
class StatusViewModel:CustomStringConvertible {
    //微博的模型
    var status: Status
    var userProfileUrl:NSURL{
    
        return NSURL(string: status.user?.profile_image_url ?? "")!
    }
    //cell缓存的行高值
    lazy var rowHeight:CGFloat = {
        
//        print("计算行高\(self.status.text)")
        //1.cell
        let cell = StatusCell(style: .Default, reuseIdentifier: StatusCellNormalId)
        //2.计算返回高度
         return cell.rowHeight(self)
    
    }()
    
    //用户默认头像
    var userDefaultIconView:UIImage{
    return UIImage(named: "avatar_default_big")!
    }
    //会员图标
    var usermemeberImage: UIImage?{
    //根据mbrank生成图像
        if status.user?.mbrank > 0 && status.user?.mbrank < 7{
        
        let usermemeberImageUrl:String = "common_icon_membership_level\(status.user!.mbrank)"
//        print(usermemeberImageUrl)
         return UIImage(named:usermemeberImageUrl)
            
        }
   return nil
    }
    //UIImage imageName 来设置图片，由系统管理，程序员不能直接被释放，适用于小图素材
    //不能用于加载高清大图
    
    ///vip 图标,用户认证图标
    ///认证用户类型 -1:没有认证， 0 ：认证用户 2、3、5 企业认证 220：达人
    var userVipImage: UIImage?{
    status.user?.verified_type
        switch(status.user?.verified_type ?? -1){
        case 0: return UIImage(named: "avatar_vip")
        case 2,3,5: return UIImage(named: "avatar_enterprise_vip")
        case 220: return UIImage(named: "avatar_grassroot")
        default: return nil
        
        
        }
    
    }
    //缩略图URL数组 - 存储型属性
    //如果是原创微博，可以有图也可以没有图，
    //转发微博一定没有图，retweed_status，可以有图也可以没有图
    //一条微博只有一个pic_urls 数据
    var thumbnailUrls:[NSURL]?
    
    /// 构造函数
    init(status: Status){
    
    self.status = status
    //根据模型生成缩略图数组
        //首先判断转发微博图片数据是否为空，若为空那么查看原创微博的配图
        if let urls = status.retweeted_status?.pic_urls ?? status.pic_urls{
        
        //创建缩略图数组
        thumbnailUrls = [NSURL]()    //分配空间
        //遍历字典数组 ->如果数组可选，不允许遍历：原因：数组是通过下标来检索数据的
            
            for dict in urls{
                let url = NSURL(string: dict["thumbnail_pic"]!)
              //相信服务器返回url 一定生成
              thumbnailUrls?.append(url!)
            }
        
        }
        
    }
    var description: String{
    return status.description + "配图 \(thumbnailUrls ?? [] as NSArray)"
    }
}