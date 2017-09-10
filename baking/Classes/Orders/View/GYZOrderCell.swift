//
//  GYZOrderCell.swift
//  baking
//  订单cell
//  Created by gouyz on 2017/3/29.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZOrderCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : OrderGoodsModel?{
        didSet{
            if let model = dataModel {
                //设置数据
                logoImgView.kf.setImage(with: URL.init(string: model.goods_thumb_img!), placeholder: UIImage.init(named: "icon_goods_default"), options: nil, progressBlock: nil, completionHandler: nil)
                
                var name: String = model.cn_name!
                if !(model.attr_name?.isEmpty)! {
                    name += "[\((model.attr_name)!)]"
                }
                nameLab.text = name
                priceLab.text = "￥"+model.goods_price!
                goodsCountLab.text = "x" + model.goods_sum!
                
                tagImgView.isHidden = true
                ///商品状态，0未收货 1已收货 -1退货
                if model.goodstate == "1" {
                    tagImgView.isHidden = false
                    tagImgView.image = UIImage.init(named: "icon_received_goods_right")
                }else if model.goodstate == "-1" {
                    tagImgView.isHidden = false
                    tagImgView.image = UIImage.init(named: "icon_back_goods_right")
                }
            }
        }
    }

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
        contentView.addSubview(tagImgView)
        contentView.addSubview(priceLab)
        contentView.addSubview(goodsCountLab)
        
        logoImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
        }
        nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(logoImgView)
            make.left.equalTo(logoImgView.snp.right).offset(kMargin)
            make.right.equalTo(tagImgView.snp.left).offset(-5)
            make.height.equalTo(20)
        }
        tagImgView.snp.makeConstraints { (make) in
            make.top.equalTo(nameLab)
            make.right.equalTo(-kMargin)
            make.size.equalTo(CGSize.init(width: 40, height: 20))
        }
        goodsCountLab.snp.makeConstraints { (make) in
            make.top.equalTo(nameLab.snp.bottom)
            make.height.left.right.equalTo(nameLab)
        }
        priceLab.snp.makeConstraints { (make) in
            make.top.equalTo(goodsCountLab.snp.bottom)
            make.height.left.right.equalTo(nameLab)
        }
    }
    
    /// 商品图片
    lazy var logoImgView : UIImageView = {
        let view = UIImageView()
        view.borderColor = kGrayLineColor
        view.borderWidth = klineWidth
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    /// 商品名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k14Font
        lab.textColor = kBlackFontColor
        
        return lab
    }()
    /// 收货、退货标识
    lazy var tagImgView : UIImageView = UIImageView()
    /// 商品单价
    lazy var priceLab : UILabel = {
        let lab = UILabel()
        lab.font = k14Font
        lab.textColor = kYellowFontColor
        
        return lab
    }()
    /// 商品数量
    lazy var goodsCountLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kGaryFontColor
        
        return lab
    }()

}
