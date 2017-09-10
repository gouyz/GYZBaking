//
//  GYZBusinessHeaderView.swift
//  baking
//  店铺详情页 header
//  Created by gouyz on 2017/3/27.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZBusinessHeaderView: UIView {
    
    var delegate: GYZBusinessHeaderViewDelegate?
    
    /// 填充数据
    var dataModel : GYZShopGoodsModel?{
        didSet{
            if let shopModel = dataModel {
                //设置数据
                
                let model = shopModel.member_info
                
                logoImgView.kf.setImage(with: URL.init(string: (model?.logo)!), placeholder: UIImage.init(named: "icon_logo_default"), options: nil, progressBlock: nil, completionHandler: nil)
                nameLab.text = model?.company_name
                if model?.send_price != nil {
                    priceLab.text = "起送价￥\((model?.send_price)!)"
                }
                
                if model?.is_collect == "0" {
                    favoriteBtn.backgroundColor = UIColor.clear
                }else{
                    favoriteBtn.backgroundColor = kYellowFontColor
                }
                
                var name: String = ""
                if shopModel.activity != nil && shopModel.activity?.count > 0 {
                    for item in shopModel.activity! {
                        name += item.level_name! + ","
                    }
                    name = name.substring(to: name.index(name.startIndex, offsetBy: name.characters.count - 1))
                }
                messageLab.text = name
//                if model.features != nil{
//                    messageLab.text = "店主说：" + model.features!
//                }
            }
        }
    }

    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        addSubview(bgImgView)
        bgImgView.isUserInteractionEnabled = true
        addSubview(messageView)
        
        bgImgView.addSubview(logoImgView)
        bgImgView.addSubview(nameLab)
        bgImgView.addSubview(priceLab)
        bgImgView.addSubview(favoriteBtn)
        
        messageView.addSubview(msgImgView)
        messageView.addSubview(messageLab)
        
        bgImgView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.bottom.equalTo(messageView.snp.top)
        }
        messageView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(30)
        }
        
        logoImgView.snp.makeConstraints { (make) in
            make.left.equalTo(bgImgView).offset(kMargin)
            make.bottom.equalTo(bgImgView).offset(-kStateHeight)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
        }
        
        nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(logoImgView).offset(kMargin)
            make.left.equalTo(logoImgView.snp.right).offset(kMargin)
            make.right.equalTo(favoriteBtn.snp.left).offset(-kMargin)
            make.height.equalTo(kStateHeight)
        }
        priceLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
        }
        
        favoriteBtn.snp.makeConstraints { (make) in
            make.right.equalTo(bgImgView).offset(-kMargin)
            make.top.equalTo(nameLab)
            make.size.equalTo(CGSize.init(width: 72, height: 30))
        }
        
        msgImgView.snp.makeConstraints { (make) in
            make.left.equalTo(messageView).offset(kMargin)
            make.centerY.equalTo(messageView)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        messageLab.snp.makeConstraints { (make) in
            make.left.equalTo(msgImgView.snp.right)
            make.top.bottom.equalTo(messageView)
            make.right.equalTo(messageView).offset(-kMargin)
        }
    }
    
    ///背景图片
    lazy var bgImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_shop_default"))
    
    ///背景图片
    lazy var logoImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_logo_default")
        imgView.cornerRadius = kCornerRadius
        imgView.borderColor = kWhiteColor
        imgView.borderWidth = klineDoubleWidth
        
        return imgView
    }()
    ///商家名称
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        return lab
    }()
    
    ///起送价格
    lazy var priceLab: UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        return lab
    }()
    /// 收藏
    lazy var favoriteBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "icon_favourite"), for: .normal)
        btn.setTitle("收藏", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.cornerRadius = 15
        btn.addTarget(self, action: #selector(clickfavourite),for: .touchUpInside)
        return btn
    }()
    /// 消息背景
    lazy var messageView: UIView = {
       let msgView = UIView()
        msgView.backgroundColor = kBackgroundColor
        
        return msgView
    }()
    ///背景图片
    fileprivate lazy var msgImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_message_default"))
    ///店铺消息
    lazy var messageLab: UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        return lab
    }()
    /// 收藏
    func clickfavourite(){
        delegate?.didFavouriteBusiness()
    }
}

protocol GYZBusinessHeaderViewDelegate : NSObjectProtocol {
    /// 收藏商家
    func didFavouriteBusiness()
}
