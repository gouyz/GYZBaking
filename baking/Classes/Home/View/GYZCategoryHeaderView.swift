//
//  GYZCategoryHeaderView.swift
//  baking
//  商品分类header
//  Created by gouyz on 2017/3/30.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZCategoryHeaderView: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        bgView.backgroundColor = kBackgroundColor
        contentView.addSubview(bgView)
        bgView.addSubview(nameLab)
        bgView.addSubview(clearLab)
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.bottom.equalTo(bgView)
            make.right.equalTo(clearLab.snp.left).offset(-kMargin)
        }
        
        clearLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(nameLab)
            make.width.equalTo(60)
        }
    }
    fileprivate lazy var bgView : UIView  = UIView()
    /// 商品分类名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        
        return lab
    }()
    ///
    lazy var clearLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "清空"
        lab.textAlignment = .right
        lab.isHidden = true
        
        return lab
    }()
}
