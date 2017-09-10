//
//  GYZBusinessDetailPhotosCell.swift
//  baking
//  店铺实景/营业执照
//  Created by gouyz on 2017/4/4.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZBusinessDetailPhotosCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(logoImgView)
        contentView.addSubview(nameLab)
        contentView.addSubview(imageViews)
        
        logoImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(nameLab)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        
        nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.left.equalTo(logoImgView.snp.right).offset(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo(kTitleHeight)
        }
        imageViews.snp.makeConstraints { (make) in
            make.top.equalTo(nameLab.snp.bottom)
            make.right.left.equalTo(contentView)
            make.height.equalTo(kBusinessImgHeight)
            make.bottom.equalTo(contentView).offset(-kMargin)
        }
    }
    
    /// 图片
    lazy var logoImgView : UIImageView = UIImageView()
    /// cell title
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        
        return lab
    }()
    
    /// 多张图片
    lazy var imageViews: GYZImagesView = GYZImagesView()
    
    /// 填充数据
    var imgUrls : String?{
        didSet{
            if let urls = imgUrls {
                
                if let urlArr = GYZTool.getImgUrls(url: urls){
                    
                    imageViews.isHidden = false
                    imageViews.snp.updateConstraints({ (make) in
                        make.height.equalTo(kBusinessImgHeight)
                    })
                    
                    for (index,item) in urlArr.enumerated() {
                        switch index {
                        case 1:
                            imageViews.imgViewTwo.kf.setImage(with: URL.init(string: item), placeholder: UIImage.init(named: "icon_logo_default"), options: nil, progressBlock: nil, completionHandler: nil)
                        case 2:
                            imageViews.imgViewThree.kf.setImage(with: URL.init(string: item), placeholder: UIImage.init(named: "icon_logo_default"), options: nil, progressBlock: nil, completionHandler: nil)
                        case 3:
                            imageViews.imgViewFour.kf.setImage(with: URL.init(string: item), placeholder: UIImage.init(named: "icon_logo_default"), options: nil, progressBlock: nil, completionHandler: nil)
                        default:
                            imageViews.imgViewOne.kf.setImage(with: URL.init(string: item), placeholder: UIImage.init(named: "icon_logo_default"), options: nil, progressBlock: nil, completionHandler: nil)
                        }
                    }
                }else{
                    imageViews.isHidden = true
                    imageViews.snp.updateConstraints({ (make) in
                        make.height.equalTo(0)
                    })
                }
            }
        }
    }

}
