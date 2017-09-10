//
//  GYZChartBottomView.swift
//  baking
//  购物车底部
//  Created by gouyz on 2017/4/4.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZChartBottomView: UIView {

    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        
        addSubview(chartBtn)
        chartBtn.addSubview(badgeLab)
        addSubview(moneyLab)
        addSubview(payBtn)
        
        chartBtn.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(-10)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: kTitleHeight))
        }
        badgeLab.snp.makeConstraints { (make) in
            make.top.equalTo(chartBtn)
            make.right.equalTo(chartBtn)
            make.size.equalTo(CGSize.init(width: 16, height: 16))
        }
        moneyLab.snp.makeConstraints { (make) in
            make.left.equalTo(chartBtn.snp.right).offset(kMargin)
            make.top.bottom.equalTo(self)
            make.right.equalTo(payBtn.snp.left)
        }
        payBtn.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(self)
            make.width.equalTo(100)
        }
    }

    /// 购物车btn
    lazy var chartBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setBackgroundImage(UIImage.init(named: "icon_chart_normal"), for: .normal)
        btn.setBackgroundImage(UIImage.init(named: "icon_chart_disable"), for: .disabled)
        return btn
    }()
    ///选择商品的数量
    lazy var badgeLab: UILabel = {
        let lab = UILabel()
        lab.font = k10Font
        lab.textColor = kWhiteColor
        lab.text = "99"
        lab.backgroundColor = UIColor.red
        lab.textAlignment = .center
        lab.cornerRadius = 8
        
        return lab
    }()
    ///钱数
    lazy var moneyLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kYellowFontColor
        lab.text = "￥0"
        return lab
    }()
    /// 支付
    lazy var payBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kGrayLineColor
        btn.setTitle("￥20起送", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        
        return btn
    }()

}
