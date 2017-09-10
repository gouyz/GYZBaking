//
//  GYZMineAboutVC.swift
//  baking
//  关于我们
//  Created by gouyz on 2017/3/31.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZMineAboutVC: GYZBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "关于我们"
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI(){
        view.addSubview(bgView)
        bgView.addSubview(logoImgView)
        bgView.addSubview(versionLab)
        
        bgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(-kTitleAndStateHeight)
            make.width.equalTo(view)
            make.height.equalTo(200)
        }
        logoImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(bgView)
            make.top.equalTo(bgView)
            make.size.equalTo(CGSize.init(width: 100, height: 120))
        }
        versionLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgView)
            make.bottom.equalTo(bgView).offset(-kMargin)
            make.height.equalTo(30)
        }
        
        versionLab.text = "版本号：" + GYZUpdateVersionTool.getCurrVersion()
    }
    
    fileprivate lazy var bgView: UIView = UIView()
    
    /// 关于logo
    fileprivate lazy var logoImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_about_logo"))
    
    fileprivate lazy var versionLab: UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kGaryFontColor
        lab.textAlignment = .center
        return lab
    }()

}
