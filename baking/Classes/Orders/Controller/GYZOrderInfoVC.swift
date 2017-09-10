//
//  GYZOrderInfoVC.swift
//  baking
//  订单控制器
//  Created by gouyz on 2017/3/29.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD


private let orderInfoCell = "orderInfoCell"
private let orderInfoHeader = "orderInfoHeader"
private let orderInfoFooter = "orderInfoFooter"

class GYZOrderInfoVC: GYZBaseVC,UITableViewDelegate,UITableViewDataSource,GYZOrderFooterViewDelegate {
    
    /// 状态0全部 1未支付 2待收货 3交易成功
    var orderStatus : Int?
    var currPage : Int = 1
    
    var orderInfoModels: [GYZOrderInfoModel] = [GYZOrderInfoModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.init(top: 0, left: 0, bottom: kTitleAndStateHeight, right: 0))
        }
        requestOrderListData()
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
        
        table.register(GYZOrderCell.self, forCellReuseIdentifier: orderInfoCell)
        table.register(GYZOrderHeaderView.self, forHeaderFooterViewReuseIdentifier: orderInfoHeader)
        table.register(GYZOrderFooterView.self, forHeaderFooterViewReuseIdentifier: orderInfoFooter)
        
        weak var weakSelf = self
        ///添加下拉刷新
        GYZTool.addPullRefresh(scorllView: table, pullRefreshCallBack: {
            weakSelf?.refresh()
        })
        ///添加上拉加载更多
        GYZTool.addLoadMore(scorllView: table, loadMoreCallBack: {
            weakSelf?.loadMore()
        })
        return table
    }()
    
    ///获取商品数据
    func requestOrderListData(){
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("Order/orderList",parameters: ["type": orderStatus ?? 0,"p":currPage,"user_id":userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            weakSelf?.closeRefresh()
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                let data = response["result"]
                guard let info = data["info"].array else { return }
                
                for item in info{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = GYZOrderInfoModel.init(dict: itemInfo)
                    
                    weakSelf?.orderInfoModels.append(model)
                }
                if weakSelf?.orderInfoModels.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无订单信息，请点击刷新", reload: {
                        weakSelf?.refresh()
                        weakSelf?.hiddenEmptyView()
                    })
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            weakSelf?.closeRefresh()
            GYZLog(error)
            
            if weakSelf?.currPage == 1{//第一次加载失败，显示加载错误页面
                weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                    weakSelf?.refresh()
                    weakSelf?.hiddenEmptyView()
                })
            }
        })
    }
    
    
    // MARK: - 上拉加载更多/下拉刷新
    /// 下拉刷新
    func refresh(){
        currPage = 1
        requestOrderListData()
    }
    
    /// 上拉加载更多
    func loadMore(){
        currPage += 1
        requestOrderListData()
    }
    
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing(){//下拉刷新
            orderInfoModels.removeAll()
            GYZTool.endRefresh(scorllView: tableView)
        }else if tableView.mj_footer.isRefreshing(){//上拉加载更多
            GYZTool.endLoadMore(scorllView: tableView)
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderInfoModels.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderInfoModels[section].goods_list!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: orderInfoCell) as! GYZOrderCell
    
        let model = orderInfoModels[indexPath.section]
        cell.dataModel = model.goods_list?[indexPath.row]
    
        cell.selectionStyle = .none
        return cell
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: orderInfoHeader) as! GYZOrderHeaderView
        
        headerView.dataModel = orderInfoModels[section]
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: orderInfoFooter) as! GYZOrderFooterView
        footerView.contentView.backgroundColor = kWhiteColor
        footerView.delegate = self
        footerView.dataModel = orderInfoModels[section]
        
        return footerView
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kTitleHeight
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = GYZOrderDetailaVC()
        detailsVC.orderId = orderInfoModels[indexPath.section].order_id!
        navigationController?.pushViewController(detailsVC, animated: true)
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
            
            var orderInfo: GYZOrderInfoModel?
            
            for item in orderInfoModels {
                if item.order_id == orderId {
                    orderInfo = item
                    break
                }
            }
            if orderInfo?.is_comment == "1" {//0未评价，1已评价
                return
            }
            
            let conmentVC = GYZConmentVC()
            conmentVC.orderId = orderId
            conmentVC.shopId = (orderInfo?.member_info?.member_id)!
            conmentVC.shopName = (orderInfo?.member_info?.company_name)!
            navigationController?.pushViewController(conmentVC, animated: true)
        }else if index == 108{//不接单
            
        }
    }
    
    /// 收货
    ///
    /// - Parameter orderId: 
    func showReceivedGoods(orderId: String){
        var orderInfo: GYZOrderInfoModel?
        
        for item in orderInfoModels {
            if item.order_id == orderId {
                orderInfo = item
                break
            }
        }
        
        if orderInfo?.goods_list?.count > 1 {
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
    
    /// 去支付
    ///
    /// - Parameter orderId: <#orderId description#>
    func goPayVC(orderId: String){
        
        var orderInfo: GYZOrderInfoModel?
        
        for item in orderInfoModels {
            if item.order_id == orderId {
                orderInfo = item
                break
            }
        }
        
        let payVC = GYZPayVC()
        payVC.orderId = orderId
        payVC.orderNo = (orderInfo?.order_number)!
        payVC.orderPrice = (orderInfo?.order_price)!
        payVC.payPrice = (orderInfo?.pay_price)!
        payVC.eventName = (orderInfo?.event_name)!
        payVC.originalPrice = (orderInfo?.original_price)!
        payVC.useBalance = (orderInfo?.use_balance)!
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
                ///刷新列表
                for (x,item) in (weakSelf?.orderInfoModels.enumerated())! {
                    if item.order_id == orderId{
                        
                        weakSelf?.orderInfoModels.remove(at: x)
                        break
                    }
                }
                
                if weakSelf?.orderInfoModels.count > 0 {
                    
                    weakSelf?.tableView.reloadData()
                }else{
                    weakSelf?.showEmptyView(content:"暂无订单信息")
                }
                
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
                for item in (weakSelf?.orderInfoModels)! {
                    if item.order_id == orderId{
                        
                        //状态变为交易成功
                        item.status = "7"
                        break
                    }
                }
                
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
                ///刷新列表
                for item in (weakSelf?.orderInfoModels)! {
                    if item.order_id == orderId{
                        
                        //状态变为交易成功
                        item.status = "2"
                        break
                    }
                }
                
                weakSelf?.tableView.reloadData()
                
            }
            MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }

}
