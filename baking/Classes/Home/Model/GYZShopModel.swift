//
//  GYZShopModel.swift
//  baking
//  商家model
//  Created by gouyz on 2017/4/5.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZShopModel: NSObject {
    /// 商店ID
    var id : String?
    /// 商店名
    var company_name : String?
    /// 月销售
    var month_num : String?
    ///  	起送价格
    var send_price : String?
    /// 星级
    var star : String?
    /// 送达时间
    var time : String?
    /// logo
    var logo : String?
    ///距离
    var distance: String?
    ///收藏ID
    var collect_id: String?
    
    var activity: [ActivityModel]?
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        if key == "activity"{
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

///商家活动model
class ActivityModel: NSObject {
    
    var level_id : String?
    ///
    var amount : String?
    /// 活动名称
    var level_name : String?
    /// 时间
    var add_time : String?
    ///
    var is_deleted : String?
    ///
    var discount : String?
    
    
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
