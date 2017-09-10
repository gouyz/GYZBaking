//
//  GYZBaseVC.swift
//  flowers
//  基控制器
//  Created by gouyz on 2016/11/7.
//  Copyright © 2016年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class GYZBaseVC: UIViewController {
    
    var hud : MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = kBackgroundColor
        
        if navigationController?.childViewControllers.count > 1 {
            // 添加返回按钮
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_black_white"), style: .done, target: self, action: #selector(clickedBackBtn))
        }
        
    }
    /// 返回
    func clickedBackBtn() {
        _ = navigationController?.popViewController(animated: true)
    }
    /// 创建HUD
    func createHUD(message: String){
        if hud == nil {
            hud = MBProgressHUD.showHUD(message: message,toView: view)
        }else{
            hud?.show(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 检查是否登录
    ///
    /// - Returns:
    func checkIsLogin() -> Bool {
        //如果登录
        if !userDefaults.bool(forKey: kIsLoginTagKey) {
            weak var weakSelf = self
            GYZAlertViewTools.alertViewTools.showAlert(title: "提示", message: "请先登录", cancleTitle: "取消", viewController: self, buttonTitles: "去登录") { (index) in
                
                if index != -1{
                    //去登录
                    weakSelf?.navigationController?.pushViewController(GYZLoginVC(), animated: true)
                }
            }
            return false
        }
        return true
    }
}
