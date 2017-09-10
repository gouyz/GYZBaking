//
//  GYZProfileFooterView.swift
//  baking
//  个人资料footer
//  Created by gouyz on 2017/3/31.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZProfileFooterView: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(loginOutBtn)
        
        loginOutBtn.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(kMargin)
            make.right.equalTo(contentView).offset(-kMargin)
            make.centerY.equalTo(contentView)
            make.height.equalTo(kTitleHeight)
        }
    }
    /// 退出当前账号
    lazy var loginOutBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.cornerRadius = kCornerRadius
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("退出当前账号", for: .normal)
    
        return btn
    }()

}
