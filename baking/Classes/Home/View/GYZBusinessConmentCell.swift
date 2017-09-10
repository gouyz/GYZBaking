//
//  GYZBusinessConmentCell.swift
//  baking
//  商家评论cell
//  Created by gouyz on 2017/4/17.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZBusinessConmentCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(conmentView)
        contentView.addSubview(nameLab)
        contentView.addSubview(timeLab)
        contentView.addSubview(logoImgView)
        
        logoImgView.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.left.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(logoImgView.snp.right).offset(kMargin)
            make.top.bottom.equalTo(logoImgView)
            make.right.equalTo(timeLab.snp.left).offset(-5)
        }
        timeLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(nameLab)
            make.width.equalTo(80)
        }
        
        conmentView.snp.makeConstraints { (make) in
            make.top.equalTo(logoImgView.snp.bottom).offset(5)
            make.left.right.bottom.equalTo(contentView)
        }
    }
    
    lazy var conmentView: GYZConmentView = GYZConmentView()
    
    /// 用户图片
    lazy var logoImgView : UIImageView = {
        let view = UIImageView()
        view.borderColor = kGrayLineColor
        view.borderWidth = klineWidth
        view.cornerRadius = 20
        view.contentMode = .scaleAspectFill
        view.image = UIImage.init(named: "icon_profile_header_default")
        
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
    /// 填充数据
    var dataModel : GYZBusinessConmentModel?{
        didSet{
            if let model = dataModel {
                
                logoImgView.kf.setImage(with: URL.init(string: model.head_img!), placeholder:  UIImage.init(named: "icon_profile_header_default"), options: nil, progressBlock: nil, completionHandler: nil)
                nameLab.text = model.username
                timeLab.text = model.add_time?.dateFromTimeInterval()?.dateToStringWithFormat(format: "yyyy/MM/dd")
                
                if let urlArr = GYZTool.getImgUrls(url: model.img){
                    
                    conmentView.imageViews.isHidden = false
                    conmentView.imageViews.snp.updateConstraints({ (make) in
                        make.height.equalTo(kBusinessImgHeight)
                    })
                    
                    for (index,item) in urlArr.enumerated() {
                        switch index {
                        case 1:
                            conmentView.imageViews.imgViewTwo.kf.setImage(with: URL.init(string: item), placeholder: UIImage.init(named: "icon_logo_default"), options: nil, progressBlock: nil, completionHandler: nil)
                        case 2:
                            conmentView.imageViews.imgViewThree.kf.setImage(with: URL.init(string: item), placeholder: UIImage.init(named: "icon_logo_default"), options: nil, progressBlock: nil, completionHandler: nil)
                        case 3:
                            conmentView.imageViews.imgViewFour.kf.setImage(with: URL.init(string: item), placeholder: UIImage.init(named: "icon_logo_default"), options: nil, progressBlock: nil, completionHandler: nil)
                        default:
                            conmentView.imageViews.imgViewOne.kf.setImage(with: URL.init(string: item), placeholder: UIImage.init(named: "icon_logo_default"), options: nil, progressBlock: nil, completionHandler: nil)
                        }
                    }
                }else{
                    conmentView.imageViews.isHidden = true
                    conmentView.imageViews.snp.updateConstraints({ (make) in
                        make.height.equalTo(0)
                    })
                }
                //设置数据
                
                conmentView.contentLab.text = model.content
                conmentView.ratingView.rating = Double.init(model.star_num!)!
            }
        }
    }

}
