//
//  GYZMineCell.swift
//  baking
//  我的 cell
//  Created by gouyz on 2017/3/30.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZMineCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(logoImgView)
        contentView.addSubview(nameLab)
        contentView.addSubview(rightIconView)
        
        logoImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        nameLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.left.equalTo(logoImgView.snp.right).offset(kMargin)
            make.right.equalTo(rightIconView.snp.left).offset(-kMargin)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-5)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
    }
    
    /// 商品图片
    lazy var logoImgView : UIImageView = UIImageView()
    /// 商品名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        
        return lab
    }()
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_gray"))
}
