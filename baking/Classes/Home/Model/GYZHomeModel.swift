//
//  GYZHomeModel.swift
//  baking
//  首页model
//  Created by gouyz on 2017/4/5.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZHomeModel: NSObject {
    
    var ad : [HomeAdsModel]?
    var img : [HomeImgModel]?
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "ad" {
            ad = [HomeAdsModel]()
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let adModel = HomeAdsModel(dict: dict)
                ad?.append(adModel)
            }
        }else if key == "img"{
            img = [HomeImgModel]()
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let imgModel = HomeImgModel(dict: dict)
                img?.append(imgModel)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

///
class HomeImgModel: NSObject {
    
    var id : String?
    /// 名称
    var title : String?
    /// 简介
    var sub_title : String?
    /// 图片
    var img : String?
    
    
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

class HomeAdsModel: NSObject {
    
    /// 图片
    var ad_img : String?
    ///  	链接
    var link : String?
    
    
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
