//
//  GYZCategoryModel.swift
//  baking
//  分类model
//  Created by gouyz on 2017/4/5.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZCategoryModel: NSObject {

    /// 分类ID
    var class_id : String?
    /// 中文名
    var class_cn_name : String?
    /// 英文名
    var class_en_name : String?
    /// 图片
    var img : String?
    /// 颜色
    var color : String?
    
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
