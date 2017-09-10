//
//  GYZBusinessProfileCell.swift
//  baking
//  店铺资料cell
//  Created by gouyz on 2017/4/2.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZBusinessProfileCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(desLab)
        contentView.addSubview(nameLab)
        
        nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView).offset(kMargin)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        desLab.snp.makeConstraints { (make) in
            make.top.height.equalTo(nameLab)
            make.right.equalTo(contentView).offset(-kMargin)
            make.left.equalTo(nameLab.snp.right).offset(kMargin)
        }
    }
    
    /// cell title
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        
        return lab
    }()
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kGaryFontColor
        lab.textAlignment = .right
        
        return lab
    }()

}
