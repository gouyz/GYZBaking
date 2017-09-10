//
//  GYZHomeMenuView.swift
//  baking
//  主页menu View
//  Created by gouyz on 2017/7/21.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZHomeMenuView: UIView {

    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    convenience init(frame: CGRect, iconName : String,title: String){
        self.init(frame: frame)
        
        menuImg.image = UIImage.init(named: iconName)
        menuTitle.text = title
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        addSubview(menuImg)
        addSubview(menuTitle)
        
        menuImg.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(20)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        menuTitle.snp.makeConstraints { (make) in
            make.top.equalTo(menuImg.snp.bottom).offset(kMargin)
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-10)
        }
    }
    
    /// menu  图标
    lazy var menuImg : UIImageView = UIImageView()
    /// menu标题
    lazy var menuTitle : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k13Font
        lab.textAlignment = .center
        
        return lab
    }()


}
