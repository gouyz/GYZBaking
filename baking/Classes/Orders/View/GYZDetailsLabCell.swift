//
//  GYZDetailsLabCell.swift
//  baking
//
//  Created by gouyz on 2017/3/30.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZDetailsLabCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        bgView.backgroundColor = kWhiteColor
        contentView.addSubview(bgView)
        bgView.addSubview(desLab)
        bgView.addSubview(backLab)
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        desLab.snp.makeConstraints { (make) in
            make.top.equalTo(bgView)
            make.left.equalTo(bgView).offset(kMargin)
            make.right.equalTo(bgView).offset(-kMargin)
            make.bottom.equalTo(backLab.snp.top)
        }
        backLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(bgView).offset(-5)
            make.right.left.equalTo(desLab)
            make.height.equalTo(0)
        }
    }
    fileprivate lazy var bgView : UIView  = UIView()
    /// 描述
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        lab.text = "不粘面包烤盘"
        
        return lab
    }()
    /// 描述
    lazy var backLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kRedFontColor
        lab.textAlignment = .right
        
        return lab
    }()
}
