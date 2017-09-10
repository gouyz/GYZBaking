//
//  GYZBusinessConmentModel.swift
//  baking
//  商家评论或商品详情评论
//  Created by gouyz on 2017/4/17.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZBusinessConmentModel: NSObject {

    ///评列ID
    var com_id : String?
    /// 用户ID
    var user_id : String?
    /// 商户ID
    var member_id : String?
    /// 内容
    var content : String?
    /// 图片分号隔开
    var img : String?
    /// 添加时间
    var add_time : String?
    /// 星级
    var star_num : String?
    ///  	用户头像
    var head_img : String?
    /// 用户名
    var username : String?
    
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
