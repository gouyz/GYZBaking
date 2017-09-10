//
//  GYZContractUsVC.swift
//  baking
//  联系我们
//  Created by gouyz on 2017/5/5.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class GYZContractUsVC: GYZBaseVC,UITextViewDelegate {
    
    let notePlaceHolder: String = "请输入备注"
    var noteTxt: String = ""
    
    /// 联系类型
    var contractTypeList: [GYZContractTypeModel] = [GYZContractTypeModel]()
    var typeNameList: [String] = [String]()
    var selectTypeId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "联系我们"
        setupUI()
        
        requestType()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupUI(){
        
        let viewBg1: UIView = UIView()
        viewBg1.backgroundColor = kWhiteColor
        view.addSubview(viewBg1)
        
        let nameLab: UILabel = UILabel()
        nameLab.text = "姓名："
        nameLab.textColor = kBlackFontColor
        nameLab.font = k15Font
        viewBg1.addSubview(nameLab)
        
        viewBg1.addSubview(nameFiled)
        
        let line1: UIView = UIView()
        line1.backgroundColor = kGrayLineColor
        viewBg1.addSubview(line1)
        
        let phoneLab: UILabel = UILabel()
        phoneLab.text = "电话："
        phoneLab.textColor = kBlackFontColor
        phoneLab.font = k15Font
        viewBg1.addSubview(phoneLab)
        
        viewBg1.addSubview(phoneFiled)
        
        let line2: UIView = UIView()
        line2.backgroundColor = kGrayLineColor
        viewBg1.addSubview(line2)
        
        let addressLab: UILabel = UILabel()
        addressLab.text = "地址："
        addressLab.textColor = kBlackFontColor
        addressLab.font = k15Font
        viewBg1.addSubview(addressLab)
        
        viewBg1.addSubview(addressFiled)
        
        let line3: UIView = UIView()
        line3.backgroundColor = kGrayLineColor
        viewBg1.addSubview(line3)
        
        viewBg1.addSubview(typeLab)
        viewBg1.addSubview(selectTypeLab)
        viewBg1.addSubview(rightIconView)
        
        let viewBg2: UIView = UIView()
        viewBg2.backgroundColor = kWhiteColor
        view.addSubview(viewBg2)
        
        viewBg2.addSubview(desLab)
        viewBg2.addSubview(noteTxtView)
        noteTxtView.delegate = self
        
        view.addSubview(submitBtn)
        
        viewBg1.snp.makeConstraints { (make) in
            make.top.equalTo(kMargin)
            make.left.right.equalTo(view)
            make.height.equalTo(kTitleHeight*4+klineWidth*3)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(viewBg1).offset(kMargin)
            make.top.equalTo(viewBg1)
            make.size.equalTo(CGSize.init(width: 60, height: kTitleHeight))
        }
        nameFiled.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab.snp.right)
            make.top.height.equalTo(nameLab)
            make.right.equalTo(viewBg1).offset(-kMargin)
        }
        line1.snp.makeConstraints { (make) in
            make.left.right.equalTo(viewBg1)
            make.top.equalTo(nameLab.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        phoneLab.snp.makeConstraints { (make) in
            make.left.size.equalTo(nameLab)
            make.top.equalTo(line1.snp.bottom)
        }
        phoneFiled.snp.makeConstraints { (make) in
            make.left.size.equalTo(nameFiled)
            make.top.equalTo(phoneLab)
        }
        line2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(line1)
            make.top.equalTo(phoneLab.snp.bottom)
        }
        
        addressLab.snp.makeConstraints { (make) in
            make.left.size.equalTo(nameLab)
            make.top.equalTo(line2.snp.bottom)
        }
        addressFiled.snp.makeConstraints { (make) in
            make.left.size.equalTo(nameFiled)
            make.top.equalTo(addressLab)
        }
        line3.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(line1)
            make.top.equalTo(addressLab.snp.bottom)
        }
        
        typeLab.snp.makeConstraints { (make) in
            make.left.size.equalTo(nameLab)
            make.top.equalTo(line3.snp.bottom)
        }
        selectTypeLab.snp.makeConstraints { (make) in
            make.left.equalTo(typeLab.snp.right)
            make.right.equalTo(rightIconView.snp.left)
            make.top.height.equalTo(typeLab)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.right.equalTo(nameFiled)
            make.bottom.equalTo(viewBg1).offset(-12)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        
        viewBg2.snp.makeConstraints { (make) in
            make.left.right.equalTo(viewBg1)
            make.top.equalTo(viewBg1.snp.bottom).offset(kMargin)
            make.height.equalTo(80)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(viewBg2).offset(kMargin)
            make.top.equalTo(viewBg2)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        noteTxtView.snp.makeConstraints { (make) in
            make.left.equalTo(desLab.snp.right)
            make.top.equalTo(desLab)
            make.height.equalTo(viewBg2)
            make.right.equalTo(viewBg2).offset(-kMargin)
        }
        submitBtn.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(viewBg2.snp.bottom).offset(30)
            make.height.equalTo(kTitleHeight)
        }
    }
    
    
    /// 姓名输入框
    lazy var nameFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.clearButtonMode = .whileEditing
        textFiled.placeholder = "请输入姓名"
        
        return textFiled
    }()
    
    /// 手机号输入框
    lazy var phoneFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.placeholder = "请输入手机号"
        textFiled.keyboardType = .namePhonePad
        
        return textFiled
    }()
    /// 地址输入框
    lazy var addressFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.placeholder = "请输入地址"
        
        return textFiled
    }()
    ///
    lazy var typeLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "联系类别"
        
        return lab
    }()
    lazy var selectTypeLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        lab.textAlignment = .right
        lab.text = "联系类别"
        lab.addOnClickListener(target: self, action: #selector(clickSelectType))
        
        return lab
    }()
    /// 右侧箭头图标
    fileprivate lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_gray"))
    // 描述
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "备注"
        
        return lab
    }()
    /// 备注
    lazy var noteTxtView : UITextView = {
        let txtView = UITextView()
        txtView.textColor = kGaryFontColor
        txtView.font = k15Font
        txtView.text = "请输入备注"
        
        return txtView
    }()
    
    /// 提交
    lazy var submitBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kYellowFontColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.cornerRadius = kCornerRadius
        btn.setTitle("提交", for: .normal)
        btn.addTarget(self, action: #selector(clickSubmitBtn), for: .touchUpInside)
        
        return btn
    }()
    
    /// 提交
    func clickSubmitBtn(){
        if (nameFiled.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入姓名")
            return
        }
        if (phoneFiled.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入电话")
            return
        }
        if (addressFiled.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入地址")
            return
        }
        if selectTypeId.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请选择联系类别")
            return
        }
        
        requestSubmit()
    }
    /// 提交联系类型
    func requestSubmit(){
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Index/addContact",parameters: ["name":nameFiled.text!,"tel":phoneFiled.text!,"address": addressFiled.text!,"contact_type":selectTypeId,"message": noteTxt], success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
             
                _ = weakSelf?.navigationController?.popViewController(animated: true)
            }
            MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    ///选择联系类型
    func clickSelectType(){
        weak var weakSelf = self
        
        GYZAlertViewTools.alertViewTools.showSheet(title: "选择联系类型", message: nil, cancleTitle: "取消", titleArray: typeNameList, viewController: self) { (index) in
            if index != cancelIndex{
                let item = weakSelf?.contractTypeList[index]
                weakSelf?.selectTypeLab.text = item?.type_name
                weakSelf?.selectTypeId = (item?.id)!
            }
        }
    }
    
    /// 获取联系类型
    func requestType(){
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Index/contactType",   success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                let data = response["result"]
                guard let info = data["info"].array else { return }
                
                for item in info{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = GYZContractTypeModel.init(dict: itemInfo)
                    weakSelf?.typeNameList.append(model.type_name!)
                    weakSelf?.contractTypeList.append(model)
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    ///MARK UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let text = textView.text
        if text == notePlaceHolder {
            textView.text = ""
        }
        
    }
    func textViewDidChange(_ textView: UITextView) {
        
        let text : String = textView.text
        
        if text.isEmpty {
            textView.text = notePlaceHolder
        }else{
            noteTxt = text
        }
    }

}
