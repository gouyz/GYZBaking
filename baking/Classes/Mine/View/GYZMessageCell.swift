//
//  GYZMessageCell.swift
//  baking
//  消息cell
//  Created by gouyz on 2017/3/31.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZMessageCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kBackgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(timeIconView)
        contentView.addSubview(dateLab)
        contentView.addSubview(viewBg)
        viewBg.addSubview(contentLab)
        
        timeIconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(dateLab.snp.centerY)
            make.size.equalTo(CGSize.init(width: 15, height: 15))
        }
        dateLab.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.left.equalTo(timeIconView.snp.right).offset(5)
            make.right.equalTo(contentView).offset(-kMargin)
            make.height.equalTo(30)
        }
        viewBg.snp.makeConstraints { (make) in
            make.top.equalTo(dateLab.snp.bottom)
            make.right.equalTo(contentView).offset(-kMargin)
            make.left.equalTo(timeIconView)
            make.bottom.equalTo(contentView)
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(viewBg).offset(kMargin)
            make.right.equalTo(viewBg).offset(-kMargin)
            make.top.equalTo(viewBg).offset(5)
            make.bottom.equalTo(viewBg).offset(-5)
        }
    }
    
    fileprivate lazy var timeIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_time_tag"))
    
    /// 消息时间
    lazy var dateLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kGaryFontColor
        lab.text = "2016-10-01"
        
        return lab
    }()
    /// 内容背景
    fileprivate lazy var viewBg: UIView = {
       let view = UIView()
        view.backgroundColor = kWhiteColor
        view.cornerRadius = kCornerRadius
        
        return view
    }()
    /// 消息内容
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.numberOfLines = 0
        lab.text = "尊敬的客户尊敬的客户尊敬的客户"
        
        return lab
    }()
    
    /// 填充数据
    var dataModel : GYZMessageModel?{
        didSet{
            if let model = dataModel {
                dateLab.text = model.add_time?.dateFromTimeInterval()?.dateToStringWithFormat(format: "yyyy-MM-dd")
                contentLab.text = model.content
            }
        }
    }

}
