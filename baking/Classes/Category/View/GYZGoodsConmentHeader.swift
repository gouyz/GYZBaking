//
//  GYZGoodsConmentHeader.swift
//  baking
//  商家评论header
//  Created by gouyz on 2017/4/17.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZGoodsConmentHeader: UITableViewHeaderFooterView {

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
        bgView.addSubview(nameLab)
        bgView.addSubview(desLab)
        bgView.addSubview(rightIconView)
        bgView.addSubview(lineView)
        rightIconView.isHidden = true
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(kMargin)
        }
        
        nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(bgView)
            make.left.equalTo(kMargin)
            make.bottom.equalTo(lineView.snp.top)
            make.right.equalTo(desLab.snp.left).offset(-kMargin)
        }
        desLab.snp.makeConstraints { (make) in
            make.right.equalTo(rightIconView.snp.left)
            make.top.height.equalTo(nameLab)
            make.width.equalTo(100)
        }
        
        rightIconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView)
            make.right.equalTo(-5)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(bgView)
            make.height.equalTo(klineWidth)
        }
    }
    
    fileprivate lazy var bgView: UIView = UIView()
    /// 店铺名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "商品评价"
        
        return lab
    }()
    /// 评论日期
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kGaryFontColor
//        lab.text = "查看全部评价"
        lab.textAlignment = .right
        
        return lab
    }()
    /// 右侧箭头图标
    fileprivate lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_gray"))
    
    fileprivate lazy var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
}
