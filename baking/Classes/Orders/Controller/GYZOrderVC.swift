//
//  GYZOrderVC.swift
//  baking
//  订单管理基类
//  Created by gouyz on 2017/3/23.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZOrderVC: GYZBaseVC {

    let titleArr : [String] = ["全部", "待付款", "待收货","交易成功"]
    
    /// 订单状态
    var stateValue : [String] = ["0","1","2","3"]
    var scrollPageView: ScrollPageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "订单管理"
        
        setScrollView()
        checkIsLogin()
    }
    ///设置控制器
    func setChildVcs() -> [UIViewController] {
        
        var childVC : [GYZOrderInfoVC] = []
        for index in 0 ..< titleArr.count{
            
            let vc = GYZOrderInfoVC()
            vc.orderStatus = Int(stateValue[index])
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
