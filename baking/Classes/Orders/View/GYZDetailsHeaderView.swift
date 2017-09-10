//
//  GYZDetailsHeaderView.swift
//  baking
//  订单详情header
//  Created by gouyz on 2017/3/30.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZDetailsHeaderView: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(bgView)
        bgView.addSubview(lineView)
        bgView.addSubview(titleLab)
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(kMargin)
            make.top.equalTo(bgView).offset(kMargin)
            make.bottom.equalTo(bgView).offset(-kMargin)
            make.width.equalTo(5)
        }
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(lineView.snp.right).offset(5)
            make.top.bottom.equalTo(bgView)
            make.right.equalTo(bgView).offset(-kMargin)
        }
    }
    fileprivate lazy var bgView : UIView  = UIView()
    /// 竖线
    lazy var lineView : UIView = {
        let view = UIView()
        view.backgroundColor = kYellowFontColor
        
        return view
    }()
    /// header标题
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.font = k14Font
        lab.textColor = kGaryFontColor
        lab.text = "收货地址"
        
        return lab
    }()
}
