//
//  GYZConmentView.swift
//  baking
//  评论view
//  Created by gouyz on 2017/4/17.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import Cosmos

class GYZConmentView: UIView {

    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        
        addSubview(ratingView)
        addSubview(contentLab)
        addSubview(imageViews)
        
        ratingView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(self).offset(5)
            make.size.equalTo(CGSize.init(width: 100, height: 20))
        }
        
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(ratingView)
            make.right.equalTo(-kMargin)
            make.top.equalTo(ratingView.snp.bottom).offset(5)
            //            make.bottom.equalTo(imageViews.snp.top).offset(-5)
        }
        imageViews.snp.makeConstraints { (make) in
            make.right.left.equalTo(self)
            make.height.equalTo(kBusinessImgHeight)
            make.top.equalTo(contentLab.snp.bottom).offset(5)
            make.bottom.equalTo(self).offset(-kMargin)
        }
    }
    
    ///星星评分
    lazy var ratingView: CosmosView = {
        
        let ratingStart = CosmosView()
        ratingStart.settings.updateOnTouch = false
        ratingStart.settings.fillMode = .precise
        ratingStart.settings.filledColor = kYellowFontColor
        ratingStart.settings.emptyBorderColor = kYellowFontColor
        ratingStart.settings.filledBorderColor = kYellowFontColor
        ratingStart.settings.starMargin = 3
        ratingStart.rating = 4.5
        
        return ratingStart
        
    }()
    /// 消息内容
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.numberOfLines = 0
        lab.text = "尊敬的客户尊敬的客户尊敬的客户尊敬的客户尊敬的客户尊敬的客户尊敬的客户尊敬的客户尊敬的客户尊敬的客户尊敬的客户尊敬的客户"
        
        return lab
    }()
    /// 多张图片
    lazy var imageViews: GYZImagesView = GYZImagesView()
}
