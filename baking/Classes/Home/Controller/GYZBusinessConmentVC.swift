//
//  GYZBusinessConmentVC.swift
//  baking
//  店铺评价
//  Created by gouyz on 2017/4/2.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol GYZBusinessConmentVCDelegate{
    func conmentDidScrollPassY(_ tableviewScrollY:CGFloat)
}

private let businessConmentCell = "businessConmentCell"
private let businessConmentHeader = "businessConmentHeader"

class GYZBusinessConmentVC: UITableViewController {
    
    var delegate:GYZBusinessConmentVCDelegate?
    var currPage : Int = 1
    /// 商家ID
    var memberId: String = ""
    
    var conmentModels: [GYZBusinessConmentModel] = [GYZBusinessConmentModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = kBackgroundColor
        
        // 设置大概高度
        self.tableView.estimatedRowHeight = 110
        // 设置行高为自动适配
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
        
        self.tableView.separatorColor = kGrayLineColor
        self.tableView.register(GYZBusinessConmentCell.self, forCellReuseIdentifier: businessConmentCell)
//        self.tableView.register(GYZBusinessConmentHeaderView.self, forHeaderFooterViewReuseIdentifier: businessConmentHeader)
        
        weak var weakSelf = self
        ///添加下拉刷新
        GYZTool.addPullRefresh(scorllView: tableView, pullRefreshCallBack: {
            weakSelf?.refresh()
        })
        ///添加上拉加载更多
        GYZTool.addLoadMore(scorllView: tableView, loadMoreCallBack: {
            weakSelf?.loadMore()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ///获取商家评论数据
    func requestConmentListData(){
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("Goods/commentByMember",parameters: ["p":currPage,"member_id":memberId],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            weakSelf?.closeRefresh()
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                let data = response["result"]
                guard let info = data["info"].array else { return }
                
                for item in info{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = GYZBusinessConmentModel.init(dict: itemInfo)
                    
                    weakSelf?.conmentModels.append(model)
                }
                if weakSelf?.conmentModels.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无评论信息")
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
                })
            }
        })
    }
    
    
    // MARK: - 上拉加载更多/下拉刷新
    /// 下拉刷新
    func refresh(){
        currPage = 1
        requestConmentListData()
    }
    
    /// 上拉加载更多
    func loadMore(){
        currPage += 1
        requestConmentListData()
    }
    
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing(){//下拉刷新
            conmentModels.removeAll()
            GYZTool.endRefresh(scorllView: tableView)
        }else if tableView.mj_footer.isRefreshing(){//上拉加载更多
            GYZTool.endLoadMore(scorllView: tableView)
        }
    }

    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conmentModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: businessConmentCell) as! GYZBusinessConmentCell
        
        cell.dataModel = conmentModels[indexPath.row]
        
        cell.selectionStyle = .none
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: businessConmentHeader) as! GYZBusinessConmentHeaderView
//        
//        return headerView
//    }
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return kMargin
//    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.conmentDidScrollPassY(scrollView.contentOffset.y)
        
    }
}
