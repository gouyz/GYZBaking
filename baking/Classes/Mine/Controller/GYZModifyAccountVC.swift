//
//  GYZModifyAccountVC.swift
//  baking
//  修改账号/修改账户密码
//  Created by gouyz on 2017/3/31.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class GYZModifyAccountVC: GYZBaseVC {
    
    /// true 修改账号 false 修改账户密码
    var isModifyAccount = true

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = kWhiteColor
        
        view.addSubview(textFiled)
        view.addSubview(okBtn)
        
        if isModifyAccount {
            self.title = "修改账号"
        } else {
            self.title = "修改账户密码"
            textFiled.placeholder = "请输入已注册的手机号"
            okBtn.setTitle("下一步", for: .normal)
        }
        
        textFiled.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(30)
            make.height.equalTo(kTitleHeight)
        }
        
        okBtn.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(textFiled)
            make.top.equalTo(textFiled.snp.bottom).offset(kStateHeight)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 输入框
    lazy var textFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.clearButtonMode = .whileEditing
        textFiled.placeholder = "输入新手机号"
        textFiled.keyboardType = .namePhonePad
        textFiled.backgroundColor = kBackgroundColor
        textFiled.cornerRadius = kCornerRadius
        
        return textFiled
    }()
    /// 确定按钮
    fileprivate lazy var okBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitle("确 定", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(clickedOkBtn(btn:)), for: .touchUpInside)
        btn.cornerRadius = kCornerRadius
        return btn
    }()
    
    /// 确定
    func clickedOkBtn(btn: UIButton){
        
        if !validPhoneNO() {
            return
        }
        
        if !isModifyAccount {//修改账户密码
            let modifyVC = GYZModifyPassWordVC()
            modifyVC.phone = textFiled.text!
            navigationController?.pushViewController(modifyVC, animated: true)
        }else{
            requestUpdatePhone()
        }
    }
    /// 判断手机号是否有效
    ///
    /// - Returns:
    func validPhoneNO() -> Bool{
        
        if textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入手机号")
            return false
        }
        if textFiled.text!.isMobileNumber(){
            return true
        }else{
            MBProgressHUD.showAutoDismissHUD(message: "请输入正确的手机号")
            return false
        }
        
    }
    
    /// 修改手机号
    func requestUpdatePhone(){
        weak var weakSelf = self
        createHUD(message: "修改中...")
        
        GYZNetWork.requestNetwork("User/updateTel", parameters: ["phone":textFiled.text!,"user_id": userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                userDefaults.set(weakSelf?.textFiled.text, forKey: "phone")//用户电话
                _ = weakSelf?.navigationController?.popViewController(animated: true)
            }
            MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
