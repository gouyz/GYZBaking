//
//  GYZGoodsModel.swift
//  baking
//  商品model
//  Created by gouyz on 2017/4/6.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZGoodsModel: NSObject {
    
    var id : String?
    /// 名称
    var cn_name : String?
    /// 商品图，分号隔开
    var goods_img : String?
    var attr : [GoodsAttrModel]?
    ///缩略图
    var goods_thumb_img : String?
    ///是否收藏 0未收藏 1已收藏
    var is_collect : String?
    /// 店铺ID
    var member_id: String?
    
    override init() {
        super.init()
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
        }else {
            super.setValue(value, forKey: key)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

///商品规格
class GoodsAttrModel: NSObject {
    
    var attr_id : String?
    /// 名称
    var attr_name : String?
    /// 价格
    var price : String?
    ///库存
    var count : String?
    
    
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

///购物车model
class CartModel: NSObject {
    
    var good_id : String?
    /// 名称
    var cn_name : String?
    /// 商品图，分号隔开
    var goods_img : String?
    var attr : GoodsAttrModel?
    ///缩略图
    var goods_thumb_img : String?
    ///数量
    var num : String?
    /// 购物车ID
    var card_id: String?
    ///立减价格，或者打几折
    var preferential_price : String?
    ///0无优惠 1立减 2打折
    var preferential_type : String?
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
    
    override init() {
        super.init()
    }
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "attr" {
            guard let datas = value as? [String : Any] else { return }
            attr = GoodsAttrModel.init(dict: datas)
            
        }else {
            super.setValue(value, forKey: key)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
