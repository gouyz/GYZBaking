//
//  GYZHomeRedPacketCell.swift
//  baking
//  首页领取红包cell
//  Created by gouyz on 2017/9/12.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZHomeRedPacketCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : GYZRedPacketInfoModel?{
        didSet{
            if let model = dataModel {
                //设置数据
                let discount: Int = Int.init(Double.init(model.discount_amount!)!)
                let str = "￥\(discount)"
                let price : NSMutableAttributedString = NSMutableAttributedString(string: str)
                price.addAttribute(NSFontAttributeName, value: k13Font, range: NSMakeRange(0, 1))
                
                moneyLab.attributedText = price
                
                contentLab.text = "满\(Int.init(Double.init(model.use_amount!)!))元可用"
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kRedPacketBgColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(bgView)
        bgView.addSubview(leftBgImgView)
        leftBgImgView.addSubview(moneyLab)
        
        bgView.addSubview(rightView)
        rightView.addSubview(imgView)
        rightView.addSubview(contentLab)
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(contentView)
            make.bottom.equalTo(-kMargin)
        }
        leftBgImgView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(bgView)
            make.width.equalTo(100)
        }
        
        moneyLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(leftBgImgView)
            make.left.equalTo(leftBgImgView).offset(kMargin)
            make.right.equalTo(leftBgImgView).offset(-20)
        }
        
//        bgView.frame = CGRect.init(x: 100, y: 0, width: 140, height: 60)
//        bgView.roundingCorners(byRoundingCorners: [.topRight,.bottomRight], radius: kCornerRadius)
//        
        
        rightView.snp.makeConstraints { (make) in
            make.left.equalTo(leftBgImgView.snp.right)
            make.top.bottom.right.equalTo(bgView)
        }
        imgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(rightView)
            make.top.equalTo(rightView).offset(5)
            make.size.equalTo(CGSize.init(width: 100, height: 25))
        }
        contentLab.snp.makeConstraints { (make) in
            make.top.equalTo(imgView.snp.bottom).offset(5)
            make.left.equalTo(imgView.snp.left).offset(-kMargin)
            make.right.equalTo(imgView.snp.right).offset(kMargin)
            make.height.equalTo(20)
        }
        
    }
    //左侧背景
    var leftBgImgView:  UIImageView = UIImageView.init(image: UIImage.init(named: "icon_redpacket_cell_bg"))
    
    /// 金额
    lazy var moneyLab : UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 24.0)
        lab.textColor = kRedFontColor
        lab.textAlignment = .center
        
        return lab
    }()
    
    var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kRedPacketBgColor
        view.cornerRadius = kCornerRadius
        
        return view
    }()
    
    var rightView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    ///优惠券文字图片
    var imgView:  UIImageView = UIImageView.init(image: UIImage.init(named: "icon_youhuiquan"))

    /// 满多少可用
    var contentLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kWhiteColor
        lab.text = "满100元可用"
        lab.textAlignment = .center
        
        lab.backgroundColor = kRedPacketBgColor
        lab.cornerRadius = 10
        
        return lab
    }()
}
