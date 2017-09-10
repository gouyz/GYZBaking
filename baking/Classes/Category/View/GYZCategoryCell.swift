//
//  GYZCategoryCell.swift
//  baking
//  分类cell
//  Created by gouyz on 2017/3/26.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZCategoryCell: UICollectionViewCell {
    
    /// 填充数据
    var dataModel : GYZCategoryModel?{
        didSet{
            if let model = dataModel {
                //设置数据
                bgImgView.kf.setImage(with: URL.init(string: model.img!), placeholder: UIImage.init(named: "icon_goods_default"), options: nil, progressBlock: nil, completionHandler: nil)
                
                ImgView.backgroundColor = UIColor.ColorHexWithAlpha(model.color!, alpha: 0.5)
                nameLab.text = model.class_cn_name
                nameEnglishLab.text = model.class_en_name
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bgImgView)
        bgImgView.addSubview(ImgView)
        ImgView.addSubview(nameEnglishLab)
        ImgView.addSubview(nameLab)
        ImgView.addSubview(rightIconView)
        
        bgImgView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        ImgView.snp.makeConstraints { (make) in
            make.center.equalTo(bgImgView)
            make.height.equalTo(40)
            make.left.equalTo(bgImgView).offset(kStateHeight)
            make.right.equalTo(bgImgView).offset(-kStateHeight)
        }
        
        nameEnglishLab.snp.makeConstraints { (make) in
            make.left.top.equalTo(ImgView).offset(5)
            make.right.equalTo(rightIconView.snp.left)
            make.height.equalTo(10)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameEnglishLab)
            make.top.equalTo(nameEnglishLab.snp.bottom)
            make.bottom.equalTo(ImgView).offset(-5)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(ImgView)
            make.right.equalTo(ImgView)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///背景图片
    lazy var bgImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_goods_default"))
    ///内部背景图片
    lazy var ImgView: UIView = UIView()
    
    ///英文名称
    lazy var nameEnglishLab: UILabel = {
        let lab = UILabel()
        lab.font = k10Font
        lab.textColor = kWhiteColor
        lab.text = "FLOUR"
        return lab
    }()
    ///中文名称
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kWhiteColor
        lab.text = "烘焙面粉"
        return lab
    }()
    /// 右侧箭头图标
    fileprivate lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_white"))
}
