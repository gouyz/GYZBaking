//
//  GYZBusinessDynamicCell.swift
//  baking
//
//  Created by gouyz on 2017/4/4.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZBusinessDynamicCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(lineView1)
        contentView.addSubview(nameLab)
        contentView.addSubview(lineView2)
        contentView.addSubview(contentLab)
        
        lineView1.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(nameLab)
            make.right.equalTo(nameLab.snp.left)
            make.height.equalTo(klineWidth)
        }
        
        nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.centerX.equalTo(contentView)
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
        lineView2.snp.makeConstraints { (make) in
            make.right.equalTo(kMargin)
            make.centerY.equalTo(nameLab)
            make.left.equalTo(nameLab.snp.right)
            make.height.equalTo(klineWidth)
        }
        contentLab.snp.makeConstraints { (make) in
            make.top.equalTo(nameLab.snp.bottom)
            make.left.equalTo(lineView1)
            make.right.equalTo(lineView2)
            make.bottom.equalTo(contentView)
        }
    }
    
    /// 线
    fileprivate lazy var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    /// cell title
    fileprivate lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        lab.text = "本店说说"
        
        return lab
    }()
    /// 线
    fileprivate lazy var lineView2 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    
    /// 说说内容
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.numberOfLines = 2
        lab.textColor = kBlackFontColor
        lab.text = "店主说：拾味，生活就要精致"
        
        return lab
    }()
}
