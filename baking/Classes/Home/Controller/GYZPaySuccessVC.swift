//
//  GYZPaySuccessVC.swift
//  baking
//  付款成功/失败
//  Created by gouyz on 2017/4/4.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZPaySuccessVC: GYZBaseVC {
    
    ///是否付款成功
    var isSuccess: Bool = true
    /// 订单ID
    var orderId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = kWhiteColor
        
        view.addSubview(logoImgView)
        view.addSubview(desLab)
        view.addSubview(backHomeBtn)
        view.addSubview(operatorBtn)
        
        logoImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(30)
            make.size.equalTo(CGSize.init(width: 100, height: 100))
        }
        desLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(logoImgView.snp.bottom).offset(5)
            make.height.equalTo(kTitleHeight)
        }
        
        backHomeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(kStateHeight)
            make.top.equalTo(desLab.snp.bottom).offset(30)
            make.height.equalTo(kTitleHeight)
            make.width.equalTo(operatorBtn)
        }
        operatorBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.left.equalTo(backHomeBtn.snp.right).offset(kStateHeight)
            make.top.size.equalTo(backHomeBtn)
        }
        
        if isSuccess {
            logoImgView.image = UIImage.init(named: "icon_pay_success")
            operatorBtn.setTitle("查看详情", for: .normal)
            desLab.text = "付款成功！"
            self.title = "付款成功"
        } else {
            logoImgView.image = UIImage.init(named: "icon_pay_failed")
            operatorBtn.setTitle("重新下单", for: .normal)
            desLab.text = "付款失败！"
            self.title = "付款失败"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var logoImgView: UIImageView = UIImageView()
    /// 描述
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        
        return lab
    }()
    
    /// 返回首页
    lazy var backHomeBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kWhiteColor
        btn.setTitle("返回首页", for: .normal)
        btn.setTitleColor(kYellowFontColor, for: .normal)
        btn.titleLabel?.font = k15Font
        btn.cornerRadius = kCornerRadius
        btn.borderColor = kYellowFontColor
        btn.borderWidth = klineWidth
        btn.addTarget(self, action: #selector(clickedBackHomeBtn), for: .touchUpInside)
        
        return btn
    }()
    /// 查看详情/重新下单
    lazy var operatorBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kYellowFontColor
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        btn.cornerRadius = kCornerRadius
        btn.addTarget(self, action: #selector(clickedOperatorBtn), for: .touchUpInside)
        
        return btn
    }()
    /// 返回首页
    func clickedBackHomeBtn(){
        _ = navigationController?.popToRootViewController(animated: true)
    }
    /// 查看详情/重新下单
    func clickedOperatorBtn(){
        let detailsVC = GYZOrderDetailaVC()
        detailsVC.orderId = orderId
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    ///重载返回
    override func clickedBackBtn() {
        clickedBackHomeBtn()
    }
}
