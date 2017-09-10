//
//  GYZPayNoteCell.swift
//  baking
//  结算备注
//  Created by gouyz on 2017/4/4.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZPayNoteCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(noteTxtView)
        contentView.addSubview(desLab)
        
        desLab.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.left.equalTo(kMargin)
            make.width.equalTo(kTitleHeight)
            make.height.equalTo(kTitleHeight)
        }
        noteTxtView.snp.makeConstraints { (make) in
            make.left.equalTo(desLab.snp.right)
            make.bottom.equalTo(contentView)
            make.top.equalTo(contentView).offset(5)
            make.right.equalTo(-kMargin)
        }
    }
    /// 描述
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "备注"
        
        return lab
    }()
    /// 备注
    lazy var noteTxtView : UITextView = {
        let txtView = UITextView()
        txtView.textColor = kGaryFontColor
        txtView.font = k15Font
        txtView.text = "最多50字哦"
        
        return txtView
    }()

}
