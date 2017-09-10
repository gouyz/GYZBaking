//
//  GYZModifyPassWordVC.swift
//  baking
//  修改账户密码 二
//  Created by gouyz on 2017/3/31.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class GYZModifyPassWordVC: GYZBaseVC {
    
    /// 手机号
    var phone: String = ""
    /// 验证码
    var codeStr: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "修改账户密码"
        self.view.backgroundColor = kWhiteColor
        
        view.addSubview(codeFiled)
        view.addSubview(codeBtn)
        view.addSubview(pwdFiled)
        view.addSubview(okBtn)
        
        codeFiled.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(codeBtn.snp.left).offset(-5)
            make.height.equalTo(kTitleHeight)
        }
        codeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-kMargin)
            make.top.height.equalTo(codeFiled)
            make.width.equalTo(80)
        }
        
        pwdFiled.snp.makeConstraints { (make) in
            make.left.height.equalTo(codeFiled)
            make.top.equalTo(codeFiled.snp.bottom).offset(kMargin)
            make.right.equalTo(view).offset(-kMargin)
        }
        
        okBtn.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(pwdFiled)
            make.top.equalTo(pwdFiled.snp.bottom).offset(kMargin)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 输入框
    lazy var codeFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.clearButtonMode = .whileEditing
        textFiled.placeholder = "输入收到的短信验证码"
        textFiled.keyboardType = .namePhonePad
        textFiled.backgroundColor = kBackgroundColor
        textFiled.cornerRadius = kCornerRadius
        
        return textFiled
    }()
    /// 输入框
    lazy var pwdFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.clearButtonMode = .whileEditing
        textFiled.placeholder = "输入新密码"
        textFiled.backgroundColor = kBackgroundColor
        textFiled.cornerRadius = kCornerRadius
        textFiled.isSecureTextEntry = true
        
        return textFiled
    }()
    
    /// 获取验证码按钮
    fileprivate lazy var codeBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kWhiteColor
        btn.setTitle("发送验证码", for: .normal)
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.titleLabel?.font = k15Font
        btn.titleLabel?.textAlignment = .center
        btn.borderColor = kBlackFontColor
        btn.borderWidth = klineWidth
        btn.cornerRadius = kCornerRadius
        btn.addTarget(self, action: #selector(clickedCodeBtn(btn:)), for: .touchUpInside)
        return btn
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
        if codeFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入验证码")
            return
        }else if codeFiled.text! != codeStr{
            MBProgressHUD.showAutoDismissHUD(message: "验证码错误")
            return
        }
        
        if pwdFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入密码")
            return
        }
        requestUpdatePwd()
    }
    /// 获取验证码
    func clickedCodeBtn(btn: UIButton){
        requestCode()
    }
    ///获取二维码
    func requestCode(){
        
        weak var weakSelf = self
        createHUD(message: "获取中...")
        
        GYZNetWork.requestNetwork("User/get_code", parameters: ["phone":phone],  success: { (response) in
            
            weakSelf?.codeBtn.startSMSWithDuration(duration: 60)
            
            weakSelf?.hud?.hide(animated: true)
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                let data = response["result"]
                let info = data["info"]
                
                weakSelf?.codeStr = info["code"].stringValue
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 修改密码
    func requestUpdatePwd(){
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("User/updatePassword", parameters: ["phone":phone,"password": pwdFiled.text!.md5()],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                GYZTool.removeUserInfo()
                KeyWindow.rootViewController = GYZBaseNavigationVC(rootViewController: GYZLoginVC())
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
