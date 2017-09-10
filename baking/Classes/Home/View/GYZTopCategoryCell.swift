//
//  GYZTopCategoryCell.swift
//  baking
//  商品父类 cell
//  Created by gouyz on 2017/5/24.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZTopCategoryCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bgView)
        bgView.addSubview(nameLab)
        
        bgView.snp.makeConstraints { (make) in
//            make.top.left.bottom.equalTo(self)
//            make.width.equalTo(80)
            make.edges.equalTo(0)
        }
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(5)
            make.centerY.equalTo(bgView)
            make.right.equalTo(bgView).offset(-5)
            make.height.equalTo(kStateHeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///背景view
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        view.borderColor = kBlackFontColor
        view.cornerRadius = kCornerRadius
        view.borderWidth = klineWidth
        
        return view
    }()
    
    ///商品类名称
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
//        lab.highlightedTextColor = kWhiteColor
        return lab
    }()
}
