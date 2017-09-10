//
//  GYZOrderFooterView.swift
//  baking
//  订单footer
//  Created by gouyz on 2017/3/29.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZOrderFooterView: UITableViewHeaderFooterView {
    
    var delegate: GYZOrderFooterViewDelegate?

    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(lineView)
        contentView.addSubview(deleteBtn)
        contentView.addSubview(operateBtn)
        
        lineView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
            make.height.equalTo(klineWidth)
        }
        deleteBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(operateBtn.snp.left).offset(-kMargin)
            make.size.equalTo(CGSize.init(width: 80, height: 30))
        }
        operateBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(deleteBtn)
        }
    }
    
    fileprivate lazy var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    /// 操作 btn（评价、去结算等）
    lazy var operateBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.cornerRadius = kCornerRadius
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("去结算", for: .normal)
        btn.addTarget(self, action: #selector(clickedOperateBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    
    /// 删除订单
    lazy var deleteBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kWhiteColor
        btn.cornerRadius = kCornerRadius
        btn.borderColor = kYellowFontColor
        btn.borderWidth = klineWidth
        btn.titleLabel?.font = k15Font
        btn.setTitle("删除订单", for: .normal)
        btn.setTitleColor(kYellowFontColor, for: .normal)
        btn.addTarget(self, action: #selector(clickeddeleteBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    
    ///操作
    func clickedOperateBtn(btn : UIButton){
        
        delegate?.didClickedOperate(index: btn.tag,orderId: btn.accessibilityIdentifier!)
    }
    ///删除订单
    func clickeddeleteBtn(btn : UIButton){
        delegate?.didClickedDeleteOrder(orderId: btn.accessibilityIdentifier!)
    }
    
    /// 填充数据
    var dataModel : GYZOrderInfoModel?{
        didSet{
            if let model = dataModel {
                
                let oiStatus: String = model.status!
                var tag = 100 //待付款
                var statusTxt = "去结算"
                var isHiddenDeleteBtn = false
                operateBtn.backgroundColor = kBtnClickBGColor
                operateBtn.isEnabled = true
                
                if oiStatus == "2" {
                    tag = 102
                    statusTxt = "已取消"
                    operateBtn.backgroundColor = kBtnNoClickBGColor
//                    isHiddenDeleteBtn = true
                }else if oiStatus == "3"{
                    tag = 103
                    statusTxt = "货到付款"
                    operateBtn.backgroundColor = kBtnNoClickBGColor
                    isHiddenDeleteBtn = true
                }else if oiStatus == "4"{
                    tag = 104
                    statusTxt = "确认收货"
                    isHiddenDeleteBtn = true
                }else if oiStatus == "5"{
                    tag = 105
                    statusTxt = "已签收"
                    operateBtn.backgroundColor = kBtnNoClickBGColor
//                    isHiddenDeleteBtn = true
                }else if oiStatus == "1"{
                    tag = 101
                    if model.is_confirm == "0" {
                        statusTxt = "取消订单"
                    }else{
                        statusTxt = "已付款"
                        operateBtn.isEnabled = false
                        operateBtn.backgroundColor = kBtnNoClickBGColor
                    }
                    isHiddenDeleteBtn = true
                }else if oiStatus == "6"{
                    tag = 106
                    statusTxt = "已退款"
                    operateBtn.backgroundColor = kBtnNoClickBGColor
//                    isHiddenDeleteBtn = true
                }else if oiStatus == "7"{
                    tag = 107
                    if model.is_comment == "1" {//0未评价，1已评价
                        statusTxt = "已评价"
                        operateBtn.backgroundColor = kBtnNoClickBGColor
                    }else{
                        statusTxt = "去评价"
                    }
                    
                }else if oiStatus == "8"{
                    statusTxt = "不接单"
                    tag = 108
                    operateBtn.backgroundColor = kBtnNoClickBGColor
//                    isHiddenDeleteBtn = true
                }
                
                operateBtn.setTitle(statusTxt, for: .normal)
                operateBtn.tag = tag
                operateBtn.accessibilityIdentifier = model.order_id
                
                deleteBtn.isHidden = isHiddenDeleteBtn
                deleteBtn.accessibilityIdentifier = model.order_id
            }
        }
    }

}

protocol GYZOrderFooterViewDelegate {
    /// 操作
    ///
    /// - Parameter tag: tag值
    func didClickedOperate(index : Int,orderId: String)
    
    /// 删除订单
    ///
    /// - Parameter tag: tag值
    func didClickedDeleteOrder(orderId: String)
}
