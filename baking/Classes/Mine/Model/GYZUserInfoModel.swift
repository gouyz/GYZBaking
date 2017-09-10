//
//  GYZUserInfoModel.swift
//  baking
//  用户信息model
//  Created by gouyz on 2017/4/30.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZUserInfoModel: NSObject {
    ///用户ID
    var id : String?
    /// 账号
    var phone : String?
    /// 头像
    var head_img : String?
    ///  昵称
    var username : String?
    /// 是否签约，0未签约 1已签约
    var is_signing : String?
    /// 商店名
    var shop_name : String?
    /// 地址
    var address : String?
    ///  区
    var area : String?
    ///  	签约时间
    var signing_time : String?
    /// 图片，分号隔开
    var shop_img : String?
    ///省
    var province : String?
    /// 市
    var city : String?
    /// 店铺经度
    var shop_longitude : String?
    /// 店铺纬度
    var shop_latitude : String?
    ///  	人的经度
    var longitude : String?
    ///  	人的纬度
    var latitude : String?
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
