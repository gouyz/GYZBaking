//
//  GYZSortModel.swift
//  baking
//  排序model
//  Created by gouyz on 2017/4/5.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZSortModel: NSObject {
    /// 排序ID
    var sort_id : String?
    /// 排序名称
    var name : String?
    
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
