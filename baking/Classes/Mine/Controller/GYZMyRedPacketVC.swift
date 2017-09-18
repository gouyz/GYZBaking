//
//  GYZMyRedPacketVC.swift
//  baking
//  我的红包管理
//  Created by gouyz on 2017/9/12.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZMyRedPacketVC: GYZBaseVC {

    let titleArr : [String] = ["我的红包", "商家红包"]
    
    /// type=1签约优惠券；0商家优惠券
    var stateValue : [String] = ["1","0"]
    var scrollPageView: ScrollPageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "红包"
        
        setScrollView()
    }
    ///设置控制器
    func setChildVcs() -> [UIViewController] {
        
        var childVC : [GYZMyRedPacketInfoVC] = []
        for index in 0 ..< titleArr.count{
            
            let vc = GYZMyRedPacketInfoVC()
            vc.redPacketType = stateValue[index]
            childVC.append(vc)
        }
        
        return childVC
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 设置scrollView
    func setScrollView(){
        // 这个是必要的设置
        automaticallyAdjustsScrollViewInsets = false
        
        var style = SegmentStyle()
        // 滚动条
        style.showLine = true
        style.scrollTitle = false
        // 颜色渐变
        style.gradualChangeTitleColor = true
        // 滚动条颜色
        style.scrollLineColor = kYellowFontColor
        style.normalTitleColor = kBlackFontColor
        style.selectedTitleColor = kYellowFontColor
        /// 显示角标
        style.showBadge = false
        
        scrollPageView = ScrollPageView.init(frame: self.view.frame, segmentStyle: style, titles: titleArr, childVcs: setChildVcs(), parentViewController: self)
        view.addSubview(scrollPageView!)
    }

}
