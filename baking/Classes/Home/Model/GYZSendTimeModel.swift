//
//  GYZSendTimeModel.swift
//  baking
//  配送时间model
//  Created by gouyz on 2017/4/30.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZSendTimeModel: NSObject {
    /// ID
    var time_id : String?
    /// 配送时间
    var delivery_time : String?
    
    
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
