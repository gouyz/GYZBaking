//
//  GYZReportVC.swift
//  baking
//  举报商家
//  Created by gouyz on 2017/4/27.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class GYZReportVC: GYZBaseVC,UITextViewDelegate {

    var placeHolder = "请输入您的举报原因..."
    var seggestTxt: String = ""
    
    var shopId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "举报商家"
        
        setupUI()
    }
    
    func setupUI(){
        let noteView: UIView = UIView()
        noteView.backgroundColor = kWhiteColor
        view.addSubview(noteView)
        
        noteView.addSubview(noteTxtView)
        noteTxtView.delegate = self
        noteTxtView.text = placeHolder
        noteView.addSubview(desLab)
        desLab.text = "0/100"
        
        view.addSubview(sendBtn)
        
        noteView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(kMargin)
            make.height.equalTo(150)
        }
        noteTxtView.snp.makeConstraints { (make) in
            make.left.equalTo(noteView).offset(kMargin)
            make.right.equalTo(noteView).offset(-kMargin)
            make.top.equalTo(noteView)
            make.bottom.equalTo(desLab.snp.top)
        }
        desLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(noteView)
            make.left.right.equalTo(noteTxtView)
            make.height.equalTo(30)
        }
        
        sendBtn.snp.makeConstraints { (make) in
            make.left.equalTo(kStateHeight)
            make.right.equalTo(-kStateHeight)
            make.top.equalTo(noteView.snp.bottom).offset(30)
            make.height.equalTo(kBottomTabbarHeight)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    lazy var noteTxtView : UITextView = {
        let txtView = UITextView()
        txtView.textColor = kGaryFontColor
        txtView.font = k15Font
        
        return txtView
    }()
    
    lazy var desLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        lab.textAlignment = .right
        return lab
    }()
    
    /// 举  报按钮
    fileprivate lazy var sendBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitle("举  报", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(clickedSendBtn(btn:)), for: .touchUpInside)
        btn.cornerRadius = kCornerRadius
        return btn
    }()
    
    /// 举  报
    func clickedSendBtn(btn: UIButton){
        requestSubmit()
    }
    
    /// 提交举报
    func requestSubmit(){
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/addReport", parameters: ["user_id":userDefaults.string(forKey: "userId") ?? "","content": seggestTxt,"member_id": shopId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
            }
            MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    ///MARK UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let text = textView.text
        if text == placeHolder {
            textView.text = ""
        }
        
    }
    func textViewDidChange(_ textView: UITextView) {
        
        let text : String = textView.text
        
        if text.isEmpty {
            textView.text = placeHolder
        }else{
            seggestTxt = text
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.length == 0 && range.location > 99 {//最多输入100位
            return false
        }
        desLab.text = "\(range.location)/100"
        
        return true
    }


}
