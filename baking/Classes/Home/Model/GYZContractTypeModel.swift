//
//  GYZContractTypeModel.swift
//  baking
//  联系我们 的联系类型model
//  Created by gouyz on 2017/5/5.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZContractTypeModel: NSObject {
    /// 类型ID
    var id : String?
    /// 类型名称
    var type_name : String?
    
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
