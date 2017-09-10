//
//  GYZSignInfoModel.swift
//  baking
//  签约用户信息
//  Created by gouyz on 2017/4/19.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZSignInfoModel: NSObject {
    ///用户ID
    var id : String?
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
    /// 经度
    var ads_longitude : String?
    /// 纬度
    var ads_latitude : String?
    
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
