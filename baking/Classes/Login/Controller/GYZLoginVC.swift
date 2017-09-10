//
//  GYZLoginVC.swift
//  baking
//  登录 控制器
//  Created by gouyz on 2016/12/1.
//  Copyright © 2016年 gouyz. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class GYZLoginVC: GYZBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = kWhiteColor
        self.title = "登  录"
    
        setupUI()
//        requestVersion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 创建UI
    fileprivate func setupUI(){
        
        view.addSubview(phoneInputView)
        view.addSubview(lineView)
        view.addSubview(pwdInputView)
        view.addSubview(lineView1)
        view.addSubview(loginBtn)
        view.addSubview(registerBtn)
        view.addSubview(forgetPwdBtn)
        
        phoneInputView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(30)
            make.left.right.equalTo(view)
            make.height.equalTo(kTitleHeight)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(phoneInputView.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        pwdInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.left.right.equalTo(phoneInputView)
            make.height.equalTo(phoneInputView)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.equalTo(lineView)
            make.top.equalTo(pwdInputView.snp.bottom)
            make.height.equalTo(lineView)
        }
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(lineView1.snp.bottom).offset(30)
            make.left.equalTo(view).offset(kStateHeight)
            make.right.equalTo(view).offset(-kStateHeight)
            make.height.equalTo(kUIButtonHeight)
        }
        registerBtn.snp.makeConstraints { (make) in
            make.top.equalTo(loginBtn.snp.bottom).offset(kStateHeight)
            make.left.right.equalTo(loginBtn)
            make.height.equalTo(loginBtn)
        }
        forgetPwdBtn.snp.makeConstraints { (make) in
            make.top.equalTo(registerBtn.snp.bottom).offset(kMargin)
            make.right.equalTo(pwdInputView).offset(-kStateHeight)
            make.size.equalTo(CGSize(width:70,height:kStateHeight))
        }
        
        registerBtn.set(image: UIImage.init(named: "icon_register_next"), title: "立即注册", titlePosition: .left, additionalSpacing: 5, state: .normal)
    }
    /// 手机号
    fileprivate lazy var phoneInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_login_phone", placeHolder: "请输入手机号码", isPhone: true)
    
    /// 分割线
    fileprivate lazy var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 密码
    fileprivate lazy var pwdInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_login_pwd", placeHolder: "请输入密码", isPhone: false)
    
    /// 分割线2
    fileprivate lazy var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 忘记密码按钮
    fileprivate lazy var forgetPwdBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("忘记密码?", for: .normal)
        btn.setTitleColor(kYellowFontColor, for: .normal)
        btn.titleLabel?.font = k15Font
        btn.titleLabel?.textAlignment = .right
        btn.addTarget(self, action: #selector(clickedForgetPwdBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    /// 登录按钮
    fileprivate lazy var loginBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitle("登  录", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(clickedLoginBtn(btn:)), for: .touchUpInside)
        btn.cornerRadius = kCornerRadius
        return btn
    }()
    
    /// 注册
    fileprivate lazy var registerBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kWhiteColor
        btn.setTitleColor(kYellowFontColor, for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(clickedRegisterBtn(btn:)), for: .touchUpInside)
        btn.borderColor = kBtnClickBGColor
        btn.borderWidth = klineWidth
        btn.cornerRadius = kCornerRadius
        return btn
    }()
    
    /// 注册
    func clickedRegisterBtn(btn: UIButton){
        let registerVC = GYZRegisterVC()
        registerVC.isRegister = true
        navigationController?.pushViewController(registerVC, animated: true)
    }
    /// 登录
    func clickedLoginBtn(btn: UIButton) {
        
        phoneInputView.textFiled.resignFirstResponder()
        pwdInputView.textFiled.resignFirstResponder()
        
        if !validPhoneNO() {
            return
        }
        if pwdInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入密码")
            return
        }
        
        requestLogin()
    }
    /// 忘记密码
    func clickedForgetPwdBtn(btn: UIButton) {
        let registerVC = GYZRegisterVC()
        registerVC.isRegister = false
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    /// 判断手机号是否有效
    ///
    /// - Returns:
    func validPhoneNO() -> Bool{
        
        if phoneInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入手机号")
            return false
        }
        if phoneInputView.textFiled.text!.isMobileNumber(){
            return true
        }else{
            MBProgressHUD.showAutoDismissHUD(message: "请输入正确的手机号")
            return false
        }
        
    }
    
    /// 登录
    func requestLogin(){
        
        weak var weakSelf = self
        createHUD(message: "登录中...")
        
        GYZNetWork.requestNetwork("User/login", parameters: ["phone":phoneInputView.textFiled.text!,"password": pwdInputView.textFiled.text!.md5()],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                let data = response["result"]
                let info = data["info"]
                
                userDefaults.set(true, forKey: kIsLoginTagKey)//是否登录标识
                userDefaults.set(info["id"].stringValue, forKey: "userId")//用户ID
                userDefaults.set(info["phone"].stringValue, forKey: "phone")//用户电话
                userDefaults.set(info["username"].stringValue, forKey: "username")//用户名称
                userDefaults.set(info["is_signing"].stringValue, forKey: "signing")//0没有签约 1签约
                userDefaults.set(info["longitude"].stringValue, forKey: "longitude")//经度
                userDefaults.set(info["latitude"].stringValue, forKey: "latitude")//纬度
                userDefaults.set(info["head_img"].url, forKey: "headImg")//用户logo
                userDefaults.set(info["balance"].stringValue, forKey: "balance")//余额
                
                ///极光推送设置别名
                JPUSHService.setTags(nil, alias: info["phone"].stringValue, fetchCompletionHandle: { (code, tags, alias) in
                    
                    NSLog("code:\(code)")
                })
                //KeyWindow.rootViewController = GYZMainTabBarVC()
                _ = weakSelf?.navigationController?.popViewController(animated: true)
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 请求服务器版本
    func requestVersion(){
        weak var weakSelf = self
        GYZNetWork.requestNetwork("version/checkVersion.do",isToken:false, parameters: ["type":"A2"], method: .post, success:{ (response) in
            
//            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                let data = response["data"]
                let content = data["content"].stringValue
                let version = data["code"].stringValue
                weakSelf?.checkVersion(newVersion: version, content: content)
            }
        }, failture: { (error) in
            GYZLog(error)
        })
    }
    /// 检测APP更新
    func checkVersion(newVersion: String,content: String){
        
        let type: UpdateVersionType = GYZUpdateVersionTool.compareVersion(newVersion: newVersion)
        switch type {
        case .update:
            updateVersion(version: newVersion, content: content)
        case .updateNeed:
            updateNeedVersion(version: newVersion, content: content)
        default:
            break
        }
    }
    /**
     * //不强制更新
     * @param version 版本名称
     * @param content 更新内容
     */
    func updateVersion(version: String,content: String){
       
        GYZAlertViewTools.alertViewTools.showAlert(title:"发现新版本\(version)", message: content, cancleTitle: "残忍拒绝", viewController: self, buttonTitles: "立即更新", alertActionBlock: { (index) in
            
            if index == 0{//立即更新
                GYZUpdateVersionTool.goAppStore()
            }
        })
    }
    /**
     * 强制更新
     * @param version 版本名称
     * @param content 更新内容
     */
    func updateNeedVersion(version: String,content: String){
        
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title:"发现新版本\(version)", message: content, cancleTitle: nil, viewController: self, buttonTitles: "立即更新", alertActionBlock: { (index) in
            
            if index == 0{//立即更新
                GYZUpdateVersionTool.goAppStore()
                ///递归调用，重新设置弹出框
                weakSelf?.updateNeedVersion(version: version, content: content)
            }
        })
    }
}
