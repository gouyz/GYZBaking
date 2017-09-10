//
//  GYZMessageModel.swift
//  baking
//  消息model
//  Created by gouyz on 2017/5/1.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZMessageModel: NSObject {
    /// 	消息ID
    var msg_id : String?
    /// 用户ID
    var user_id : String?
    /// 内容
    var content : String?
    ///  添加时间
    var add_time : String?
    /// 0未读 1已读
    var is_read : String?
    
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
