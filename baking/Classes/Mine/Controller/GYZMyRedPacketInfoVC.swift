//
//  GYZMyRedPacketInfoVC.swift
//  baking
//  我的红包 列表
//  Created by gouyz on 2017/9/12.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

private let myRedPacketCell = "myRedPacketCell"

class GYZMyRedPacketInfoVC: GYZBaseVC,UITableViewDelegate,UITableViewDataSource {
    
    ///红包类型 0我的红包 1商家红包
    var redPacketType : Int = 0
    var currPage : Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
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
        
//        table.register(GYZMyRedPacketCell.self, forCellReuseIdentifier: myRedPacketCell)
        table.register(GYZBusinessRedPacketCell.self, forCellReuseIdentifier: myRedPacketCell)
        
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
    
    
    // MARK: - 上拉加载更多/下拉刷新
    /// 下拉刷新
    func refresh(){
        currPage = 1
//        requestOrderDatas()
    }
    
    /// 上拉加载更多
    func loadMore(){
        currPage += 1
//        requestOrderDatas()
    }
    
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing(){//下拉刷新
//            baoShiModels.removeAll()
            GYZTool.endRefresh(scorllView: tableView)
        }else if tableView.mj_footer.isRefreshing(){//上拉加载更多
            GYZTool.endLoadMore(scorllView: tableView)
        }
    }

    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: myRedPacketCell) as! GYZMyRedPacketCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: myRedPacketCell) as! GYZBusinessRedPacketCell
        
        cell.selectionStyle = .none
        return cell
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
}
