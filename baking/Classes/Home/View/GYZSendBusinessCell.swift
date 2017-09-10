//
//  GYZSendBusinessCell.swift
//  baking
//  配送商家cell
//  Created by gouyz on 2017/3/26.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import Cosmos

class GYZSendBusinessCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : GYZShopModel?{
        didSet{
            if let model = dataModel {
                //设置数据
                logoImg.kf.setImage(with: URL.init(string: model.logo!), placeholder: UIImage.init(named: "icon_logo_default"), options: nil, progressBlock: nil, completionHandler: nil)
                
                nameLab.text = model.company_name
                let str = "￥\(model.send_price!)起送"
                let price : NSMutableAttributedString = NSMutableAttributedString(string: str)
                price.addAttribute(NSFontAttributeName, value: k13Font, range: NSMakeRange(str.characters.count-2, 2))
                price.addAttribute(NSForegroundColorAttributeName, value: kGaryFontColor, range: NSMakeRange(str.characters.count-2, 2))
                
                priceLab.attributedText = price
                ratingView.rating = Double.init(model.star!)!
                
                var name: String = ""
                if model.activity != nil && model.activity?.count > 0 {
                    for item in model.activity! {
                        name += item.level_name! + "\n"
                    }
                    name = name.substring(to: name.index(name.startIndex, offsetBy: name.characters.count - 1))
                    activityLab.snp.updateConstraints({ (make) in
                        make.height.equalTo(60)
                    })
                }
                
                activityLab.text = name
                
                var time = model.time!
                if time.isEmpty {
                    time = "0"
                }
//                var distance = model.distance!
//                if distance.isEmpty {
//                    distance = "0m"
//                }
                timeLab.text = "\(time)分钟"
                saleLab.text = "月销\(model.month_num!)单"
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(logoImg)
        contentView.addSubview(nameLab)
        contentView.addSubview(priceLab)
        contentView.addSubview(ratingView)
        contentView.addSubview(activityLab)
        contentView.addSubview(timeLab)
        contentView.addSubview(saleLab)
        
        logoImg.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(kMargin)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
        }
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(logoImg.snp.right).offset(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(priceLab.snp.left).offset(-kMargin)
            make.height.equalTo(20)
        }
        priceLab.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-kMargin)
            make.top.height.equalTo(nameLab)
            make.width.equalTo(100)
        }
        ratingView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.size.equalTo(CGSize.init(width: 100, height: 20))
        }
        
        saleLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.size.equalTo(ratingView)
            make.top.equalTo(ratingView.snp.bottom)
        }
        timeLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.top.equalTo(saleLab.snp.bottom)
            make.width.equalTo(ratingView)
            make.bottom.equalTo(-kMargin)
        }
        activityLab.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-5)
            make.left.equalTo(ratingView.snp.right).offset(kMargin)
            make.bottom.equalTo(timeLab)
            make.height.equalTo(0)
        }
        
    }
    ///商家logo
    lazy var logoImg: UIImageView = {
        let img = UIImageView()
        
        img.image = UIImage.init(named: "icon_logo_default")
        img.borderWidth = klineWidth
        img.borderColor = kGrayLineColor
        img.cornerRadius = kCornerRadius
        
        return img
    }()
    
    ///店铺名称
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        return lab
    }()
    
    ///起送价格
    lazy var priceLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kYellowFontColor
        lab.textAlignment = .right
        
        return lab
    }()
    ///星星评分
    lazy var ratingView: CosmosView = {
       
        let ratingStart = CosmosView()
        ratingStart.settings.updateOnTouch = false
        ratingStart.settings.fillMode = .precise
        ratingStart.settings.filledColor = kYellowFontColor
        ratingStart.settings.emptyBorderColor = kYellowFontColor
        ratingStart.settings.filledBorderColor = kYellowFontColor
        ratingStart.settings.starMargin = 3
        ratingStart.rating = 4.5
        
        return ratingStart
        
    }()
    
    ///活动
    lazy var activityLab: UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kRedFontColor
        lab.numberOfLines = 0
        
        return lab
    }()
    
    ///配送时间、距离
    lazy var timeLab: UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kGaryFontColor
        return lab
    }()
    ///月销量
    lazy var saleLab: UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kGaryFontColor
        return lab
    }()
}
