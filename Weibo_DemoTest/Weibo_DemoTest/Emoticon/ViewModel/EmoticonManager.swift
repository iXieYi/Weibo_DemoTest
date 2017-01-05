//
//  EmoticonViewModel.swift
//  表情键盘
//
//  Created by 谢毅 on 16/12/31.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import Foundation


//表情包视图模型 - emoticons.plist
/*
1、emoticon.plist 定义表情包数组
packgages 字典数组中，每一个id对应不同的表情包目录
2、从每个表情包中，加载info.plist 可以获得不同的表情内容
id 目录里
group_name_cn 表情分组名称 显示在toobar上
emotions 数组两种类型
字典：chs 发送给服务器的字符串
png 在本地显示的图片名称
code emoji字符串编码

*/
class EmoticonManager {
    //建立单例
    
    static let shareManager = EmoticonManager()
   //表情包模型
  lazy var package = [EmoticonPackage]()
    //MARK: - 构造函数限制外界获取
   private init(){
    
      LoadPlist()
    }
     //加载表情包数据
    private func LoadPlist(){
        //0.添加最近的分组
        package.append(EmoticonPackage(dict: ["group_name_cn":"最近"]))
        //1.加载emoticons.plist - 如果文件不存在 path = nil
        //该方式是在Emoticons.bundle包下，查找emoticons.plist文件
        let path = NSBundle.mainBundle().pathForResource("emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")
        //2.加载字典
        let dict = NSDictionary(contentsOfFile: path!) as! [String:AnyObject]
        //3.从字典中获得id的数组(kVC)的方法 - 直接获取字典数组中的key 对应的数据
        let array = (dict["packages"] as! NSArray).valueForKey("id")
        //4.遍历id数组，准备加载info.plist 文件
        for id in array as![String]{
            
            loadInfoPlist(id)
            
        }
        //5.遍历结果
        print(package)
    
    
    }
    
/// 加载每一个id 目录下的 info.plist
    private func loadInfoPlist(id:String){
    //1.建立路径
    let path = NSBundle.mainBundle().pathForResource("info.plist", ofType: nil, inDirectory: "Emoticons.bundle/\(id)")!
    //2.加载字典 - 是一个独立的表亲包
    let dict = NSDictionary(contentsOfFile: path) as! [String: AnyObject]
    //3.字典转模型 - 追加到package的数组里去
    package.append(EmoticonPackage(dict: dict))
    }
    
    
}




