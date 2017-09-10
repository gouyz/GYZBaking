//
//  GYZCartCell.swift
//  baking
//
//  Created by gouyz on 2017/7/10.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZCartCell: UITableViewCell {
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    
    func configureUI() {
        contentView.addSubview(discountLab)
        contentView.addSubview(nameLab)
        contentView.addSubview(numLab)
        contentView.addSubview(priceLab)
        contentView.addSubview(minusBtn)
        contentView.addSubview(plusBtn)
        
        
        nameLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.left.equalTo(kMargin)
            make.width.equalTo(kScreenWidth * 0.3)
        }
        discountLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab.snp.right).offset(5)
            make.top.bottom.equalTo(nameLab)
            make.width.equalTo(60)
        }
        priceLab.snp.makeConstraints { (make) in
            make.left.equalTo(discountLab.snp.right).offset(5)
            make.top.bottom.equalTo(discountLab)
            make.right.equalTo(minusBtn.snp.left).offset(-5)
        }
        minusBtn.snp.makeConstraints { (make) in
            make.right.equalTo(numLab.snp.left)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 25, height: 25))
        }
        numLab.snp.makeConstraints { (make) in
            make.width.equalTo(20)
            make.top.bottom.equalTo(nameLab)
            make.right.equalTo(plusBtn.snp.left)
        }
        plusBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.size.equalTo(minusBtn)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///商品名称
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.text = "拾味"
        return lab
    }()
    
    ///优惠
    lazy var discountLab: UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kGaryFontColor
        
        return lab
    }()
    ///实际价格
    lazy var priceLab: UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kRedFontColor
        return lab
    }()
    
    /// 减号
    lazy var minusBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "icon_minus"), for: .normal)
        
        return btn
    }()
    ///数量
    lazy var numLab: UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.text = "1"
        return lab
    }()
    /// 加号
    lazy var plusBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "icon_plus"), for: .normal)
        
        return btn
    }()


}
