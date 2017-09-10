//
//  GYZGoodsDetailsHeaderView.swift
//  baking
//  商品详情header
//  Created by gouyz on 2017/4/17.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZGoodsDetailsHeaderView: UIView {

    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        
        addSubview(headerImg)
        addSubview(nameLab)
        addSubview(saleLab)
        addSubview(priceLab)
        
        headerImg.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.bottom.equalTo(nameLab.snp.top)
        }
        nameLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(saleLab.snp.top)
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo(30)
        }
        saleLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(priceLab.snp.top)
            make.left.right.equalTo(nameLab)
            make.height.equalTo(nameLab)
        }
        priceLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(-kMargin)
            make.left.right.equalTo(nameLab)
            make.height.equalTo(nameLab)
        }
    }
    /// 商品logo
    lazy var headerImg : UIImageView = UIImageView.init(image: UIImage.init(named: "icon_banner_default"))
    
    /// 商品名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        
        return lab
    }()
    
    /// 销量
    lazy var saleLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kGaryFontColor
        
        return lab
    }()
    /// 商品价格
    lazy var priceLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kYellowFontColor
        
        return lab
    }()
    
    /// 填充数据
    var dataModel : GYZGoodsDetailModel?{
        didSet{
            if let model = dataModel {
                
                let urlArr = GYZTool.getImgUrls(url: model.goods_img)
                if urlArr != nil {
                    headerImg.kf.setImage(with: URL.init(string: (urlArr?[0])!), placeholder: UIImage.init(named: "icon_banner_default"), options: nil, progressBlock: nil, completionHandler: nil)
                }else{
                    headerImg.image = UIImage.init(named: "icon_banner_default")
                }
                //设置数据
                
                nameLab.text = model.cn_name
                saleLab.text = "月销\(model.month_num!)单"
                if model.attr != nil {
                    let attrModel = model.attr?[0]
                    priceLab.text = "￥" + (attrModel?.price)!
                }
            }
        }
    }
}
