//
//  GYZCategoryCell.swift
//  baking
//  商品分类cell
//  Created by gouyz on 2017/3/30.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZGoodsCategoryCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        configureUI()
    }
    
    func configureUI () {
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 商品分类名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kHeightGaryFontColor
        
        return lab
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        contentView.backgroundColor = selected ? kWhiteColor : kBackgroundColor
        
    }

}
