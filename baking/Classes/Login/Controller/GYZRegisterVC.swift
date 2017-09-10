//
//  GYZRegisterVC.swift
//  baking
//  注册
//  Created by gouyz on 2017/3/23.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class GYZRegisterVC: GYZBaseVC {
    ///是否为注册
    var isRegister: Bool = true
    ///记录获取的验证码
    var codeStr: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        if isRegister {
            self.title = "注册"
        } else {
            self.title = "忘记密码"
            personTxtFiled.isHidden = true
            desLab.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 创建UI
    fileprivate func setupUI(){
        
        view.addSubview(phoneInputView)
        view.addSubview(lineView)
        view.addSubview(bgView)
        bgView.addSubview(codeInputView)
        bgView.addSubview(codeBtn)
        bgView.addSubview(lineView1)
        view.addSubview(pwdInputView)
        view.addSubview(lineView2)
        view.addSubview(personTxtFiled)
        view.addSubview(okBtn)
        view.addSubview(desLab)
        
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
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.left.right.equalTo(phoneInputView)
            make.height.equalTo(phoneInputView)
        }
        codeInputView.snp.makeConstraints { (make) in
            make.top.equalTo(bgView)
            make.left.equalTo(bgView)
            make.right.equalTo(codeBtn.snp.left).offset(-kMargin)
            make.bottom.equalTo(lineView1.snp.top)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.equalTo(codeInputView)
            make.bottom.equalTo(bgView)
            make.height.equalTo(lineView)
        }
        codeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView)
            make.right.equalTo(bgView).offset(-kMargin)
            make.size.equalTo(CGSize.init(width: 80, height: 30))
        }
        pwdInputView.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom)
            make.left.right.equalTo(phoneInputView)
            make.height.equalTo(phoneInputView)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.equalTo(lineView)
            make.top.equalTo(pwdInputView.snp.bottom)
            make.height.equalTo(lineView)
        }
        
        personTxtFiled.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(lineView2.snp.bottom).offset(10)
            make.height.equalTo(phoneInputView)
        }
        
        okBtn.snp.makeConstraints { (make) in
            make.top.equalTo(personTxtFiled.snp.bottom).offset(20)
            make.left.equalTo(view).offset(kStateHeight)
            make.right.equalTo(view).offset(-kStateHeight)
            make.height.equalTo(kUIButtonHeight)
        }
        
        desLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(view)
            make.centerX.equalTo(view)
            make.height.equalTo(30)
            make.width.equalTo(200)
        }
        
        let des : NSMutableAttributedString = NSMutableAttributedString(string: "注册即代表阅读并同意买家须知")
        des.addAttribute(NSForegroundColorAttributeName, value: kYellowFontColor, range: NSMakeRange(10, 4))
        
        desLab.attributedText = des
    }
    /// 手机号
    fileprivate lazy var phoneInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_login_phone", placeHolder: "请输入手机号码", isPhone: true)
    
    /// 分割线
    fileprivate lazy var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 验证码
    fileprivate lazy var codeInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_code", placeHolder: "请输入验证码", isPhone: true)
    
    /// 分割线2
    fileprivate lazy var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        return view
    }()
    /// 密码
    fileprivate lazy var pwdInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_login_pwd", placeHolder: "请设置密码", isPhone: false)
    
    /// 分割线3
    fileprivate lazy var lineView2 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 获取验证码按钮
    fileprivate lazy var codeBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setBackgroundImage(UIImage.init(named: "icon_code_bg"), for: .normal)
        btn.setBackgroundImage(UIImage.init(named: "icon_code_bg_disable"), for: .disabled)
        btn.setTitle("发送验证码", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k14Font
        btn.titleLabel?.textAlignment = .center
        btn.addTarget(self, action: #selector(clickedCodeBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    
    /// 推荐人输入框
    lazy var personTxtFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.clearButtonMode = .whileEditing
        textFiled.backgroundColor = kGrayLineColor
        textFiled.placeholder = "请填写推荐人（可不填）"
        textFiled.cornerRadius = kCornerRadius
        
        return textFiled
    }()
    /// 确定按钮
    fileprivate lazy var okBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(clickedOkBtn(btn:)), for: .touchUpInside)
        btn.cornerRadius = kCornerRadius
        return btn
    }()
    
    /// 注册描述
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kGaryFontColor
        lab.addOnClickListener(target: self, action: #selector(clickedDesLab))
        
        return lab
    }()

    
    /// 注册
    func clickedOkBtn(btn: UIButton){
        
        if !validPhoneNO() {
            return
        }
        if codeInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入验证码")
            return
        }else if codeInputView.textFiled.text! != codeStr{
            MBProgressHUD.showAutoDismissHUD(message: "验证码错误")
            return
        }
        
        if pwdInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入密码")
            return
        }
        
        if isRegister {
            requestRegister()
        }else{
            requestUpdatePwd()
        }
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
    /// 获取验证码
    func clickedCodeBtn(btn: UIButton){
        if validPhoneNO() {
            requestCode()
        }
    }
    /// 注册
    func requestRegister(){
        
        weak var weakSelf = self
        createHUD(message: "注册中...")
        
        var person: String = personTxtFiled.text!
        if person.isEmpty {
            person = ""
        }
        
        GYZNetWork.requestNetwork("User/register", parameters: ["phone":phoneInputView.textFiled.text!,"password": pwdInputView.textFiled.text!.md5(),"recommend_user": person],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
               
                _ = weakSelf?.navigationController?.popViewController(animated: true)
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 找回密码
    func requestUpdatePwd(){
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("User/updatePassword", parameters: ["phone":phoneInputView.textFiled.text!,"password": pwdInputView.textFiled.text!.md5()],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                _ = weakSelf?.navigationController?.popToRootViewController(animated: true)
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    ///获取二维码
    func requestCode(){
        
        weak var weakSelf = self
        createHUD(message: "获取中...")
        
        GYZNetWork.requestNetwork("User/get_code", parameters: ["phone":phoneInputView.textFiled.text!],  success: { (response) in
            
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
    
    /// 购买须知
    func clickedDesLab(){
        let buyVC = GYZBuyNotesVC()
        navigationController?.pushViewController(buyVC, animated: true)
    }
}
