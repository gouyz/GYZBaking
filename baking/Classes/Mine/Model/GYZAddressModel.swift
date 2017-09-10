//
//  GYZAddressModel.swift
//  baking
//  地址model
//  Created by gouyz on 2017/4/9.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZAddressModel: NSObject {
    ///地址ID
    var add_id : String?
    /// 用户ID
    var user_id : String?
    /// 收件人
    var consignee : String?
    ///  	省份
    var province : String?
    ///  	城市
    var city : String?
    /// 区
    var area : String?
    ///地址
    var address : String?
    /// 0不是默认 1默认
    var is_default : String?
    /// 经度
    var ads_longitude : String?
    /// 纬度
    var ads_latitude : String?
    /// 0男 1女
    var sex : String?
    ///联系方式
    var tel : String?
    
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
