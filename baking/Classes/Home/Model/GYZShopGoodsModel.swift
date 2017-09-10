//
//  GYZShopGoodsModel.swift
//  baking
//  商家详情model
//  Created by gouyz on 2017/4/9.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZShopGoodsModel: NSObject {
    
    var goods : [GoodsModel]?
    var member_info : ShopInfoModel?
    var activity: [ActivityModel]?
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "goods" {
            
            goods = Array()
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let foodModel = GoodsModel(dict: dict)
                goods?.append(foodModel)
            }

        }else if key == "member_info" {
            
            guard let datas = value as? [String : Any] else { return }
            member_info = ShopInfoModel(dict: datas)
            
        }else if key == "activity"{
            activity = [ActivityModel]()
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = ActivityModel(dict: dict)
                activity?.append(model)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}

/// 所有商品model
class GoodsModel: NSObject {
    
    var goods_class : GoodsCategoryModel?
    var goods_list : [GoodInfoModel]?
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "goods_list" {
            goods_list = Array()
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let foodModel = GoodInfoModel(dict: dict)
                goods_list?.append(foodModel)
            }
        }else if key == "goods_class" {
            
            guard let datas = value as? [String : Any] else { return }
            goods_class = GoodsCategoryModel(dict: datas)
            
        }else {
            super.setValue(value, forKey: key)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}


/// 商品信息model
class GoodInfoModel: NSObject {
    
    var id : String?
    var cn_name : String?
    var goods_img : String?
    var goods_thumb_img : String?
    ///立减价格，或者打几折
    var preferential_price : String?
    ///0无优惠 1立减 2打折
    var preferential_type : String?
    var is_collect : String?
    var month_num : String?
    var attr: [GoodsAttrModel]?
    
    ///优惠价购买数量 0无限制
    var preferential_buy_num : String?
    ///普通价格购买数量 0无限制
    var buy_num : String?
    ///父类ID
    var class_member_id : String?
    ///子类ID
    var class_child_member_id : String?
    ///父类名称
    var class_member_name : String?
    //子类名称
    var class_child_member_name : String?
    /// 店铺ID
    var member_id: String?
    
    override init() {
        
    }
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "attr" {
            attr = [GoodsAttrModel]()
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let attrModel = GoodsAttrModel(dict: dict)
                attr?.append(attrModel)
            }
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

/// 商品分类model
class GoodsCategoryModel: NSObject {
    ///分类ID
    var class_member_id : String?
    ///分类名
    var class_member_name : String?
    ///父级分类ID，-1时为热销商品(固定)
    var parent_class_id : String?
    ///父分类名称
    var parent_class_name : String?
    
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

/// 商家信息model
class ShopInfoModel: NSObject {
    ///商店ID
    var member_id : String?
    ///商店名
    var company_name : String?
    var logo : String?
    ///月销售
    var month_num : String?
    ///起送价
    var send_price : String?
    ///店主留言
    var features : String?
    ///电话
    var tel : String?
    ///地址
    var address : String?
    ///商店图片，分号隔开
    var shop_img : String?
    ///证件照，分号隔开
    var cert_img : String?
    ///商店是否收藏
    var is_collect : String?
    ///经度
    var lng : String?
    ///纬度
    var lat : String?
    //配送距离（行驶距离），单位是千米
    var distance: String?
    
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
