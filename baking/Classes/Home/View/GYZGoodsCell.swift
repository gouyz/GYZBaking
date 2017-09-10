//
//  GYZGoodsCell.swift
//  baking
//  商品cell
//  Created by gouyz on 2017/3/30.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import Kingfisher

class GYZGoodsCell: UITableViewCell {
    var delegate: GYZGoodsCellDelegate?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    func setDatas(_ model : GoodInfoModel) {
        
        nameLab.text = model.cn_name
        
        logoImg.kf.setImage(with: URL.init(string: model.goods_thumb_img!), placeholder: UIImage(named: "icon_logo_default"), options: nil, progressBlock: nil, completionHandler: nil)
        
        if model.attr != nil && model.attr?.count > 0 {
            let attrModel = model.attr?[0]
            priceLab.text = "￥" + (attrModel?.price)!
            saleLab.text = "月售\(model.month_num!)单   库存\((attrModel?.count)!)\((attrModel?.attr_name)!)"
            if (attrModel?.count?.isEmpty)! || attrModel?.count == "0" {
                plusBtn.isHidden = true
            }else{
                plusBtn.isHidden = false
            }
        }else{
            saleLab.text = "月售\(model.month_num!)单"
        }
        
        var discountStr: String = ""
        if model.preferential_type == "1" {///0无优惠 1立减 2打折
            discountStr += "立减￥" + model.preferential_price!
        }else if model.preferential_type == "2" {///0无优惠 1立减 2打折
            discountStr +=  model.preferential_price! + "折"
        }
        
        ///限制购买数量
//        let preBuyNum: Int = Int.init((model.preferential_buy_num)!)!
////        let buyNum: Int = Int.init((model.buy_num)!)!
//        if preBuyNum > 0 {
//            discountStr += " 限购\(preBuyNum)"
//        }
        
        discountLab.text = discountStr
        minusBtn.accessibilityIdentifier = model.id
        plusBtn.accessibilityIdentifier = model.id
    }
    
    func configureUI() {
        contentView.addSubview(logoImg)
        contentView.addSubview(nameLab)
        contentView.addSubview(saleLab)
        contentView.addSubview(priceLab)
        contentView.addSubview(discountLab)
        contentView.addSubview(minusBtn)
        contentView.addSubview(numLab)
        contentView.addSubview(plusBtn)
        
        
        logoImg.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(kMargin)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
        }
        
        nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(logoImg)
            make.left.equalTo(logoImg.snp.right).offset(kMargin)
            make.right.equalTo(contentView).offset(-kMargin)
            make.height.equalTo(kStateHeight)
        }
        
        saleLab.snp.makeConstraints { (make) in
            make.left.height.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.right.equalTo(nameLab)
        }
        priceLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(logoImg)
            make.left.equalTo(nameLab)
            make.top.equalTo(saleLab.snp.bottom)
            make.right.equalTo(saleLab)
        }
        discountLab.snp.makeConstraints { (make) in
            make.top.equalTo(priceLab.snp.bottom)
            make.left.right.height.equalTo(priceLab)
        }
        plusBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.bottom.equalTo(-kMargin)
            make.size.equalTo(CGSize.init(width: 25, height: 25))
        }
        numLab.snp.makeConstraints { (make) in
            make.right.equalTo(plusBtn.snp.left)
            make.bottom.height.equalTo(plusBtn)
            make.width.equalTo(20)
        }
        minusBtn.snp.makeConstraints { (make) in
            make.right.equalTo(numLab.snp.left)
            make.bottom.size.equalTo(plusBtn)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///商家logo
    lazy var logoImg: UIImageView = {
        let img = UIImageView()
        
        img.image = UIImage(named: "icon_logo_default")
        img.borderWidth = klineWidth
        img.borderColor = kGrayLineColor
        img.cornerRadius = kCornerRadius
        
        return img
    }()
    
    ///商品名称
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "拾味"
        return lab
    }()
    
    ///价格
    lazy var priceLab: UILabel = {
        let lab = UILabel()
        lab.font = k18Font
        lab.textColor = kYellowFontColor
        lab.text = "￥30"
        
        return lab
    }()
    ///优惠
    lazy var discountLab: UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kRedFontColor
        lab.text = "立减10元"
        
        return lab
    }()
    ///月售量
    lazy var saleLab: UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kGaryFontColor
        lab.text = "月售1333单"
        return lab
    }()

    /// 减号
    lazy var minusBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "icon_minus"), for: .normal)
        btn.addTarget(self, action: #selector(clickedMinusBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    ///数量
    lazy var numLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.text = "1"
        return lab
    }()
    /// 加号
    lazy var plusBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "icon_plus"), for: .normal)
        btn.addTarget(self, action: #selector(clickedPlusBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    /// 减号
    func clickedMinusBtn(btn: UIButton){
        delegate?.didClickMinusBtn(goodsId: btn.accessibilityIdentifier!)
    }
    /// 加号
    func clickedPlusBtn(btn: UIButton){
        delegate?.didClickPlusBtn(goodsId: btn.accessibilityIdentifier!)
    }
}
protocol GYZGoodsCellDelegate: NSObjectProtocol {
    /// 点击减号
    ///
    /// - Parameter goodsId: 商品ID
    func didClickMinusBtn(goodsId: String)
    /// 点击加号
    ///
    /// - Parameter goodsId: 商品ID
    func didClickPlusBtn(goodsId: String)
}
