//
//  GYZAddAddressView.swift
//  baking
//  底部新增地址
//  Created by gouyz on 2017/4/2.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZAddAddressView: UIView {

    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        self.backgroundColor = kWhiteColor
        
        addSubview(lineView)
        addSubview(addBtn)
        
        lineView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(klineWidth)
        }
        addBtn.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: 120, height: 34))
        }
    }
    /// 线
    lazy var lineView: UIView = {
       let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    /// 新增地址
    lazy var addBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kYellowFontColor
        btn.cornerRadius = 17
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("+添加新地址", for: .normal)
        return btn
    }()
}
