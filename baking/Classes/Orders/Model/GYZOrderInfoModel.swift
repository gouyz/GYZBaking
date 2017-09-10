//
//  GYZOrderInfoModel.swift
//  baking
//  订单model
//  Created by gouyz on 2017/4/7.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZOrderInfoModel: NSObject {
    
    var order_id : String?
    /// 订单编号
    var order_number : String?
    /// 金额
    var pay_price : String?
    /// 订单状态 0未支付 1已支付 2取消订单 3货到付款 4订单已派送 5已收货收6已退款7交易成功
    var status : String?
    /// 0未支付 1已支付
    var is_pay : String?
    /// 1微信支付 2支付宝支付
    var pay_type : String?
    /// 下单时间
    var create_time : String?
    /// 地址
    var address : String?
    /// 是否评论过 0未评论 1已评论
    var is_comment : String?
    /// 收货人
    var consignee : String?
    /// 收货人联系方式
    var tel : String?
    /// 省
    var province : String?
    /// 城市
    var city : String?
    /// 区
    var area : String?
    /// 备注
    var message : String?
    /// 订单价格
    var order_price: String?
    ///运费
    var freight: String?
    ///配送时间
    var send_time: String?
    /// 优惠说明
    var event_name: String?
    ///优惠金额
    var original_price: String?
    ///使用的余额
    var use_balance: String?
    ///退货金额
    var back_price: String?
    ///订单商家信息
    var member_info : OrderBusinessModel?
    ///订单商品
    var goods_list : [OrderGoodsModel]?
    //是否已接单0未接单1接单
    var is_confirm: String?
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "member_info" {
            
            guard let datas = value as? [String : Any] else { return }
            member_info = OrderBusinessModel.init(dict: datas)
            
        }else if key == "goods_list"{
            goods_list = [OrderGoodsModel]()
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = OrderGoodsModel(dict: dict)
                goods_list?.append(model)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

///订单商家model
class OrderBusinessModel: NSObject {
    
    /// 商家ID
    var member_id : String?
    /// 名称
    var company_name : String?
    /// 商家logo
    var logo : String?
    
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

class OrderGoodsModel: NSObject {
    
    /// 商品ID
    var goods_id : String?
    /// 商品价格
    var goods_price : String?
    /// 商品数量
    var goods_sum : String?
    /// 商品名称
    var cn_name : String?
    /// 商品图片
    var goods_thumb_img : String?
    ///商品状态，0未收货 1已收货 -1退货
    var goodstate: String?
    /// 规格ID
    var attr_id : String?
    /// 规格名称
    var attr_name : String?
    
    
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
