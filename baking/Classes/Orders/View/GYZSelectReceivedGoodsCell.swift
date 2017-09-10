//
//  GYZSelectReceivedGoodsCell.swift
//  baking
//  选择收货商品cell
//  Created by gouyz on 2017/6/8.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZSelectReceivedGoodsCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(checkBtn)
        contentView.addSubview(logoImgView)
        contentView.addSubview(nameLab)
        
        checkBtn.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        logoImgView.snp.makeConstraints { (make) in
            make.left.equalTo(checkBtn.snp.right).offset(kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        nameLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(logoImgView)
            make.left.equalTo(logoImgView.snp.right).offset(kMargin)
            make.right.equalTo(-kMargin)
        }
    }
    
    /// 选择图标
    lazy var checkBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "icon_pay_check_normal"), for: .normal)
        btn.setImage(UIImage.init(named: "icon_pay_check_selected"), for: .selected)
        return btn
    }()
    
    /// 商品图片
    lazy var logoImgView : UIImageView = {
        let view = UIImageView()
        view.borderColor = kGrayLineColor
        view.borderWidth = klineWidth
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    /// 商品名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k14Font
        lab.textColor = kBlackFontColor
        
        return lab
    }()

}
