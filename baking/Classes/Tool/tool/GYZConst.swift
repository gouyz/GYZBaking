//
//  GYZConst.swift
//  flowers
//  常量及共用方法定义
//  Created by gouyz on 2016/11/4.
//  Copyright © 2016年 gouyz. All rights reserved.
//

import Foundation
import UIKit


// keyWindow
let KeyWindow : UIWindow = UIApplication.shared.keyWindow!

/// 屏幕的宽
let kScreenWidth = UIScreen.main.bounds.size.width
/// 屏幕的高
let kScreenHeight = UIScreen.main.bounds.size.height
/// 间距
let kMargin: CGFloat = 10.0
/// 圆角
let kCornerRadius: CGFloat = 5.0
/// 线宽
let klineWidth: CGFloat = 0.5
/// 双倍线宽
let klineDoubleWidth: CGFloat = 1.0
/// 状态栏高度
let kStateHeight : CGFloat = 20.0
/// 标题栏高度
let kTitleHeight : CGFloat = 44.0
/// 状态栏和标题栏高度
let kTitleAndStateHeight : CGFloat = 64.0
/// 底部导航栏高度
let kBottomTabbarHeight : CGFloat = 49.0

/** 商家详情页header和menu的高度 */
let kHeaderHight:CGFloat = 210
let kScrollHorizY = kTitleHeight+kHeaderHight

/// 按钮高度
let kUIButtonHeight : CGFloat = 44.0

/// 用于店铺实景/评论等显示图片高度
let kBusinessImgHeight = (kScreenWidth - kMargin*5)*0.25
/// 最大上传图片张数
let kMaxSelectCount = 4

/// alertViewController 取消的回调返回的索引
let cancelIndex = -1

/// 记录版本号的key
let LHSBundleShortVersionString = "LHSBundleShortVersionString"
/// 是否登录标识
let kIsLoginTagKey = "loginTag"
///支付宝回调数据 通知名称
let kAliPaySuccessResult = "aliPaySuccessResult"
///消息推送通知名称
let kMessagePush = "kMessagePush"

/// 极光推送AppKey
let kJPushAppKey = "e3a2deccc4f7e0739b462c65"
//APPID，应用提交时候替换
let APPID = "1236557602"
/// 高德地图key
let kMapKey = "34e29b342dfa0b2ae94788d344f72c00"

/// 数据返回的分页数量
let kPageSize = 10
/// 网络数据请求成功标识
let kQuestSuccessTag = 1

/// 字体常量
let k10Font = UIFont.systemFont(ofSize: 10.0)
let k12Font = UIFont.systemFont(ofSize: 12.0)
let k13Font = UIFont.systemFont(ofSize: 13.0)
let k14Font = UIFont.systemFont(ofSize: 14.0)
let k15Font = UIFont.systemFont(ofSize: 15.0)
let k18Font = UIFont.systemFont(ofSize: 18.0)
let k20Font = UIFont.systemFont(ofSize: 20.0)

let userDefaults = UserDefaults.standard

///颜色常量

/// 通用背景颜色
let kBackgroundColor : UIColor = UIColor.UIColorFromRGB(valueRGB: 0xf4f4f4)
/// 导航栏背景颜色
let kNavBarColor : UIColor = UIColor.UIColorFromRGB(valueRGB: 0xffbb02)
/// 黑色字体颜色
let kBlackFontColor : UIColor = UIColor.UIColorFromRGB(valueRGB: 0x212121)
/// 深灰色字体颜色
let kHeightGaryFontColor : UIColor = UIColor.UIColorFromRGB(valueRGB: 0x585858)
/// 灰色字体颜色
let kGaryFontColor : UIColor = UIColor.UIColorFromRGB(valueRGB: 0x9c9c9c)
/// 浅灰色字体颜色
let kLightGaryFontColor : UIColor = UIColor.UIColorFromRGB(valueRGB: 0x9c9c9c)
/// 红色字体颜色
let kRedFontColor : UIColor = UIColor.UIColorFromRGB(valueRGB: 0xe60012)
/// 黄色字体颜色
let kYellowFontColor : UIColor = UIColor.UIColorFromRGB(valueRGB: 0xffbb02)
/// 灰色线的颜色
let kGrayLineColor : UIColor = UIColor.UIColorFromRGB(valueRGB: 0xe5e5e5)
/// btn不可点击背景色
let kBtnNoClickBGColor : UIColor = UIColor.UIColorFromRGB(valueRGB: 0xd8d8d8)
/// btn可点击背景色
let kBtnClickBGColor : UIColor = UIColor.UIColorFromRGB(valueRGB: 0xffbb02)
/// 系统白色
let kWhiteColor : UIColor = UIColor.white
/// 系统黑色
let kBlackColor : UIColor = UIColor.black

/// 根据版本号来确定是否进入新特性界面
///
/// - returns: true/false
func newFeature() -> Bool {
    
    /// 获取当前版本号
    let currentVersion = GYZUpdateVersionTool.getCurrVersion()
    
    let oldVersion = userDefaults.object(forKey: LHSBundleShortVersionString) ?? ""
    
    if currentVersion.compare(oldVersion as! String) == .orderedDescending{
        
        return true
    }
    return false
}

/****** 自定义Log ******/
func GYZLog<T>(_ message: T, fileName: String = #file, function: String = #function, lineNumber: Int = #line) {
    #if DEBUG
        let filename = (fileName as NSString).pathComponents.last
        print("\(filename!)\(function)[\(lineNumber)]: \(message)")
    #endif
}
