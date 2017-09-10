//
//  GYZOrderDetailCell.swift
//  baking
//  订单详情 商品cell
//  Created by gouyz on 2017/3/30.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZOrderDetailCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(nameLab)
        contentView.addSubview(tagImgView)
        contentView.addSubview(priceLab)
        contentView.addSubview(goodsCountLab)
        contentView.addSubview(discountLab)
        
        
        tagImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(kMargin)
            make.height.equalTo(20)
            make.width.equalTo(0)
        }
        nameLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.left.equalTo(tagImgView.snp.right).offset(5)
            make.right.equalTo(discountLab.snp.left).offset(-5)
        }
    
        discountLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(nameLab)
            make.right.equalTo(goodsCountLab.snp.left).offset(-3)
            make.width.equalTo(80)
        }
        goodsCountLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(nameLab)
            make.right.equalTo(priceLab.snp.left)
            make.width.equalTo(20)
        }
        priceLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(nameLab)
            make.right.equalTo(contentView).offset(-kMargin)
            make.width.equalTo(80)
        }
    }
    
    /// 商品名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k14Font
        lab.textColor = kBlackFontColor
        lab.text = "不粘面包烤盘"
        
        return lab
    }()
    /// 收货、退货标识
    lazy var tagImgView : UIImageView = UIImageView()
    /// 商品单价
    lazy var priceLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .right
        lab.text = "￥28"
        
        return lab
    }()
    /// 商品数量
    lazy var goodsCountLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kGaryFontColor
        lab.textAlignment = .center
        lab.text = "x1"
        
        return lab
    }()
    /// 优惠
    lazy var discountLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kRedFontColor
        lab.textAlignment = .center
        
        return lab
    }()
}
