//
//  GYZMineHeaderView.swift
//  baking
//  我的 主页header
//  Created by gouyz on 2017/3/30.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZMineHeaderView: UIView {
    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        self.backgroundColor = kNavBarColor
        
        addSubview(headerImg)
        addSubview(userNameLab)
        addSubview(signedLab)
        addSubview(loginBtn)
        
        headerImg.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: 80, height: 80))
        }
        signedLab.snp.makeConstraints { (make) in
            make.top.equalTo(headerImg.snp.bottom).offset(-kMargin)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize.init(width: 60, height: 24))
        }
        userNameLab.snp.makeConstraints { (make) in
            make.top.equalTo(signedLab.snp.bottom).offset(5)
            make.left.equalTo(self).offset(kMargin)
            make.right.equalTo(self).offset(-kMargin)
            make.height.equalTo(30)
        }
        loginBtn.snp.makeConstraints { (make) in
            make.top.height.equalTo(userNameLab)
            make.centerX.equalTo(self)
            make.width.equalTo(80)
        }
    }
    /// 用户头像
    lazy var headerImg : UIImageView = {
        let img = UIImageView()
        img.cornerRadius = 40
        img.borderColor = kYellowFontColor
        img.borderWidth = klineDoubleWidth
        
        img.image = UIImage.init(named: "icon_headimg_default")
        
        return img
    }()
    
    /// 签约标志
    lazy var signedLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kWhiteColor
        lab.text = "签约"
        lab.textAlignment = .center
        lab.backgroundColor = kRedFontColor
        lab.cornerRadius = kCornerRadius
        lab.isHidden = true
        
        return lab
    }()
    
    /// 商家名称
    lazy var userNameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        
        return lab
    }()
    /// 登录/注册
    lazy var loginBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kWhiteColor
        btn.cornerRadius = kCornerRadius
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kYellowFontColor, for: .normal)
        btn.setTitle("登录/注册", for: .normal)
        
        return btn
    }()
}
