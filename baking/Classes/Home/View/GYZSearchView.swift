//
//  GYZSearchView.swift
//  baking
//  搜索框view
//  Created by gouyz on 2017/3/24.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZSearchView: UIView {
    
    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        
        addSubview(searchBtn)
        
        searchBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.init(top: kMargin, left: kStateHeight, bottom: kMargin, right: kStateHeight))
        }
    }
    lazy var searchBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kWhiteColor
        btn.set(image: UIImage(named: "icon_search_gray"), title: "请输入店铺名称", titlePosition: .right, additionalSpacing: 5, state: .normal)
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.titleLabel?.font = k15Font
        btn.borderColor = kBackgroundColor
        btn.borderWidth = klineDoubleWidth
        btn.cornerRadius = 15
        btn.isUserInteractionEnabled = false
        
        return btn
    }()


}
