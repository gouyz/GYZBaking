//
//  GYZMyRedPacketInfoVC.swift
//  baking
//  我的红包 列表
//  Created by gouyz on 2017/9/12.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let myRedPacketCell = "myRedPacketCell"
private let myRedPacketBusinessCell = "myRedPacketBusinessCell"

class GYZMyRedPacketInfoVC: GYZBaseVC,UITableViewDelegate,UITableViewDataSource {
    
    ///红包类型 1我的红包 0商家红包
    var redPacketType : String = "1"
    var currPage : Int = 1
    
    var redPacketmodels: [GYZRedPacketInfoModel] = [GYZRedPacketInfoModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        requestRedPacketData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.tableFooterView = UIView()
        table.separatorStyle = .none
        
        table.register(GYZMyRedPacketCell.self, forCellReuseIdentifier: myRedPacketCell)
        table.register(GYZBusinessRedPacketCell.self, forCellReuseIdentifier: myRedPacketBusinessCell)
        
        weak var weakSelf = self
        ///添加下拉刷新
        GYZTool.addPullRefresh(scorllView: table, pullRefreshCallBack: {
            weakSelf?.refresh()
        })
//        ///添加上拉加载更多
//        GYZTool.addLoadMore(scorllView: table, loadMoreCallBack: {
//            weakSelf?.loadMore()
//        })
        return table
    }()
    
    ///获取红包列表数据
    func requestRedPacketData(){
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Index/myCoupon", parameters :["type":redPacketType,"user_id":"29866"/*userDefaults.string(forKey: "userId") ?? ""*/], success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            weakSelf?.closeRefresh()
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                let data = response["result"]
                guard let info = data["info"].array else { return }
                
                for item in info{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = GYZRedPacketInfoModel.init(dict: itemInfo)
                    
                    weakSelf?.redPacketmodels.append(model)
                }
                
                if weakSelf?.redPacketmodels.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            weakSelf?.closeRefresh()
            GYZLog(error)
        })
    }
    
    // MARK: - 上拉加载更多/下拉刷新
    /// 下拉刷新
    func refresh(){
        currPage = 1
        requestRedPacketData()
    }
    
    /// 上拉加载更多
    func loadMore(){
        currPage += 1
//        requestOrderDatas()
    }
    
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing(){//下拉刷新
            redPacketmodels.removeAll()
            GYZTool.endRefresh(scorllView: tableView)
        }
//        else if tableView.mj_footer.isRefreshing(){//上拉加载更多
//            GYZTool.endLoadMore(scorllView: tableView)
//        }
    }

    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return redPacketmodels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if redPacketType == "1"{//我的红包 签约
            let cell = tableView.dequeueReusableCell(withIdentifier: myRedPacketCell) as! GYZMyRedPacketCell
            
            cell.dataModel = redPacketmodels[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: myRedPacketBusinessCell) as! GYZBusinessRedPacketCell
            
            cell.dataModel = redPacketmodels[indexPath.row]
            
            cell.selectionStyle = .none
            return cell
        }
        
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
}
