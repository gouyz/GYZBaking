//
//  GYZMyRedPacketCell.swift
//  baking
//  我的红包cell
//  Created by gouyz on 2017/9/12.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZMyRedPacketCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kBackgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(bgImgView)
        bgImgView.addSubview(moneyLab)
        bgImgView.addSubview(nameLab)
        bgImgView.addSubview(contentLab)
        bgImgView.addSubview(lineView)
        bgImgView.addSubview(dateLab)
        bgImgView.addSubview(userLab)
        
        bgImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(kMargin)
            make.bottom.equalTo(contentView)
        }
        
        moneyLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(bgImgView)
            make.size.equalTo(CGSize.init(width: 100, height: 50))
        }
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(moneyLab.snp.right).offset(5)
            make.right.equalTo(-kMargin)
            make.top.equalTo(moneyLab)
            make.height.equalTo(30)
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.height.equalTo(20)
            make.width.equalTo(100)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(moneyLab)
            make.right.equalTo(nameLab)
            make.top.equalTo(moneyLab.snp.bottom).offset(5)
            make.height.equalTo(klineWidth)
        }
        
        dateLab.snp.makeConstraints { (make) in
            make.left.equalTo(moneyLab)
            make.bottom.equalTo(bgImgView)
            make.top.equalTo(lineView.snp.bottom)
            make.right.equalTo(userLab.snp.left).offset(-kMargin)
            make.width.equalTo(userLab)
        }
        userLab.snp.makeConstraints { (make) in
            make.right.equalTo(lineView)
            make.bottom.top.width.equalTo(dateLab)
        }
        
        let str = "￥100"
        let price : NSMutableAttributedString = NSMutableAttributedString(string: str)
        price.addAttribute(NSFontAttributeName, value: k13Font, range: NSMakeRange(0, 1))
        
        moneyLab.attributedText = price
    }
    
    //背景
    var bgImgView:  UIImageView = UIImageView.init(image: UIImage.init(named: "icon_my_redpacket_cell_bg"))
    
    /// 金额
    var moneyLab : UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 24.0)
        lab.textColor = kRedFontColor
        lab.textAlignment = .center
        
        return lab
    }()
    
    /// 红包名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "通用红包"
        
        return lab
    }()
    /// 满多少可用
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kWhiteColor
        lab.text = "满1000元可用"
        lab.textAlignment = .center
        
        lab.backgroundColor = kRedPacketBgColor
        lab.cornerRadius = 10
        
        return lab
    }()
    /// 分割线
    fileprivate var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
    /// 有效期
    var dateLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kGaryFontColor
        lab.text = "有效期至2017.10.11"
        
        return lab
    }()
    
    /// 使用者
    var userLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kGaryFontColor
        lab.text = "仅限15245678911使用"
        
        return lab
    }()

}
