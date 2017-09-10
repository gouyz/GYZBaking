//
//  GYZPayVC.swift
//  baking
//  确认支付
//  Created by gouyz on 2017/4/4.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class GYZPayVC: GYZBaseVC,GYZSelectPayMethodViewDelegate {
    
    /// 订单编号，请求支付，最好加上三位随机数，尤其是微信支付
    var orderNo: String = ""
    /// 支付价格
    var payPrice: String = "0"
    /// 原价
    var orderPrice: String = ""
    /// 订单ID
    var orderId: String = ""
    /// 优惠说明
    var eventName: String = ""
    /// 优惠金额
    var originalPrice: String = "0"
    /// 使用的余额
    var useBalance: String = "0"
    
    var aliPayModel : GYZAliPayInfoModel?
    /// 选择支付方式
    var isAliPayType: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "确认支付"
        
        view.addSubview(orderNoLab)
        view.addSubview(payMoneyLab)
        view.addSubview(nameLab)
        view.addSubview(payMethodView)
        view.addSubview(okBtn)
        
        orderNoLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(30)
            make.right.equalTo(-kMargin)
            make.height.equalTo(30)
        }
        payMoneyLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(orderNoLab)
            make.top.equalTo(orderNoLab.snp.bottom)
        }
        
        nameLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(orderNoLab)
            make.height.equalTo(20)
            make.top.equalTo(payMoneyLab.snp.bottom)
        }
        
        payMethodView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(nameLab.snp.bottom).offset(30)
            make.height.equalTo(140)
        }
        
        okBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(kTitleHeight)
        }
        
        payMethodView.delegate = self
        orderNoLab.text = "订单号码：\(orderNo)"
        
        var price: String = "支付金额：￥\(payPrice)"
        if Float.init(useBalance) > 0 {
            if Float.init(originalPrice) > 0 {
                price += " (余额支付￥\(useBalance),优惠￥\(originalPrice))"
            }else{
                price += " (余额支付￥\(useBalance))"
            }
        }
        payMoneyLab.text = price
        
        nameLab.text = eventName
        /// 支付宝支付后返回，刷新数据通知
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView(noti:)), name: NSNotification.Name(rawValue: kAliPaySuccessResult), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    /// 订单号码
    lazy var orderNoLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        
        return lab
    }()
    /// 支付金额
    lazy var payMoneyLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        
        return lab
    }()
    /// 优惠说明
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kRedFontColor
        
        return lab
    }()

    /// 确定
    lazy var okBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kYellowFontColor
        btn.setTitle("确 定", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        btn.addTarget(self, action: #selector(clickedPayBtn), for: .touchUpInside)
        
        return btn
    }()
    ///支付方式
    lazy var payMethodView: GYZSelectPayMethodView = GYZSelectPayMethodView()
    /// 确定
    func clickedPayBtn(){
        
        if Float.init(payPrice) > 0 {
            if isAliPayType {//支付宝支付
                requestAliPayInfo()
            }
        }else{//为0时不需要支付
            goPayResultVC(isSuccess: true)
        }
        
    }
    
    /// 获取支付宝信息
    func requestAliPayInfo(){
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Notify/alipayInfo", parameters: ["order_number":orderNo],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
//            GYZLog(response)

            let data = response["result"]
            guard let info = data["info"].dictionaryObject else { return }
            
            weakSelf?.aliPayModel = GYZAliPayInfoModel.init(dict: info)
            
            weakSelf?.goAliPay()
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 支付宝支付
    func goAliPay(){
        
        let order = Order()
        // NOTE: 支付宝分配给开发者的应用ID
        order.app_id = aliPayModel?.alipay_pid
        // NOTE: 支付接口名称
        order.method = "alipay.trade.app.pay"
        // NOTE: 参数编码格式
        order.charset = "utf-8"
        // NOTE: 请求发送的时间，格式"yyyy-MM-dd HH:mm:ss"
        order.timestamp = Date().dateToStringWithFormat(format: "yyyy-MM-dd HH:mm:ss")
        // NOTE: 支付版本
        order.version = "1.0"
        // NOTE: sign_type 根据商户设置的私钥来决定
        order.sign_type = "RSA2"
        // NOTE: (非必填项)支付宝服务器主动通知商户服务器里指定的页面http路径
        order.notify_url = aliPayModel?.callbackUrl
        // NOTE: 商品数据
        order.biz_content = BizContent()
        order.biz_content.body = aliPayModel?.orderBody
        order.biz_content.subject = aliPayModel?.orderSubject
        order.biz_content.out_trade_no = aliPayModel?.outTradeNo //订单ID（由商家自行制定）
        order.biz_content.timeout_express = "30m" //超时时间设置
        order.biz_content.total_amount = aliPayModel?.price //商品价格
        
        //将商品信息拼接成字符串
        let orderInfo = order.orderInfoEncoded(false)
        let orderInfoEncoded = order.orderInfoEncoded(true)
        
        // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
        //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
        let signer: RSADataSigner = RSADataSigner.init(privateKey: kAliPayPrivateKey)
        let signedString = signer.sign(orderInfo, withRSA2: true)
        
        
        // NOTE: 如果加签成功，则继续执行支付
        if (signedString?.characters.count > 0) {
            
            // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
            let orderString: String = "\(orderInfoEncoded!)&sign=\(signedString!)"
            
            weak var weakSelf = self
            // NOTE: 调用支付结果开始支付
            // 在 v15.1.0 之后回调机制发生变化,调用支付宝客户端支付不会走payOrder:fromScheme:callback 的回调,只会走Appdelegate 的方法:
            
            AlipaySDK.defaultService().payOrder(orderString, fromScheme: kAliPayAppScheme, callback: { (resultDic) in
                
                GYZLog(resultDic)
                
                if let alipayjson = resultDic {
                    let resultStatus = alipayjson["resultStatus"] as! String
                    
                    var isSuccess: Bool = true
                    var result: String = ""
                    if resultStatus == "9000"{
                        result = "支付成功"
                        
                    }else if resultStatus == "8000" {
                        result = "正在处理中"
                    }else if resultStatus == "4000" {
                        result = "订单支付失败"
                        isSuccess = false
                    }else if resultStatus == "6001" {
                        result = "用户中途取消"
                        isSuccess = false
                    }else if resultStatus == "6002" {
                        result = "网络连接出错"
                        isSuccess = false
                    }
                    
                    MBProgressHUD.showAutoDismissHUD(message: result)
                    
                    weakSelf?.goPayResultVC(isSuccess: isSuccess)
    
                }
            })
        }
    }
    
    func goPayResultVC(isSuccess: Bool){
        if isSuccess {
            let successVC = GYZPaySuccessVC()
            successVC.isSuccess = isSuccess
            successVC.orderId = orderId
            navigationController?.pushViewController(successVC, animated: true)
        }
        
    }
    
    /// 支付宝支付成功，返回时，进行页面跳转
    ///
    /// - Parameter noti: 参数
    func refreshView(noti: NSNotification){
        let alipayjson = noti.userInfo!
        
        let resultStatus = alipayjson["resultStatus"] as! String
        
        var isSuccess: Bool = true
        var result: String = ""
        if resultStatus == "9000"{
            result = "支付成功"
            
        }else if resultStatus == "8000" {
            result = "正在处理中"
        }else if resultStatus == "4000" {
            result = "订单支付失败"
            isSuccess = false
        }else if resultStatus == "6001" {
            result = "用户中途取消"
            isSuccess = false
        }else if resultStatus == "6002" {
            result = "网络连接出错"
            isSuccess = false
        }
        
        MBProgressHUD.showAutoDismissHUD(message: result)
        
        goPayResultVC(isSuccess: isSuccess)
    }
    
    //MARK: GYZSelectPayMethodViewDelegate
    func didSelectPayType(isAliPay: Bool) {
        isAliPayType = isAliPay
    }
}
