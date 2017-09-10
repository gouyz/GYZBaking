//
//  GYZSelectReceivedGoodsVC.swift
//  baking
//  选择收货商品
//  Created by gouyz on 2017/6/8.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD


private let receivedGoodsCell = "receivedGoodsCell"

class GYZSelectReceivedGoodsVC: GYZBaseVC,UITableViewDelegate,UITableViewDataSource {
    
    ///订单商品列表
    var goodsModels: [OrderGoodsModel] = [OrderGoodsModel]()
    
    ///选择的收货商品
    var selectGoods: [String : String] = [:]
    
    /// 订单id
    var orderId: String = ""
    ///商品状态，0未收货 1已收货 -1退货
    var type:String = "0"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "选择收货商品"
        view.addSubview(tableView)
        view.addSubview(receivedGoodsBtn)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, kBottomTabbarHeight, 0))
        }
        receivedGoodsBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view)
            make.top.equalTo(tableView.snp.bottom)
            make.left.right.equalTo(view)
        }
        
        requestGoods()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 懒加载UITableView
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.dataSource = self
        table.delegate = self
        table.tableFooterView = UIView()
        table.separatorColor = kGrayLineColor
        
        table.register(GYZSelectReceivedGoodsCell.self, forCellReuseIdentifier: receivedGoodsCell)
        
        return table
    }()
    
    /// 确定收货按钮
    fileprivate lazy var receivedGoodsBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitle("确定收货", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(clickReceivedGoodsBtn), for: .touchUpInside)
        return btn
    }()
    
    /// 获取订单商品信息
    func requestGoods(){
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("Order/orderGoods",parameters: ["order_id":orderId,"type":type],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                let data = response["result"]
                guard let info = data["info"].array else { return }
                
                for item in info{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = OrderGoodsModel.init(dict: itemInfo)
                    
                    weakSelf?.goodsModels.append(model)
                }
                
                if weakSelf?.goodsModels.count > 0{
                    weakSelf?.tableView.reloadData()
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
        })
    }
    
    /// 确定收货
    func clickReceivedGoodsBtn(){
        if selectGoods.count > 0 {
            weak var weakSelf = self
            GYZAlertViewTools.alertViewTools.showAlert(title: "提示", message: "确定收货吗？", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { (index) in
                
                if index != -1{
                    //确定收货
                    weakSelf?.requestUpdateGoodsState()
                }
            }
        }else{
            MBProgressHUD.showAutoDismissHUD(message: "请选择收货商品")
        }
    }

    /// 部分确认收货接口
    func requestUpdateGoodsState(){
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        var ids: String = ""
        for item in selectGoods {
            ids += item.value + ";"
        }
        ids = ids.substring(to: ids.index(ids.startIndex, offsetBy: ids.characters.count - 1))
        
        GYZNetWork.requestNetwork("Order/updateOrderGoodsType",parameters: ["order_id":orderId,"type":"1","goods_id":ids],  success: { (response) in
            
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
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodsModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: receivedGoodsCell) as! GYZSelectReceivedGoodsCell
        
        let item = goodsModels[indexPath.row]
        cell.logoImgView.kf.setImage(with: URL.init(string: item.goods_thumb_img!), placeholder: UIImage.init(named: "icon_goods_default"), options: nil, progressBlock: nil, completionHandler: nil)
        cell.nameLab.text = item.cn_name
        
        if selectGoods.keys.contains(item.goods_id!){//是否选择
            cell.checkBtn.isSelected = true
        }else{
            cell.checkBtn.isSelected = false
        }
        
        cell.selectionStyle = .none
        return cell
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = goodsModels[indexPath.row]
        
        if selectGoods.keys.contains(item.goods_id!){//是否选择
            selectGoods.removeValue(forKey: item.goods_id!)
        }else{
            selectGoods[item.goods_id!] = item.goods_id!
        }
        self.tableView.reloadData()
    }
}
