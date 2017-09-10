//
//  GYZShopGoodsSearchCell.swift
//  baking
//  店内商品搜索cell
//  Created by gouyz on 2017/5/27.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZShopGoodsSearchCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    func setDatas(_ model : GoodInfoModel) {
        
        nameLab.text = model.cn_name
        
        logoImg.kf.setImage(with: URL.init(string: model.goods_thumb_img!), placeholder: UIImage(named: "icon_logo_default"), options: nil, progressBlock: nil, completionHandler: nil)
        
    }
    
    func configureUI() {
        contentView.addSubview(logoImg)
        contentView.addSubview(nameLab)
        
        
        logoImg.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(kMargin)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        
        nameLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.left.equalTo(logoImg.snp.right).offset(kMargin)
            make.right.equalTo(contentView).offset(-kMargin)
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


}
