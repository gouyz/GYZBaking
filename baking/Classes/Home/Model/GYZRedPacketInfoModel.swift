//
//  GYZRedPacketInfoModel.swift
//  baking
//  红包信息model
//  Created by gouyz on 2017/9/18.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZRedPacketInfoModel: NSObject {

    ///标题
    var title : String?
    /// 开始时间
    var start_time : String?
    /// 结束时间
    var end_time : String?
    /// 最低使用金额
    var use_amount : String?
    ///优惠金额
    var discount_amount : String?
    /// 1签约优惠券；0商家优惠券
    var type : String?
    /// 公司名
    var company_name : String?
    ///手机号码
    var phone: String?
    
    var create_time : String?
    
    
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
