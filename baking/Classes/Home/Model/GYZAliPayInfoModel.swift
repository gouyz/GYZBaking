//
//  GYZAliPayInfoModel.swift
//  baking
//  支付宝信息model
//  Created by gouyz on 2017/4/26.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZAliPayInfoModel: NSObject {
    /// 商户app申请的ID
    var alipay_pid : String?
    /// 支付宝账号
    var alipay : String?
    /// 订单号
    var outTradeNo : String?
    /// 商品的标题
    var orderSubject : String?
    /// 商品描述
    var orderBody : String?
    /// 订单总金额，单位为元，精确到小数点后两位，取值范围[0.01,100000000]
    var price : String?
    /// 回调URL
    var callbackUrl : String?
    
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
