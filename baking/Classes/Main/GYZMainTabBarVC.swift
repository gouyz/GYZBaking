//
//  GYZMainTabBarVC.swift
//  baking
//
//  Created by gouyz on 2017/3/23.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZMainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }
    
    func setUp(){
        tabBar.tintColor = kYellowFontColor
        
        addViewController(GYZHomeVC(), title: "首页", normalImgName: "icon_tab_home")
        addViewController(GYZCategoryVC(), title: "分类", normalImgName: "icon_tab_category")
        addViewController(GYZOrderVC(), title: "订单", normalImgName: "icon_tab_order")
        addViewController(GYZMineVC(), title: "我的", normalImgName: "icon_tab_mine")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 添加子控件
    fileprivate func addViewController(_ childController: UIViewController, title: String,normalImgName: String) {
        let nav = GYZBaseNavigationVC(rootViewController:childController)
        addChildViewController(nav)
        childController.tabBarItem.title = title
        childController.tabBarItem.image = UIImage(named: normalImgName)
        childController.tabBarItem.selectedImage = UIImage(named: normalImgName + "_selected")
    }
}
