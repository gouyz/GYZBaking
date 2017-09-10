//
//  GYZBusinessConmentHeaderView.swift
//  baking
//  店铺评论 header
//  Created by gouyz on 2017/4/2.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZBusinessConmentHeaderView: UITableViewHeaderFooterView {

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
        bgView.addSubview(timeLab)
        bgView.addSubview(logoImgView)
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        logoImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView)
            make.left.equalTo(bgView).offset(kMargin)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(logoImgView.snp.right).offset(kMargin)
            make.top.bottom.equalTo(logoImgView)
            make.right.equalTo(timeLab.snp.left).offset(-5)
        }
        timeLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(bgView)
            make.width.equalTo(80)
        }
    }
    fileprivate lazy var bgView : UIView  = UIView()
    /// 用户图片
    lazy var logoImgView : UIImageView = {
        let view = UIImageView()
        view.borderColor = kGrayLineColor
        view.borderWidth = klineWidth
        view.cornerRadius = 20
        view.contentMode = .scaleAspectFill
        view.image = UIImage.init(named: "icon_goods_default")
        
        return view
    }()
    /// 用户昵称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k14Font
        lab.textColor = kBlackFontColor
        lab.text = "杨*姐"
        
        return lab
    }()
    /// 评论日期
    lazy var timeLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kGaryFontColor
        lab.text = "2017/03/08"
        lab.textAlignment = .right
        
        return lab
    }()

}
