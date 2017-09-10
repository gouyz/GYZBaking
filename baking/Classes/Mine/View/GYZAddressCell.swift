//
//  GYZAddressCell.swift
//  baking
//  收货地址cell
//  Created by gouyz on 2017/4/2.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZAddressCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(deleteIconView)
        contentView.addSubview(contractLab)
        contentView.addSubview(addressLab)
        contentView.addSubview(editIconView)
        
        deleteIconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(kMargin)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        contractLab.snp.makeConstraints { (make) in
            make.left.equalTo(deleteIconView.snp.right).offset(5)
            make.right.equalTo(editIconView.snp.left).offset(-5)
            make.top.equalTo(contentView).offset(kMargin)
            make.height.equalTo(kStateHeight)
        }
        addressLab.snp.makeConstraints { (make) in
            make.top.equalTo(contractLab.snp.bottom)
            make.left.right.height.equalTo(contractLab)
        }
        editIconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-kMargin)
            make.size.equalTo(deleteIconView)
        }
    }

    /// 左侧删除图标
    lazy var deleteIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_address_delete"))
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
    /// 右侧编辑图标
    lazy var editIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_address_edit"))
    
    /// 填充数据
    var dataModel : GYZAddressModel?{
        didSet{
            if let model = dataModel {
                //设置数据
            
                contractLab.text = model.consignee! + "  " + model.tel!
                addressLab.text = model.area! + model.address!
                
                if model.is_default == "1" {
                    contractLab.textColor = kYellowFontColor
                    addressLab.textColor = kYellowFontColor
                }else{
                    contractLab.textColor = kBlackFontColor
                    addressLab.textColor = kBlackFontColor
                }
            }
        }
    }
}
