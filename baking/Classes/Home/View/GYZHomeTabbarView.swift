//
//  GYZHomeTabbarView.swift
//  baking
//  home 导航栏自定义
//  Created by gouyz on 2017/3/23.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import SnapKit

class GYZHomeTabbarView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        addSubview(addressIconView)
        addSubview(addressLab)
        addSubview(rightIconView)
        
        addressIconView.snp.makeConstraints { (make) in
            make.right.equalTo(addressLab.snp.left)
            make.centerY.equalTo(addressLab.snp.centerY)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        addressLab.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(80)
            make.height.equalTo(kStateHeight)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.left.equalTo(addressLab.snp.right)
            make.size.equalTo(addressIconView)
            make.centerY.equalTo(addressIconView)
        }
        
    }
    /// 地址图标
    fileprivate lazy var addressIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_home_address"))
    /// 定位地址
    lazy var addressLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        
        return lab
    }()
    /// 右侧箭头图标
    fileprivate lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_white"))
}
