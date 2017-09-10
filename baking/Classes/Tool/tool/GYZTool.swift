//
//  GYZTool.swift
//  LazyHuiSellers
//  通用功能
//  Created by gouyz on 2016/12/15.
//  Copyright © 2016年 gouyz. All rights reserved.
//

import UIKit
import AudioToolbox
import MJRefresh

///小于运算符
func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool
{
    switch (lhs, rhs)
    {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}
///等于运算符
func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool
{
    switch (lhs, rhs)
    {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

class GYZTool: NSObject {

    
    ///1.单例
    static let shareTool = GYZTool()
    private override init() {}

    
    /// 播放声音
    ///这个只能播放不超过30秒的声音，它支持的文件格式有限，具体的说只有CAF、AIF和使用PCM或IMA/ADPCM数据的WAV文件
    /// - Parameter sound: 声音文件名称
    class func playAlertSound(sound:String)
    {
        //声音地址
        guard let soundPath = Bundle.main.path(forResource: sound, ofType: nil)  else { return }
        guard let soundUrl = NSURL(string: soundPath) else { return }
        //建立的systemSoundID对象
        var soundID:SystemSoundID = 0
        //赋值
        AudioServicesCreateSystemSoundID(soundUrl, &soundID)
        //播放声音
        AudioServicesPlaySystemSound(soundID)
    }
    
    ///MARK -添加上拉/下拉刷新
    
    /// 添加下拉刷新
    ///
    /// - Parameters:
    ///   - scorllView: 添加下拉刷新的视图
    ///   - pullRefreshCallBack: 刷新回调
    class func addPullRefresh(scorllView : UIScrollView?,pullRefreshCallBack : MJRefreshComponentRefreshingBlock?){
        
        if scorllView == nil || pullRefreshCallBack == nil {
            return
        }
//        weak var weakScrollView = scorllView
        let refreshHeader : MJRefreshNormalHeader = MJRefreshNormalHeader.init {
            
            pullRefreshCallBack!()
            
//            if weakScrollView?.mj_footer.isHidden == false {
//                weakScrollView?.mj_footer.resetNoMoreData()
//            }
        }
        
        scorllView?.mj_header = refreshHeader
    }
    /// 添加上拉刷新
    ///
    /// - Parameters:
    ///   - scorllView: 添加上拉刷新的视图
    ///   - loadMoreCallBack: 刷新回调
    class func addLoadMore(scorllView : UIScrollView?,loadMoreCallBack : MJRefreshComponentRefreshingBlock?){
        if scorllView == nil || loadMoreCallBack == nil {
            return
        }
        
        let loadMoreFooter = MJRefreshAutoNormalFooter.init {
            loadMoreCallBack!()
        }
        //空数据时，设置文字为空
        loadMoreFooter?.setTitle("", for: .idle)
        loadMoreFooter?.setTitle("正在为您加载数据", for: .refreshing)
        loadMoreFooter?.setTitle("没有更多了~", for: .noMoreData)
//        loadMoreFooter?.isAutomaticallyRefresh = false
        scorllView?.mj_footer = loadMoreFooter
    }
    /// 停止下拉刷新
    class func endRefresh(scorllView : UIScrollView?){
        scorllView?.mj_header.endRefreshing()
    }
    
    /// 停止上拉加载
    class func endLoadMore(scorllView : UIScrollView?){
        scorllView?.mj_footer.endRefreshing()
    }
    
    /// 提示没有更多数据的情况
    class func noMoreData(scorllView : UIScrollView?){
        scorllView?.mj_footer.endRefreshingWithNoMoreData()
    }
    /// 重置没有更多数据的情况
    class func resetNoMoreData(scorllView : UIScrollView?){
        scorllView?.mj_footer.resetNoMoreData()
    }
    
    /// 拨打电话
    ///
    /// - Parameter phone: 电话号码
    class func callPhone(phone: String){
        //自动打开拨号页面并自动拨打电话UIApplication.shared.openURL(URL(string: "tel://10086")!)
        //有提示
        UIApplication.shared.openURL(URL(string: "telprompt://"+phone)!)
    }
    
    /// 退出登录时，移除用户信息
    class func removeUserInfo(){
        userDefaults.removeObject(forKey: kIsLoginTagKey)
        userDefaults.removeObject(forKey: "userId")
        userDefaults.removeObject(forKey: "phone")
        userDefaults.removeObject(forKey: "username")
        userDefaults.removeObject(forKey: "signing")
        userDefaults.removeObject(forKey: "longitude")
        userDefaults.removeObject(forKey: "latitude")
        userDefaults.removeObject(forKey: "headImg")
    }
    
    ///返回图片路径地址
    ///
    /// - Parameter url:
    /// - Returns: 
    class func createImgUrl(url: String?)->URL?{
        if url == nil {
            return nil
        }
        return URL.init(string: BaseRequestImgURL + url!)
    }
    
    ///解析多图的URL
    ///
    /// - Parameter url:
    /// - Returns:
    class func getImgUrls(url: String?)->[String]?{
        if url == nil || (url?.isEmpty)! {
            return nil
        }
        return url?.components(separatedBy: ";")
    }
}
