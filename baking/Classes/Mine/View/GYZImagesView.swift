//
//  GYZImagesView.swift
//  baking
//  用于店铺实景/评论等显示图片
//  Created by gouyz on 2017/4/2.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import Kingfisher

class GYZImagesView: UIView {

    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        
        addSubview(imgViewOne)
        addSubview(imgViewTwo)
        addSubview(imgViewThree)
        addSubview(imgViewFour)
        
        imgViewOne.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(self)
            make.width.equalTo(imgViewTwo)
            make.height.equalTo(kBusinessImgHeight)
        }
        imgViewTwo.snp.makeConstraints { (make) in
            make.left.equalTo(imgViewOne.snp.right).offset(kMargin)
            make.top.height.equalTo(imgViewOne)
            make.width.equalTo(imgViewThree)
        }
        imgViewThree.snp.makeConstraints { (make) in
            make.left.equalTo(imgViewTwo.snp.right).offset(kMargin)
            make.top.height.equalTo(imgViewOne)
            make.width.equalTo(imgViewFour)
        }
        imgViewFour.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.height.width.equalTo(imgViewOne)
            make.left.equalTo(imgViewThree.snp.right).offset(kMargin)
        }
    }
    

    lazy var imgViewOne: UIImageView = UIImageView()
    lazy var imgViewTwo: UIImageView = UIImageView()
    lazy var imgViewThree: UIImageView = UIImageView()
    lazy var imgViewFour: UIImageView = UIImageView()
}
