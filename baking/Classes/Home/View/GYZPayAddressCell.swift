//
//  GYZPayAddressCell.swift
//  baking
//  结算地址cell
//  Created by gouyz on 2017/4/4.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZPayAddressCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(contractLab)
        contentView.addSubview(addressLab)
        contentView.addSubview(desLab)
        contentView.addSubview(rightIconView)
        
        desLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.right.equalTo(contentView)
            make.height.equalTo(kTitleHeight)
        }
        contractLab.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(kMargin)
            make.right.equalTo(rightIconView.snp.left).offset(-5)
            make.top.equalTo(contentView).offset(kMargin)
            make.height.equalTo(20)
        }
        addressLab.snp.makeConstraints { (make) in
            make.top.equalTo(contractLab.snp.bottom)
            make.left.right.equalTo(contractLab)
            make.bottom.equalTo(contentView).offset(-kMargin)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-kMargin)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
    }
    /// 描述
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "请及时添加地址"
        lab.textAlignment = .center
        
        return lab
    }()
    /// 联系方式
    lazy var contractLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "华先生 1929324920"
        
        return lab
    }()
    /// 地址
    lazy var addressLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "高科荣域 9甲1201"
        
        return lab
    }()
    /// 右侧箭头图标
    fileprivate lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_gray"))
}
