//
//  AppDelegate.swift
//  Weibo_DemoTest
//
//  Created by 谢毅 on 16/12/11.
//  Copyright © 2016年 xieyi. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        setupAppearance()
        window = UIWindow (frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
//        window?.rootViewController = MainTabBarController()
        window?.rootViewController = defaultRootViewController
        window?.makeKeyAndVisible()
//        print(isNewVersion)
        
//测试归档
//    print(UserAccountViewModel.sharedUserAccount.account)
        return true
    }
    //设置全局外观
    private func setupAppearance(){
        
        //修改导航栏的全局外观(1、要求一定要在创建之前准备好；2、一经设置全局有效)
        //->通常出现在AppDelegate中,会设置所有控件的全局外观
        UINavigationBar.appearance().tintColor = WBAppearanceTintColor
        
        
        //设置图片渲染颜色，能用颜色设置就用颜色设置，能减少内存的消耗
        UITabBar.appearance().tintColor = WBAppearanceTintColor
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
// MARK: - 界面切换代码
extension AppDelegate{
    
    private var defaultRootViewController:UIViewController{
    //1.判断是否登录
        if UserAccountViewModel.sharedUserAccount.logon{
        
            return isNewVersion ? NewFestureViewController():WelcomeViewController()
        }
        
        
    //2.没有登录返回主控制器
    return MainTabBarController()
    
    }
    
    //判断是否是新版本
    private var isNewVersion:Bool {
    //1.当前版本 在info.plist 中
    //print(NSBundle.mainBundle().infoDictionary)
    let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
    let Version = Double(currentVersion)!
    print("当前版本号:\(Version)")
        
    //2.之前的版本保存在用户偏好中去 - 如果key不存在直接返回 0
    let sandBoxVersionKey = "sandBoxVersionKey"
    let sandBoxVersion = NSUserDefaults.standardUserDefaults().doubleForKey(sandBoxVersionKey)
    print("之前版本:\(sandBoxVersion)")
        
        
    //3.保存当前版本
    NSUserDefaults.standardUserDefaults().setDouble(Version, forKey: sandBoxVersionKey)
    
        return Version > sandBoxVersion
    }



}
