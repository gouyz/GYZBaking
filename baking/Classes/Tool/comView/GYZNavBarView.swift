//
//  GYZNavBarView.swift
//  baking
//  自定义NavBarView，用于导航栏渐变
//  Created by gouyz on 2017/3/30.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZNavBarView: UIView {

    // MARK: 生命周期方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        ///透明背景
        self.backgroundColor = UIColor.clear
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func setupUI(){
        addSubview(viewBg)
        viewBg.addSubview(backBtn)
        viewBg.addSubview(titleLab)
        viewBg.addSubview(rightBtn)
        
        viewBg.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        backBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(viewBg.snp.centerY).offset(10)
            make.left.equalTo(viewBg).offset(kMargin)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: kTitleHeight))
        }
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(backBtn.snp.right)
            make.right.equalTo(rightBtn.snp.left)
            make.top.bottom.equalTo(viewBg)
        }
        
        rightBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(backBtn)
            make.right.equalTo(viewBg).offset(-kMargin)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: kTitleHeight))
        }
    }
    
    ///
    lazy var viewBg: UIView = UIView()
    
    /// 标题lab
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.font = k18Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        
        return lab
    }()
    
    /// 返回键
    lazy var backBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage(named: "icon_black_white"), for: .normal)
        return btn
    }()
    
    /// 右侧键
    lazy var rightBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage(named: "icon_search_white"), for: .normal)
        return btn
    }()
}
