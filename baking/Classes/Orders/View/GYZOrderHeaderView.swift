//
//  GYZOrderHeaderView.swift
//  baking
//  订单header
//  Created by gouyz on 2017/3/29.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZOrderHeaderView: UITableViewHeaderFooterView {
    
    /// 填充数据
    var dataModel : GYZOrderInfoModel?{
        didSet{
            if let model = dataModel {
                
                let businessModel = model.member_info
                nameLab.text = businessModel?.company_name
                let oiStatus: String = model.status!
                var statusTxt = "待付款"
                if oiStatus == "2" {
                    statusTxt = "已取消"
                }else if oiStatus == "3"{
                    statusTxt = "货到付款"
                }else if oiStatus == "4"{
                    statusTxt = "待收货"
                }else if oiStatus == "5"{
                    statusTxt = "已签收"
                }else if oiStatus == "1"{
                    statusTxt = "已付款"
                }else if oiStatus == "6"{
                    statusTxt = "已退款"
                }else if oiStatus == "7"{
                    statusTxt = "交易成功"
                }else if oiStatus == "8"{
                    statusTxt = "不接单"
                }
                statusLab.text = statusTxt
            }
        }
    }
    
    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        bgView.backgroundColor = kWhiteColor
        contentView.addSubview(bgView)
        bgView.addSubview(statusLab)
        bgView.addSubview(nameLab)
        bgView.addSubview(lineView)
        bgView.addSubview(rightIconView)
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(kMargin, 0, 0, 0))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(bgView)
            make.right.equalTo(statusLab.snp.left).offset(-5)
            make.bottom.equalTo(bgView).offset(-klineWidth)
        }
        statusLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(nameLab)
            make.right.equalTo(rightIconView.snp.left).offset(-5)
            make.size.equalTo(CGSize.init(width: 60, height: 30))
        }
        rightIconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView)
            make.right.equalTo(bgView).offset(-5)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(bgView)
            make.height.equalTo(klineWidth)
        }
    }
    fileprivate lazy var bgView : UIView  = UIView()
    /// 订单状态
    lazy var statusLab : UILabel = {
        let lab = UILabel()
        lab.font = k14Font
        lab.textColor = kYellowFontColor
        
        return lab
    }()
    /// 店铺名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k14Font
        lab.textColor = kBlackFontColor
        
        return lab
    }()
    fileprivate lazy var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    /// 右侧箭头图标
    fileprivate lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_gray"))
    
}
