//
//  GYZHomeHeaderView.swift
//  baking
//
//  Created by gouyz on 2017/3/24.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import LLCycleScrollView

class GYZHomeHeaderView: UIView {
    
    ///搜索
    var searchView : GYZSearchView?
    ///轮播
    var bannerView: LLCycleScrollView?
    
    var delegate: GYZHomeHeaderViewDelegate?
    

    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        
        searchView = GYZSearchView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 50))
        addSubview(searchView!)
        searchView?.addOnClickListener(target: self, action: #selector(clickSearch))
        
        bannerView = LLCycleScrollView.llCycleScrollViewWithFrame(CGRect.init(x: 0, y: searchView!.bottomY, width: searchView!.width, height: 160), didSelectItemAtIndex: { [weak self](index) in
            
            self?.delegate?.didClickedBannerView(index: index)
        })
        bannerView?.customPageControlStyle = .snake
        bannerView?.pageControlPosition = .right
        bannerView?.placeHolderImage = UIImage.init(named: "icon_banner_default")
        addSubview(bannerView!)
        
    }
    
    /// 搜索
    func clickSearch(){
        delegate?.didSearchView()
    }
}

protocol GYZHomeHeaderViewDelegate :NSObjectProtocol {
    /// 点击轮播
    ///
    /// - Parameter index: 索引
    func didClickedBannerView(index: Int)
    
    func didSearchView()
}
