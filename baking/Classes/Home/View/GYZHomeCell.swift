//
//  GYZHomeCell.swift
//  baking
//
//  Created by gouyz on 2017/3/24.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

protocol HomeCellDelegate : NSObjectProtocol {
    func didSelectIndex(index : Int)
}

class GYZHomeCell: UITableViewCell {
    
    var delegate: HomeCellDelegate?
    
    /// 填充数据
    var dataModel : GYZHomeModel?{
        didSet{
            if let model = dataModel {
                //设置数据
                for item in model.img! {
                    if item.id == "1" {
                        hotLab.text = item.title
                        hotdesLab.text = item.sub_title
                        hotImgView.kf.setImage(with: URL.init(string: item.img!), placeholder: UIImage.init(named: "icon_hot_default"), options: nil, progressBlock: nil, completionHandler: nil)
                    }else if item.id == "2" {
                        newLab.text = item.title
                        newDesLab.text = item.sub_title
                        topImgView.kf.setImage(with: URL.init(string: item.img!), placeholder: UIImage.init(named: "icon_home_default"), options: nil, progressBlock: nil, completionHandler: nil)
                    }else if item.id == "3" {
                        goodLab.text = item.title
                        goodDesLab.text = item.sub_title
                        bottomImgView.kf.setImage(with: URL.init(string: item.img!), placeholder: UIImage.init(named: "icon_home_default"), options: nil, progressBlock: nil, completionHandler: nil)
                    }
                }
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(leftView)
        leftView.addSubview(hotLab)
        leftView.addSubview(hotTagImgView)
        leftView.addSubview(hotdesLab)
        leftView.addSubview(hotImgView)
        contentView.addSubview(lineView1)
        
        contentView.addSubview(rightTopView)
        rightTopView.addSubview(newLab)
        rightTopView.addSubview(newDesLab)
        rightTopView.addSubview(topImgView)
        contentView.addSubview(lineView2)
        
        contentView.addSubview(rightBottomView)
        rightBottomView.addSubview(goodLab)
        rightBottomView.addSubview(goodDesLab)
        rightBottomView.addSubview(bottomImgView)
        
        leftView.snp.makeConstraints { (make) in
            make.top.bottom.left.equalTo(contentView)
            make.width.equalTo(rightTopView)
            make.right.equalTo(lineView1.snp.left)
        }
        
        hotLab.snp.makeConstraints { (make) in
            make.top.equalTo(leftView).offset(kMargin)
            make.left.equalTo(leftView).offset(kMargin)
            make.size.equalTo(CGSize.init(width: 70, height: 20))
        }
        
        hotTagImgView.snp.makeConstraints { (make) in
            make.top.equalTo(hotLab)
            make.left.equalTo(hotLab.snp.right)
            make.size.equalTo(CGSize.init(width: 28, height: 15))
        }
        
        hotdesLab.snp.makeConstraints { (make) in
            make.left.equalTo(hotLab)
            make.right.equalTo(leftView).offset(-kMargin)
            make.top.equalTo(hotLab.snp.bottom)
            make.height.equalTo(20)
        }
        
        hotImgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(hotdesLab)
            make.top.equalTo(hotdesLab.snp.bottom).offset(5)
            make.bottom.equalTo(leftView).offset(-5)
        }
        
        lineView1.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.left.equalTo(leftView.snp.right)
            make.width.equalTo(klineWidth)
        }
        
        rightTopView.snp.makeConstraints { (make) in
            make.top.right.equalTo(contentView)
            make.left.equalTo(lineView1.snp.right)
            make.bottom.equalTo(lineView2.snp.top)
            make.height.equalTo(rightBottomView)
            make.width.equalTo(leftView)
        }
        
        newLab.snp.makeConstraints { (make) in
            make.left.equalTo(rightTopView).offset(kMargin)
            make.top.equalTo(rightTopView).offset(15)
            make.right.equalTo(topImgView.snp.left).offset(-5)
            make.height.equalTo(20)
        }
        
        newDesLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(newLab)
            make.top.equalTo(newLab.snp.bottom)
            make.height.equalTo(20)
        }
        
        topImgView.snp.makeConstraints { (make) in
            make.right.equalTo(rightTopView).offset(-kMargin)
            make.centerY.equalTo(rightTopView)
            make.size.equalTo(CGSize.init(width: 50, height: 50))
        }
        
        lineView2.snp.makeConstraints { (make) in
            make.left.right.equalTo(rightTopView)
            make.top.equalTo(rightTopView.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        
        rightBottomView.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(contentView)
            make.left.equalTo(rightTopView)
            make.top.equalTo(lineView2.snp.bottom)
            make.height.equalTo(rightTopView)
        }
        goodLab.snp.makeConstraints { (make) in
            make.left.equalTo(rightBottomView).offset(kMargin)
            make.top.equalTo(rightBottomView).offset(15)
            make.right.equalTo(bottomImgView.snp.left).offset(-5)
            make.height.equalTo(20)
        }
        
        goodDesLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(goodLab)
            make.top.equalTo(goodLab.snp.bottom)
            make.height.equalTo(20)
        }
        
        bottomImgView.snp.makeConstraints { (make) in
            make.right.equalTo(rightBottomView).offset(-kMargin)
            make.centerY.equalTo(rightBottomView)
            make.size.equalTo(CGSize.init(width: 50, height: 50))
        }
    }
    
    fileprivate lazy var leftView: UIView = {
        let view = UIView()
        view.tag = 101
        view.addOnClickListener(target: self, action: #selector(menuViewClick(sender : )))
        
        return view
    }()
    fileprivate lazy var rightTopView: UIView = {
        let view = UIView()
        view.tag = 102
        view.addOnClickListener(target: self, action: #selector(menuViewClick(sender : )))
        
        return view
    }()
    fileprivate lazy var rightBottomView: UIView = {
        let view = UIView()
        view.tag = 103
        view.addOnClickListener(target: self, action: #selector(menuViewClick(sender : )))
        
        return view
    }()
    
    ///热门标题
    lazy var hotLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        return lab
    }()
    ///热门hot图片标志
    lazy var hotTagImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_hot_tag"))
    ///热门描述
    lazy var hotdesLab: UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kRedFontColor
        return lab
    }()
    ///热门hot图片
    lazy var hotImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_hot_default"))
    
    fileprivate lazy var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    
    ///新店推荐标题
    lazy var newLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        return lab
    }()
    ///新店推荐图片
    lazy var topImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_home_business"))
        imgView.cornerRadius = 25
        
        return imgView
    }()
    ///新店推荐描述
    lazy var newDesLab: UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kGaryFontColor
        return lab
    }()
    fileprivate lazy var lineView2 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    ///每日好店标题
    lazy var goodLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        return lab
    }()
    ///每日好店图片
    lazy var bottomImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_home_business"))
        imgView.cornerRadius = 25
        
        return imgView
    }()
    ///新店推荐描述
    lazy var goodDesLab: UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kGaryFontColor
        return lab
    }()
    
    ///点击事件
    func menuViewClick(sender : UITapGestureRecognizer){
        let tag = sender.view?.tag
        
        delegate?.didSelectIndex(index: tag! - 100)
    }
}
