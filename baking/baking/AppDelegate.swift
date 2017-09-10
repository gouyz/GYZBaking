//
//  AppDelegate.swift
//  baking
//
//  Created by gouyz on 2017/3/22.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        /// 设置键盘控制
        setKeyboardManage()
        
        ///高德地图
        AMapServices.shared().apiKey = kMapKey
        
        ///设置极光推送
        setJPush()
        JPUSHService.setup(withOption: launchOptions, appKey: kJPushAppKey, channel: "app store", apsForProduction: true)
        
        //2.1.9版本新增获取registration id block接口
        JPUSHService.registrationIDCompletionHandler { (resCode, registrationID) in
            
//            if resCode == 0{
//                print("registrationID获取成功：\(registrationID)")
//            }else{
//                print("registrationID获取失败，code：\(resCode)")
//            }
        }
        // badge清零
        resetBadge()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = kNavBarColor
        
//        userDefaults.removeObject(forKey: kIsLoginTagKey)
        //        userDefaults.removeObject(forKey: "ticket")
        //如果未登录进入登录界面，登录后进入首页
//        if userDefaults.bool(forKey: kIsLoginTagKey) {
//            window?.rootViewController = GYZMainTabBarVC()
//        }else{
//            window?.rootViewController = GYZBaseNavigationVC(rootViewController: GYZLoginVC())
//        }
        
        if newFeature() {//引导页
            window?.rootViewController = ViewController()
        }else{
            
            /// 加载广告
            let adVC = ZLaunchAdVC()
                .defaultDuration(3)
                .adBottom(0)
                .rootVC(GYZMainTabBarVC())
            
            adVC.configSkipBtn({ (config) in
                
                config.skipBtnType = .circle
                config.strokeColor = UIColor.red
            })
            /// 本地图片
            adVC.configLocalImage(image: UIImage(named: "icon_ads"), duration: 3, adImgViewClick: { [weak self] in
                
                self?.window?.rootViewController = GYZMainTabBarVC()
            })
            window?.rootViewController = adVC
//            window?.rootViewController = GYZMainTabBarVC()
        }
        
        window?.makeKeyAndVisible()
        
        // 获取推送消息
        let remote = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable : Any]
        // 如果remote不为空，就代表应用在未打开的时候收到了推送消息
        if remote != nil {
            // 收到推送消息实现的方法
            self.perform(#selector(receivePush), with: remote, afterDelay: 1.0);
        }
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        dealAliPayResult(url: url)
        return true;
    }
    // NOTE: 9.0以后使用新API接口
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        dealAliPayResult(url: url)
        return true;
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    ///（App即将进入前台）中将小红点角标清除
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    ///出来支付宝回调
    func dealAliPayResult(url: URL){
        if url.host == "safepay" {
            //跳转支付宝钱包进行支付，处理支付结果
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (resultDic) in
                GYZLog(resultDic)
                if let alipayjson = resultDic {
                    /// 支付后返回，刷新数据通知
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kAliPaySuccessResult), object: nil,userInfo:alipayjson)
                }

            })
            
            // 授权跳转支付宝钱包进行支付，处理支付结果
            //这个是进程KILL掉之后也会调用，这个只是第一次授权回调，同时也会返回支付信息
            AlipaySDK.defaultService().processAuth_V2Result(url, standbyCallback: { (resultDic) in
                GYZLog(resultDic)
                if let alipayjson = resultDic {
                    /// 支付后返回，刷新数据通知
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kAliPaySuccessResult), object: nil,userInfo:alipayjson)
                }
            })
        }
    }
    /// 设置键盘控制
    func setKeyboardManage(){
        //控制自动键盘处理事件在整个项目内是否启用
        IQKeyboardManager.sharedManager().enable = true
        //点击背景收起键盘
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        //隐藏键盘上的工具条(默认打开)
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }
    
    /// 极光推送设置
    func setJPush(){
        if #available(iOS 10.0, *){
            let entiity = JPUSHRegisterEntity()
            entiity.types = Int(UNAuthorizationOptions.alert.rawValue |
                UNAuthorizationOptions.badge.rawValue |
                UNAuthorizationOptions.sound.rawValue)
            JPUSHService.register(forRemoteNotificationConfig: entiity, delegate: self)
        } else if #available(iOS 8.0, *) {
            let types = UIUserNotificationType.badge.rawValue |
                UIUserNotificationType.sound.rawValue |
                UIUserNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: types, categories: nil)
        }else {
            let type = UIRemoteNotificationType.badge.rawValue |
                UIRemoteNotificationType.sound.rawValue |
                UIRemoteNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: type, categories: nil)
        }
    }
    /// 极光推送注册成功后会调用AppDelegate的下面方法，得到设备的deviceToken
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        JPUSHService.registerDeviceToken(deviceToken)
        print("Notification token: ", deviceToken)
    }
    ///处理接收推送错误的情况(一般不会…)
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("error: Notification setup failed: ", error)
    }
    /// App在后台时收到推送时的处理
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        JPUSHService.handleRemoteNotification(userInfo)
        
        let aps = userInfo["aps"] as! [String : Any]
        let alert = aps["alert"] as! String
        
        
        //        var badge: Int = aps["badge"] as! Int
        //        badge -= 1
        //        JPUSHService.setBadge(badge)
        /**
         *  iOS的应用程序分为3种状态
         *      1、前台运行的状态UIApplicationStateActive；
         *      2、后台运行的状态UIApplicationStateBackground；
         *      3、app待激活状态UIApplicationStateInactive。
         */
        // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
        if (application.applicationState == .active) || (application.applicationState == .background){
            UIAlertView(title: "推送消息", message: "\(alert)", delegate: nil, cancelButtonTitle: "确定").show()
        }else{
            receivePush(userInfo)
        }
        // badge清零
        resetBadge()
        completionHandler(.newData)
    }
    
    // 接收到推送实现的方法
    func receivePush(_ userInfo : [AnyHashable : Any]) {
        /// 消息推送通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kMessagePush), object: nil,userInfo:nil)
    }
    
    /// 极光推送重置角标
    func resetBadge(){
        // badge清零
        UIApplication.shared.applicationIconBadgeNumber = 0
        JPUSHService.resetBadge()
    }
}

extension AppDelegate : JPUSHRegisterDelegate{
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
        print(">JPUSHRegisterDelegate jpushNotificationCenter willPresent");
        let userInfo = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler(Int(UNAuthorizationOptions.alert.rawValue))// 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    }
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        
        print(">JPUSHRegisterDelegate jpushNotificationCenter didReceive");
        let userInfo = response.notification.request.content.userInfo
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
            
            /**
             *  iOS的应用程序分为3种状态
             *      1、前台运行的状态UIApplicationStateActive；
             *      2、后台运行的状态UIApplicationStateBackground；
             *      3、app待激活状态UIApplicationStateInactive。
             */
            // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
            if (UIApplication.shared.applicationState == .active) || (UIApplication.shared.applicationState == .background) || (UIApplication.shared.applicationState == .inactive){
                
            }else{
                receivePush(userInfo)
            }
        }
        completionHandler()
        // 应用打开的时候收到推送消息
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName_ReceivePush), object: NotificationObject_Sueecess, userInfo: userInfo)
    }
}