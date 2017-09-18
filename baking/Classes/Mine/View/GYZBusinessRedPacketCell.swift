//
//  GYZBusinessRedPacketCell.swift
//  baking
//  商家红包cell
//  Created by gouyz on 2017/9/12.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZBusinessRedPacketCell: UITableViewCell {

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
                
                nameLab.text = model.company_name
                contentLab.text = model.title//"满\(Int.init(Double.init(model.use_amount!)!))元可用"
                
                dateLab.text = "有效期至" + (model.end_time?.getDateTime(format: "yyyy.MM.dd"))!
            }
        }
    }
    
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
        
        bgImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(kMargin)
            make.bottom.equalTo(contentView)
        }
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(20)
            make.height.equalTo(30)
            make.right.equalTo(lineView.snp.left).offset(-kMargin)
        }
        dateLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.height.equalTo(20)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.right.equalTo(moneyLab.snp.left).offset(-kMargin)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
            make.width.equalTo(klineWidth)
        }
        
        moneyLab.snp.makeConstraints { (make) in
            make.top.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.size.equalTo(CGSize.init(width: 100, height: 50))
        }
        contentLab.snp.makeConstraints { (make) in
            make.top.equalTo(moneyLab.snp.bottom)
            make.right.equalTo(moneyLab)
            make.size.equalTo(CGSize.init(width: 100, height: 20))
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
    
    /// 有效期
    var dateLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kGaryFontColor
        lab.text = "有效期至2017.10.11"
        
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

}
