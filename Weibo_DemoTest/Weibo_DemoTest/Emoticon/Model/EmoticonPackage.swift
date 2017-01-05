//
//  EmoticonPackage.swift
//  表情键盘
//
//  Created by 谢毅 on 16/12/31.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit
//MARK: - 表情包模型
class EmoticonPackage: NSObject {
    //表情包路径
    var id:String?
    //表情包名称，显示在toolbar中
    var group_name_cn:String?
    //表情数组，使用懒加载，定义并且分配空间，
    //当使用的时候数组已经存在，可以直接追加数据
    lazy var emoticons = [Emoticon]()
    //setValueForKeyWithDictionary ->不会按顺序调用字典中的key 
    //因此不能保证设置emoticon数值时，id 已经被设置了
    init(dict:[String: AnyObject]) {
        super.init()
        id  = dict["id"] as? String
        group_name_cn = dict["group_name_cn"] as? String
        //第一步获得字典的数组
        if let array = dict["emoticons"] as? [[String:AnyObject]]{
        //遍历数组
            var index = 0 //每20个加一个删除按钮
            
            for var d in array{
            //判断是否有png
                if let png = d["png"] as? String,dir = id {
                    //重新设置png的Value
                    d["png"] = dir + "/" + png
                }
            emoticons.append(Emoticon(dict: d))//追加到数组中
            index++
            if index == 20{
                emoticons.append(Emoticon(isRemoved: true))
                index = 0
                    
                }
            }
        }
        
        //2.添加空白按钮
        appendEmptyEmoticon()
        
 }
    //在表情数组末尾添加表情
    private func appendEmptyEmoticon(){
    //取表情余数
    let count  = emoticons.count % 21
   
    //只有最近和默认需要添加表情数量
        if emoticons.count > 0 && count == 0{
        
        return
        }
     print("剩余:\(count)")
        //添加空白表情
        for _ in count..<20{
        emoticons.append(Emoticon(isEmpty: true))
        
        }
        //添加一个删除按钮
        emoticons.append(Emoticon(isRemoved: true))
    
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    override var description:String{
    
        let keys = ["id","group_name_cn","emoticons"]
        return  dictionaryWithValuesForKeys(keys).description
    }
    
}
