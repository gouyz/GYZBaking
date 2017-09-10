//
//  GYZMineConmentHeaderView.swift
//  baking
//  我的评价header
//  Created by gouyz on 2017/4/2.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZMineConmentHeaderView: UITableViewHeaderFooterView {
    
    /// 填充数据
    var dataModel : GYZMineConmentModel?{
        didSet{
            if let model = dataModel {
                //设置数据
                logoImgView.kf.setImage(with: URL.init(string: ""), placeholder: UIImage.init(named: "icon_logo_default"), options: nil, progressBlock: nil, completionHandler: nil)
                
                nameLab.text = model.member_info?.company_name
                timeLab.text = model.add_time?.dateFromTimeInterval()?.dateToStringWithFormat(format: "yyyy/MM/dd HH:mm:ss")
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
        bgView.addSubview(nameLab)
        bgView.addSubview(timeLab)
        bgView.addSubview(lineView)
        bgView.addSubview(rightIconView)
        bgView.addSubview(logoImgView)
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        logoImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView)
            make.left.equalTo(bgView).offset(kMargin)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(logoImgView.snp.right).offset(kMargin)
            make.top.equalTo(logoImgView)
            make.right.equalTo(rightIconView.snp.left).offset(-5)
            make.height.equalTo(18)
        }
        timeLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.height.equalTo(12)
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
    /// 商家图片
    lazy var logoImgView : UIImageView = {
        let view = UIImageView()
        view.borderColor = kGrayLineColor
        view.borderWidth = klineWidth
        view.cornerRadius = kCornerRadius
        view.contentMode = .scaleAspectFill
        view.image = UIImage.init(named: "icon_logo_default")
        
        return view
    }()
    /// 店铺名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k14Font
        lab.textColor = kBlackFontColor
        lab.text = "杨小姐的烘焙店"
        
        return lab
    }()
    /// 评论日期
    lazy var timeLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kGaryFontColor
        lab.text = "2017/03/08"
        
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
