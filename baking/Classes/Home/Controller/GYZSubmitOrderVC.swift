//
//  GYZSubmitOrderVC.swift
//  baking
//  提交订单、结算
//  Created by gouyz on 2017/4/4.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let submitOrderAddressCell = "submitOrderAddressCell"
private let submitOrderBusinessCell = "submitOrderBusinessCell"
private let submitOrderGoodsCell = "submitOrderGoodsCell"
private let submitOrderCell = "submitOrderCell"
private let submitOrderNoteCell = "submitOrderNoteCell"
private let submitOrderSendTimeCell = "submitOrderSendTimeCell"

class GYZSubmitOrderVC: GYZBaseVC,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    
    ///店铺信息
    var shopInfo: ShopInfoModel?
    /// 记录选择的goods，key为ID，value为数量
    var selectGoods: [String : Int] = [:]
    /// 记录选择的goods
    var selectGoodsItems: [GoodInfoModel] = [GoodInfoModel]()
    /// 记录选择的goods规格，key为商品ID，value为规格信息
    var selectGoodsAtts: [String : GoodsAttrModel] = [:]
    ///选择的goods总价格
    var selectTotalPrice: Float = 0.0
    ///计算实际支付价格
    var payPrice: Float = 0.0
    
    var orderNote: String = ""
    var orderNotePlaceHolder = "请输入备注内容..."
    
    /// 地址model
    var addressModel: GYZAddressModel?
    /// 发货时间model
    var semdTimeModel: [GYZSendTimeModel] = [GYZSendTimeModel]()
    /// 选择的时间
    var selectSendTime: GYZSendTimeModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "结算"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, kTitleHeight, 0))
        }
        setBottomView()
        requestDefaultAddress()
        requestSendTime()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if addressModel != nil {
            tableView.reloadData()
        }
    }
    
    func setBottomView(){
        let viewBg: UIView = UIView()
        viewBg.backgroundColor = kWhiteColor
        view.addSubview(viewBg)
        viewBg.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(kTitleHeight)
        }
        let desLab: UILabel = UILabel()
        desLab.text = "应付款"
        desLab.textColor = kBlackFontColor
        desLab.font = k15Font
        viewBg.addSubview(desLab)
        viewBg.addSubview(totalPayLab)
        viewBg.addSubview(submitBtn)
        
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(viewBg).offset(kMargin)
            make.top.bottom.equalTo(viewBg)
            make.width.equalTo(50)
        }
        totalPayLab.snp.makeConstraints { (make) in
            make.left.equalTo(desLab.snp.right)
            make.right.equalTo(submitBtn.snp.left).offset(-kMargin)
            make.top.bottom.equalTo(viewBg)
        }
        submitBtn.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(viewBg)
            make.width.equalTo(80)
        }
        
        payPrice = selectTotalPrice
        for model in selectGoodsItems {
            if model.preferential_type != "0" {///0无优惠 1立减 2打折
                var count: Int = selectGoods[model.id!]!
                
                ///优惠价购买数量 0无限制
                let buyNum: Int = Int.init(model.preferential_buy_num!)!
                if buyNum > 0 {
                    if count > buyNum {
                        count = buyNum
                    }
                }
                
                if model.preferential_type == "1" {
                    payPrice -= Float.init(count) * Float.init(model.preferential_price!)!
                }else if model.preferential_type == "2" {
                    
                    let price: String = (selectGoodsAtts[model.id!]?.price)!
                    payPrice -= Float.init(count) * Float.init(model.preferential_price!)! * Float.init(price)!/10
                }
            }
        }
        
        totalPayLab.text = "￥\(payPrice)"
    }
    
    ///应付款
    lazy var totalPayLab: UILabel = {
        let lab = UILabel()
        lab.font = k18Font
        lab.textColor = kYellowFontColor
        
        return lab
    }()
    /// 提交
    lazy var submitBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kYellowFontColor
        btn.setTitle("提交", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        btn.addTarget(self, action: #selector(clickedSubmitBtn), for: .touchUpInside)
        
        return btn
    }()
    /// 懒加载UITableView
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.tableFooterView = UIView()
        table.separatorColor = kGrayLineColor
        
        table.register(GYZPayAddressCell.self, forCellReuseIdentifier: submitOrderAddressCell)
        table.register(GYZMineCell.self, forCellReuseIdentifier: submitOrderBusinessCell)
        table.register(GYZOrderDetailCell.self, forCellReuseIdentifier: submitOrderGoodsCell)
        table.register(GYZDetailsLabCell.self, forCellReuseIdentifier: submitOrderCell)
        table.register(GYZPayNoteCell.self, forCellReuseIdentifier: submitOrderNoteCell)
        table.register(GYZProfileCell.self, forCellReuseIdentifier: submitOrderSendTimeCell)
        
        return table
    }()
    
    
    /// 提交
    func clickedSubmitBtn(){
        
        if addressModel == nil {
            MBProgressHUD.showAutoDismissHUD(message: "请选择收货地址")
            return
        }
        
        requestSubmitOrder()
    }
    
    func requestSubmitOrder(){
        weak var weakSelf = self
        createHUD(message: "加载中...")
        var ids: String = ""
        var nums: String = ""
        var attrs: String = ""
        for item in selectGoods {
            ids += item.key + ";"
            
            nums += String.init(format: "%d;", item.value)
        }
        ids = ids.substring(to: ids.index(ids.startIndex, offsetBy: ids.characters.count - 1))
        nums = nums.substring(to: nums.index(ids.startIndex, offsetBy: nums.characters.count - 1))
        
        for item in selectGoodsAtts.values {
            attrs += item.attr_id! + ";"
        }
        attrs = attrs.substring(to: attrs.index(ids.startIndex, offsetBy: attrs.characters.count - 1))
        let params: [String : String] = ["user_id": userDefaults.string(forKey: "userId") ?? "","member_id": (shopInfo?.member_id)!,"tel": (addressModel?.tel)! ,"province": (addressModel?.province)!,"city": (addressModel?.city)!,"area": (addressModel?.area)!,"address": (addressModel?.address)!,"message": orderNote,"goods_id": ids,"goods_num": nums,"attr_id":attrs,"consignee":(addressModel?.consignee)!,"send_time":(selectSendTime?.delivery_time)!,"ads_longitude":(addressModel?.ads_longitude)!,"ads_latitude":(addressModel?.ads_latitude)!]
        
        GYZNetWork.requestNetwork("Order/add", parameters: params,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                let data = response["result"]
                let itemInfo = data["info"]
                
                let payVC = GYZPayVC()
                payVC.orderId = itemInfo["order_id"].stringValue
                payVC.orderNo = itemInfo["order_number"].stringValue
                payVC.orderPrice = itemInfo["order_price"].stringValue
                payVC.payPrice = itemInfo["pay_price"].stringValue
                payVC.eventName = itemInfo["event_name"].stringValue
                payVC.useBalance = itemInfo["use_balance"].stringValue
                payVC.originalPrice = itemInfo["original_price"].stringValue
                weakSelf?.navigationController?.pushViewController(payVC, animated: true)
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }

    
    /// 配送时间
    func requestSendTime(){
        weak var weakSelf = self
        

        GYZNetWork.requestNetwork("Order/deliveryTime", success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                let data = response["result"]
                guard let info = data["info"].array else { return }
                
                for item in info{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = GYZSendTimeModel.init(dict: itemInfo)
                    
                    weakSelf?.semdTimeModel.append(model)
                    
                    if model.time_id == "3"{//默认配送3日内到达
                        weakSelf?.selectSendTime = model
                    }
                }
                if weakSelf?.semdTimeModel.count > 0{
                    
                    weakSelf?.tableView.reloadData()
                }
                
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 获取默认地址
    func requestDefaultAddress(){
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Address/defaultAddress",parameters: ["user_id":userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                let data = response["result"]
                guard let infoItem = data["info"].dictionaryObject else { return }
                
                weakSelf?.addressModel = GYZAddressModel.init(dict: infoItem)
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return selectGoodsItems.count + 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {//地址
            let cell = tableView.dequeueReusableCell(withIdentifier: submitOrderAddressCell) as! GYZPayAddressCell
            
            if addressModel == nil {
                cell.desLab.isHidden = false
                cell.addressLab.isHidden = true
                cell.contractLab.isHidden = true
            }else{
                cell.desLab.isHidden = true
                cell.addressLab.isHidden = false
                cell.contractLab.isHidden = false
                cell.addressLab.text = (addressModel?.province!)! + (addressModel?.city!)! + (addressModel?.area!)! + (addressModel?.address!)!
                cell.contractLab.text = (addressModel?.consignee!)! + "  " + (addressModel?.tel!)!
            }
            
            cell.selectionStyle = .none
            return cell
            
        }else if indexPath.section == 1{
            if indexPath.row == selectGoodsItems.count + 1 {//总价
                let cell = tableView.dequeueReusableCell(withIdentifier: submitOrderCell) as! GYZDetailsLabCell
                cell.desLab.textColor = kGaryFontColor
                cell.desLab.textAlignment = .right
                
                let str = "总价：￥\(selectTotalPrice)"
                let price : NSMutableAttributedString = NSMutableAttributedString(string: str)
                price.addAttribute(NSFontAttributeName, value: k18Font, range: NSMakeRange(3, str.characters.count - 3))
                price.addAttribute(NSForegroundColorAttributeName, value: kYellowFontColor, range: NSMakeRange(3, str.characters.count - 3))
                cell.desLab.attributedText = price
                
                cell.selectionStyle = .none
                return cell
            }else if indexPath.row == 0{//商家名称
                let cell = tableView.dequeueReusableCell(withIdentifier: submitOrderBusinessCell) as! GYZMineCell
                cell.logoImgView.image = UIImage.init(named: "icon_conment_tag")
                cell.nameLab.text = shopInfo?.company_name
                cell.rightIconView.isHidden = true
                
                cell.selectionStyle = .none
                return cell
            }else{//商品
                let cell = tableView.dequeueReusableCell(withIdentifier: submitOrderGoodsCell) as! GYZOrderDetailCell
                
                let item = selectGoodsItems[indexPath.row - 1]
                cell.nameLab.text = item.cn_name
                cell.goodsCountLab.text = "x\(selectGoods[item.id!]!)"
                
                cell.priceLab.text = "￥" + (selectGoodsAtts[item.id!]?.price)!
                
                if item.preferential_type == "1" {///0无优惠 1立减 2打折
                    cell.discountLab.text = "立减￥" + item.preferential_price!
                }else if item.preferential_type == "2" {///0无优惠 1立减 2打折
                    cell.discountLab.text =  item.preferential_price! + "折"
                }else{
                    cell.discountLab.text = ""
                }
                
                
                cell.selectionStyle = .none
                return cell
            }
        }else if indexPath.section == 2{//配送时间
            let cell = tableView.dequeueReusableCell(withIdentifier: submitOrderSendTimeCell) as! GYZProfileCell
            cell.userImgView.isHidden = true
            cell.desLab.text = selectSendTime?.delivery_time
            cell.nameLab.text = "配送时间"
            
            cell.selectionStyle = .none
            return cell
        }else{//备注
            let cell = tableView.dequeueReusableCell(withIdentifier: submitOrderNoteCell) as! GYZPayNoteCell
            
            cell.noteTxtView.delegate = self
            
            if orderNote.isEmpty {
                cell.noteTxtView.text = orderNotePlaceHolder
            }else{
                cell.noteTxtView.text = orderNote
            }
            
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return kTitleAndStateHeight
        }else if indexPath.section == 3{
            return 80
        }
        return kTitleHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
        return kMargin
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {//选择地址
            let addressVC = GYZMineAddressVC()
            addressVC.isSelected = true
            navigationController?.pushViewController(addressVC, animated: true)
        }else if indexPath.section == 2{//选择配送时间
            showSendTime()
        }
    }
    
    ///MARK UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let text = textView.text
        if text == orderNotePlaceHolder {
            textView.text = ""
        }
        
    }
    func textViewDidChange(_ textView: UITextView) {
        
        let text : String = textView.text
        
        if text.isEmpty {
            textView.text = orderNotePlaceHolder
        }else{
            orderNote = text
        }
    }
    
    /// 选择配送时间
    func showSendTime(){
        var sendTimes: [String] = [String]()
        for item in semdTimeModel {
            sendTimes.append(item.delivery_time!)
        }
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showSheet(title: "选择配送时间", message: nil, cancleTitle: "取消", titleArray: sendTimes, viewController: self) { (index) in
            
            if index != cancelIndex{
                weakSelf?.selectSendTime = weakSelf?.semdTimeModel[index]
                weakSelf?.tableView.reloadData()
            }
        }
    }
}
