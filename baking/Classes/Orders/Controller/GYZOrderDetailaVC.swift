//
//  GYZOrderDetailaVC.swift
//  baking
//  订单详情
//  Created by gouyz on 2017/3/30.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let orderDetailsCell = "orderDetailsCell"
private let orderDetailsGoodsCell = "orderDetailsGoodsCell"
private let orderDetailsBusinessHeader = "orderDetailsBusinessHeader"
private let orderDetailsHeader = "orderDetailsHeader"
private let orderDetailsFooter = "orderDetailsFooter"

class GYZOrderDetailaVC: GYZBaseVC,UITableViewDelegate,UITableViewDataSource,GYZOrderFooterViewDelegate {
    
    ///header标题
    let headerTitles: [String] = ["收货地址","订单信息","备注"]
    var orderId: String = ""
    
    var orderInfoModels: GYZOrderInfoModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "订单详情"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        requestOrderDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /// 懒加载UITableView
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.tableFooterView = UIView()
        table.separatorColor = kGrayLineColor
        
        table.register(GYZDetailsLabCell.self, forCellReuseIdentifier: orderDetailsCell)
        table.register(GYZOrderDetailCell.self, forCellReuseIdentifier: orderDetailsGoodsCell)
        table.register(GYZDetailsBusinessHeaderView.self, forHeaderFooterViewReuseIdentifier: orderDetailsBusinessHeader)
        table.register(GYZDetailsHeaderView.self, forHeaderFooterViewReuseIdentifier: orderDetailsHeader)
        table.register(GYZOrderFooterView.self, forHeaderFooterViewReuseIdentifier: orderDetailsFooter)
        return table
    }()
    
    /// 订单详情
    func requestOrderDetail(){
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Order/orderInfo", parameters: ["order_id":orderId], success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                let data = response["result"]
                guard let info = data["info"].dictionaryObject else { return }
                
                weakSelf?.orderInfoModels = GYZOrderInfoModel.init(dict: info)
                weakSelf?.tableView.reloadData()
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
        return orderInfoModels == nil ? 0 : 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if orderInfoModels == nil {
            return 0
        }else{
            if section == 0 {
                return (orderInfoModels?.goods_list?.count)! + 1
            } else if section == 3{
                return 1
            }else if section == 2{
                return 3
            }
            return 2
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == (orderInfoModels?.goods_list?.count)! {
                let cell = tableView.dequeueReusableCell(withIdentifier: orderDetailsCell) as! GYZDetailsLabCell
                cell.desLab.textColor = kGaryFontColor
                cell.desLab.textAlignment = .right
                
                let discountPrice = Float.init((orderInfoModels?.order_price)!)! - Float.init((orderInfoModels?.pay_price)!)! - Float.init((orderInfoModels?.use_balance)!)!
                
                var strDisPrice: String = ""
                if discountPrice > 0 {
                    strDisPrice = "优惠￥\(discountPrice) "
                }
                if Float.init((orderInfoModels?.use_balance)!)! > 0 {
                    strDisPrice += " 余额支付￥\((orderInfoModels?.use_balance)!) "
                }
                
                let str = strDisPrice + "实付：￥\((orderInfoModels?.pay_price)!)"
                let price : NSMutableAttributedString = NSMutableAttributedString(string: str)
                price.addAttribute(NSFontAttributeName, value: k12Font, range: NSMakeRange(0, strDisPrice.characters.count))
                price.addAttribute(NSForegroundColorAttributeName, value: kRedFontColor, range: NSMakeRange(0, strDisPrice.characters.count))
                price.addAttribute(NSFontAttributeName, value: k15Font, range: NSMakeRange(strDisPrice.characters.count + 2, str.characters.count - strDisPrice.characters.count - 2))
                price.addAttribute(NSForegroundColorAttributeName, value: kBlackFontColor, range: NSMakeRange(strDisPrice.characters.count + 2, str.characters.count - strDisPrice.characters.count - 2))
                cell.desLab.attributedText = price
                
                if Float.init((orderInfoModels?.back_price)!)! > 0 {
                    cell.backLab.snp.updateConstraints({ (make) in
                        make.height.equalTo(20)
                    })
                    cell.backLab.text = "退款￥\((orderInfoModels?.back_price)!)"
                }else{
                    cell.backLab.snp.updateConstraints({ (make) in
                        make.height.equalTo(0)
                    })
                }
                
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: orderDetailsGoodsCell) as! GYZOrderDetailCell
    
            let item = orderInfoModels?.goods_list?[indexPath.row]
            var name: String = (item?.cn_name)!
            if !(item?.attr_name?.isEmpty)! {
                name += "[\((item?.attr_name)!)]"
            }
            cell.nameLab.text = name
            cell.goodsCountLab.text = "x\((item?.goods_sum)!)"
            cell.priceLab.text = "￥" + (item?.goods_price)!
            
            if item?.goodstate == "0" {
                cell.tagImgView.snp.updateConstraints({ (make) in
                    make.width.equalTo(0)
                })
            }else{
                cell.tagImgView.snp.updateConstraints({ (make) in
                    make.width.equalTo(40)
                })
                ///商品状态，0未收货 1已收货 -1退货
                if item?.goodstate == "1" {
                    cell.tagImgView.image = UIImage.init(named: "icon_received_goods_left")
                }else if item?.goodstate == "-1" {
                    cell.tagImgView.image = UIImage.init(named: "icon_back_goods_left")
                }
            }
            
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: orderDetailsCell) as! GYZDetailsLabCell
        cell.desLab.textColor = kGaryFontColor
        cell.desLab.textAlignment = .left
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.desLab.text = (orderInfoModels?.consignee)! + "  " + (orderInfoModels?.tel)!
            } else {
                cell.desLab.text = (orderInfoModels?.province)! + (orderInfoModels?.city)! + (orderInfoModels?.area)! + (orderInfoModels?.address)!
            }
        } else if indexPath.section == 2{
            if indexPath.row == 0 {
                cell.desLab.text = "订单号码 \((orderInfoModels?.order_number)!)"
            } else if indexPath.row == 1{
                cell.desLab.text = "下单时间 " + (orderInfoModels?.create_time?.dateFromTimeInterval()?.dateToStringWithFormat(format: "yyyy/MM/dd HH:mm"))!
            }else{
                cell.desLab.text = "配送时间 " + (orderInfoModels?.send_time)!
            }
        }else{
            cell.desLab.text = orderInfoModels?.message
        }
        
        cell.selectionStyle = .none
        return cell
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: orderDetailsBusinessHeader) as! GYZDetailsBusinessHeaderView
            
            headerView.logoImgView.kf.setImage(with: URL.init(string: (orderInfoModels?.member_info?.logo)!), placeholder: UIImage.init(named: "icon_logo_default"), options: nil, progressBlock: nil, completionHandler: nil)
            headerView.nameLab.text = orderInfoModels?.member_info?.company_name
            
            headerView.addOnClickListener(target: self, action: #selector(goBusinessDetail))
            
            return headerView
        } else {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: orderDetailsHeader) as! GYZDetailsHeaderView
            headerView.titleLab.text = headerTitles[section - 1]
            return headerView
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 3 {
            let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: orderDetailsFooter) as! GYZOrderFooterView
            
            footerView.dataModel = orderInfoModels
            footerView.delegate = self
            
            return footerView
        }
        
        return nil
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) && (indexPath.row == (orderInfoModels?.goods_list?.count)! + 1) {
            if Float.init((orderInfoModels?.back_price)!)! > 0 {
                return kTitleHeight + 20
            }
        }
        return kTitleHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return kTitleHeight
        }
        return 30
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3 {
            return 50
        }
        return 0.00001
    }
    
    /// 店铺详情
    func goBusinessDetail(){
        let businessVC = GYZBusinessVC()
        businessVC.shopId = (orderInfoModels?.member_info?.member_id)!
        navigationController?.pushViewController(businessVC, animated: true)
    }
    
    ///MARK:  GYZOrderFooterViewDelegate
    func didClickedOperate(index: Int, orderId: String) {
        if index == 100 {//待付款 -去结算
            goPayVC(orderId: orderId)
        }else if index == 101{//已付款
            showCancleOrder(orderId: orderId)
        }else if index == 103{//货到付款
            
        }else if index == 104{//确认收货
            showReceivedGoods(orderId: orderId)
        }else if index == 105{//已签收
            
        }else if index == 102{//已取消
            
        }else if index == 106{//已退款
            
        }else if index == 107{//去评价
            
            if orderInfoModels?.is_comment == "1" {//0未评价，1已评价
                return
            }
            
            let conmentVC = GYZConmentVC()
            conmentVC.orderId = orderId
            conmentVC.shopId = (orderInfoModels?.member_info?.member_id)!
            conmentVC.shopName = (orderInfoModels?.member_info?.company_name)!
            navigationController?.pushViewController(conmentVC, animated: true)
        }
    }
    /// 取消订单
    ///
    /// - Parameter orderId:
    func showCancleOrder(orderId: String){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "提示", message: "确定取消订单吗？", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { (index) in
            
            if index != -1{
                //取消订单
                weakSelf?.requestCancleOrder(orderId: orderId)
            }
        }
    }
    /// 收货
    ///
    /// - Parameter orderId:
    func showReceivedGoods(orderId: String){
        
        if orderInfoModels?.goods_list?.count > 1 {
            GYZAlertViewTools.alertViewTools.showSheet(title: nil, message: nil, cancleTitle: "取消", titleArray: ["全部收货","部分收货"], viewController: self) { [weak self](index) in
                
                if index == 0{//全部收货
                    self?.showAlert(orderId: orderId)
                }else if index == 1 {//部分收货
                    self?.goReceivedGoodsVC(orderId: orderId)
                }
            }
        }else{//只有1个商品，直接收货
            showAlert(orderId: orderId)
        }
    }
    
    ////提示是否确定收货
    func showAlert(orderId: String){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "提示", message: "确定收货吗？", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { (index) in
            
            if index != -1{
                //确定收货
                weakSelf?.requestUpdateStatusOrder(orderId: orderId)
            }
        }
    }
    
    /// 选择收货商品
    ///
    /// - Parameter orderId:
    func goReceivedGoodsVC(orderId: String){
        let receivedGoodsVC = GYZSelectReceivedGoodsVC()
        
        receivedGoodsVC.orderId = orderId
        receivedGoodsVC.type = "0"
        navigationController?.pushViewController(receivedGoodsVC, animated: true)
    }
    
    func goPayVC(orderId: String){
        
        let payVC = GYZPayVC()
        payVC.orderId = orderId
        payVC.orderNo = (orderInfoModels?.order_number)!
        payVC.orderPrice = (orderInfoModels?.order_price)!
        payVC.payPrice = (orderInfoModels?.pay_price)!
        payVC.eventName = (orderInfoModels?.event_name)!
        payVC.originalPrice = (orderInfoModels?.original_price)!
        payVC.useBalance = (orderInfoModels?.use_balance)!
        navigationController?.pushViewController(payVC, animated: true)
    }
    /// 删除订单
    ///
    /// - Parameter orderId:
    func didClickedDeleteOrder(orderId: String) {
        
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "提示", message: "确定删除订单吗？", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { (index) in
            
            if index != -1{
                //确定删除订单
                weakSelf?.requestDeleteOrder(orderId: orderId)
            }
        }
    }
    
    /// 删除订单
    ///
    /// - Parameter orderId:
    func requestDeleteOrder(orderId: String){
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Order/del", parameters: ["order_id":orderId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.showEmptyView(content:"暂无订单信息")
                
            }
            MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 确认收货
    ///
    /// - Parameter orderId:
    func requestUpdateStatusOrder(orderId: String){
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Order/confirm", parameters: ["order_id":orderId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                ///刷新列表
                
                //状态变为已收货
                weakSelf?.orderInfoModels?.status = "5"
                
                weakSelf?.tableView.reloadData()
                
            }
            MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 取消订单
    ///
    /// - Parameter orderId:
    func requestCancleOrder(orderId: String){
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Order/cancelOrder", parameters: ["order_id":orderId,"user_id":userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            //            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                //状态变为已取消
                weakSelf?.orderInfoModels?.status = "2"
                
                weakSelf?.tableView.reloadData()
                
            }
            MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }

}
