//
//  GYZGoodsDetailModel.swift
//  baking
//  商品详情model
//  Created by gouyz on 2017/4/17.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZGoodsDetailModel: GYZGoodsModel {
    ///月销售
    var month_num : String?
    /// 商户ID
    var class_member_id : String?
    /// 立减金额或打折
    var preferential_price : String?
    ///0无优惠 1立减 2打折
    var preferential_type : String?
    /// 	商铺名
    var class_member_name : String?
    ///起送价
    var send_price : String?
    var comment: [GYZBusinessConmentModel]?
    
    override init(dict : [String : Any]) {
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
        }else if key == "comment"{
            comment = [GYZBusinessConmentModel]()
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let attrModel = GYZBusinessConmentModel(dict: dict)
                comment?.append(attrModel)
            }
        }else{
            super.setValue(value, forKey: key)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
