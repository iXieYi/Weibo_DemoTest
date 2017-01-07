//
//  PicturePickerCollection.swift
//  照片选择
//
//  Created by 谢毅 on 17/1/7.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import UIKit
//可重用cell
private let PicturePickerCellId = "PicturePickerCellId"
//最大选择照片数量
private let PicturePickerMaxCount = 8
//照片选择控制器
class PicturePickerCollection: UICollectionViewController {
    
    //配图数组
    lazy var pictures = [UIImage]()
    //当前用户照片选中的照片索引
    private var selectIndex = 0
    
    init(){
    
        super.init(collectionViewLayout:PicturePickerLayout())

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //在colectionViewController中collectionView ！= view
    override func viewDidLoad() {
        super.viewDidLoad()
    //注册可重用cell
        self.collectionView!.registerClass(PicturePickerCell.self, forCellWithReuseIdentifier: PicturePickerCellId)

       collectionView?.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
    
    }

    //类中类 - 照片选择器布局
    private class PicturePickerLayout:UICollectionViewFlowLayout{
        private override func prepareLayout() {
            super.prepareLayout()
            let count:CGFloat = 4
            //在ios9之后，ipad支持分屏，不建议过分依赖布局参照
            //6s- scale= 2;6s+ - scale= 3
            let margin = UIScreen.mainScreen().scale * 4
            let w = ((collectionView?.bounds.width)! - (count + 1) * margin) / count
            itemSize = CGSize(width: w, height: w)
            sectionInset = UIEdgeInsetsMake(margin, margin, 0, margin)
            minimumInteritemSpacing = margin
            minimumLineSpacing = margin
        }
    
    }
   

   
}

 // MARK: 数据源方法
extension PicturePickerCollection{

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 如果达到上限就不显示加号按钮
        return pictures.count + (pictures.count == PicturePickerMaxCount ? 0:1)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PicturePickerCellId, forIndexPath: indexPath) as! PicturePickerCell
        //设置图像
        cell.image = (indexPath.item < pictures.count) ? pictures[indexPath.item] :nil
       
        //设置代理
        cell.pictureDelegate = self
        
        return cell
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension PicturePickerCollection:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    /// 照片选择完成
    ///
    /// - parameter picker: 照片选择控制器
    /// - parameter info:   info字典
    ///一旦实现代理方法，必须自己dismiss
    //cocos2dx 开发一个空白模板，内存占用70m，ios，UI空白应用大概19M
    //一般应用程序内存控制在100M左右，都是可以接受的
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    
        print(info)
        let image = info[UIImagePickerControllerOriginalImage] as!UIImage
        let scaleImage = image.scaleToWith(600)
        
        //判断当前选中的索引是否超出数组上限
        if selectIndex >= pictures.count{
            //将图像添加到数组
            pictures.append(scaleImage)
        
        }else{
        
        pictures[selectIndex] = scaleImage
            
        }
        
        //刷新视图
        collectionView?.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)
    }


}
// MARK: - PicturePickerCellDelegate
extension PicturePickerCollection:PicturePickerCellDelegate{
   @objc private func picturePickerCellDidAdd(cell: PicturePickerCell) {
    //判断是否允许访问相册
    if !UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
    
    print("无法访问照片库")
    return
    }
    
    
    //记录当前用选中照片索引
   selectIndex = collectionView?.indexPathForCell(cell)!.item ?? 0
    
    //照片选择器
    let picker = UIImagePickerController()
    //设置代理
    picker.delegate = self
//    picker.allowsEditing = true//允许编辑 - 适合用于头像选择
    presentViewController(picker, animated: true, completion: nil)
    
    /*
    case PhotoLibrary 相册 = 保存的照片（可以删除） + 同步的照片（不可以删除）
    case SavedPhotosAlbum 保存的照片、屏幕截图、拍照
    
    */
        print("添加照片")
    
    }

   @objc private func picturePickerCellDidRemove(cell: PicturePickerCell) {
    //1.获取照片索引
    let index = collectionView!.indexPathForCell(cell)!
    //2.判断索引是否超出上限
    if index.item >= pictures.count{
    return
    }else{
    //3.删除数据
    pictures.removeAtIndex(index.item)
        
    }
    //4.刷新视图
    collectionView?.deleteItemsAtIndexPaths([index])//动画刷新视图
    
    print("删除照片")
    }
}
/// cell的代理
//如果协议中包含optional 的函数，协议需要使用@objc的修饰，
//但凡是需要遵守动态发布消息的，就需要准守@objc
//备注：如果协议是私有的，在实现协议方法时，函数也是私有的，函数一旦是私有的就没有办法发送消息
@objc
private protocol PicturePickerCellDelegate:NSObjectProtocol{
    //添加照片
  optional func picturePickerCellDidAdd(cell:PicturePickerCell)
    //删除照片
  optional func picturePickerCellDidRemove(cell:PicturePickerCell)

}


/// MARK: - 自定义照片选择cell private 来修饰类，内部一切的方法和属性都是私有的,
///若要使用类里的方法必须将其以 @objc 作为修饰

private class PicturePickerCell:UICollectionViewCell {
   
    //照片选择代理
    weak var pictureDelegate:PicturePickerCellDelegate?
    var image:UIImage?{
    
        didSet{
            
          addButton.setImage(image ?? UIImage(named: "compose_pic_add"), forState: .Normal)
          //隐藏删除按钮 image == nil就是新增按钮
            removeButton.hidden = (image == nil)
        }
    
    }
    
    //MARK: - 监听方法
  @objc func addPicture(){
    
    pictureDelegate?.picturePickerCellDidAdd?(self)
    }
  @objc func removePicture(){
    
   pictureDelegate?.picturePickerCellDidRemove?(self)
    }
    
    //MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //控件很少的时候，将UI界面布局写在这里
    private func setupUI(){
    //1.添加控件
      contentView.addSubview(addButton)
      contentView.addSubview(removeButton)
    //2.设置布局
      addButton.frame = bounds
      removeButton.snp_makeConstraints { (make) -> Void in
        make.top.equalTo(contentView.snp_top)
        make.right.equalTo(contentView.snp_right)
        }
    //3.添加监听方法
        addButton.addTarget(self, action: "addPicture", forControlEvents: .TouchUpInside)
        removeButton.addTarget(self, action: "removePicture", forControlEvents: .TouchUpInside)
    //4.设置填充模式,在imageView上设置才有效果
        addButton.imageView?.contentMode = .ScaleAspectFill
    }
    
    //MARK: - 懒加载控件
    //添加按钮
    private lazy var addButton:UIButton = UIButton(imageName: "compose_pic_add", backImageName: nil)
    //删除按钮
    private lazy var removeButton:UIButton = UIButton(imageName: "compose_photo_close", backImageName: nil)
    
}





