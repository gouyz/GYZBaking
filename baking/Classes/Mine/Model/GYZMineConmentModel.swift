//
//  GYZMineConmentModel.swift
//  baking
//  我的评论model
//  Created by gouyz on 2017/4/9.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZMineConmentModel: NSObject {
    ///评列ID
    var com_id : String?
    /// 用户ID
    var user_id : String?
    /// 内容
    var content : String?
    /// 图片分号隔开
    var img : String?
    /// 添加时间
    var add_time : String?
    /// 星级
    var star_num : String?
    ///商家信息
    var member_info : OrderBusinessModel?
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "member_info" {
            
            guard let datas = value as? [String : Any] else { return }
            member_info = OrderBusinessModel.init(dict: datas)
            
        }else {
            super.setValue(value, forKey: key)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
