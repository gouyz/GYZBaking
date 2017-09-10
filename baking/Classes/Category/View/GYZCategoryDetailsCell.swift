//
//  GYZCategoryDetailsCell.swift
//  baking
//  分类详情cell
//  Created by gouyz on 2017/3/26.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZCategoryDetailsCell: UICollectionViewCell {
    
    /// 填充数据
    var dataModel : GoodInfoModel?{
        didSet{
            if let model = dataModel {
                //设置数据
                ImgView.kf.setImage(with: URL.init(string: model.goods_thumb_img!), placeholder: UIImage.init(named: "icon_category_default"), options: nil, progressBlock: nil, completionHandler: nil)
                
                nameLab.text = model.cn_name
                
                if model.attr != nil {
                    let attrModel = model.attr?[0]
                    priceLab.text = "￥" + (attrModel?.price)!
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bgView)
        bgView.addSubview(ImgView)
        bgView.addSubview(nameLab)
        bgView.addSubview(priceLab)
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        ImgView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(bgView)
            make.height.equalTo(160)
        }
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(5)
            make.top.equalTo(ImgView.snp.bottom)
            make.right.equalTo(bgView).offset(-5)
            make.height.equalTo(40)
        }
        priceLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.bottom.equalTo(bgView).offset(-kMargin)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///背景view
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    ///内部背景图片
    lazy var ImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_category_default"))
    
    ///商品名称
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.numberOfLines = 2
        return lab
    }()
    
    ///商品价格
    lazy var priceLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kYellowFontColor
        return lab
    }()
}
