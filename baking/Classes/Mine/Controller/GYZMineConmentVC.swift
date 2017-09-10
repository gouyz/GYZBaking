//
//  GYZMineConmentVC.swift
//  baking
//  我的评价
//  Created by gouyz on 2017/4/2.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD


private let mineConmentCell = "mineConmentCell"
private let mineConmentHeader = "mineConmentHeader"

class GYZMineConmentVC: GYZBaseVC,UITableViewDelegate,UITableViewDataSource {
    
    var currPage : Int = 1
    
    var mineConmentModels: [GYZMineConmentModel] = [GYZMineConmentModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的评价"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        requestConmentListData()
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
        table.separatorStyle = .none
        // 设置大概高度
        table.estimatedRowHeight = 60
        // 设置行高为自动适配
        table.rowHeight = UITableViewAutomaticDimension
        
        table.register(GYZConmentCell.self, forCellReuseIdentifier: mineConmentCell)
        table.register(GYZMineConmentHeaderView.self, forHeaderFooterViewReuseIdentifier: mineConmentHeader)
        
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
    
    ///获取评论数据
    func requestConmentListData(){
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("Order/commentList",parameters: ["p":currPage,"user_id":userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            weakSelf?.closeRefresh()
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                let data = response["result"]
                guard let info = data["info"].array else { return }
                
                for item in info{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = GYZMineConmentModel.init(dict: itemInfo)
                    
                    weakSelf?.mineConmentModels.append(model)
                }
                if weakSelf?.mineConmentModels.count > 0{
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
            mineConmentModels.removeAll()
            GYZTool.endRefresh(scorllView: tableView)
        }else if tableView.mj_footer.isRefreshing(){//上拉加载更多
            GYZTool.endLoadMore(scorllView: tableView)
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return mineConmentModels.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: mineConmentCell) as! GYZConmentCell
        
//        if indexPath.section % 2 == 0 {
//            cell.imageViews.isHidden = true
//            cell.imageViews.snp.updateConstraints({ (make) in
//                make.height.equalTo(0)
//            })
//        }else{
//            cell.imageViews.isHidden = false
//            cell.imageViews.imgViewFour.isHidden = true
//            cell.imageViews.snp.updateConstraints({ (make) in
//                make.height.equalTo(kBusinessImgHeight)
//            })
//        }
        cell.dataModel = mineConmentModels[indexPath.section]
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: mineConmentHeader) as! GYZMineConmentHeaderView
        
        headerView.dataModel = mineConmentModels[section]
        headerView.tag = section
        headerView.addOnClickListener(target: self, action: #selector(goBusinessDetail(sender:)))
        
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return kMargin
    }
    
    /// 店铺详情
    func goBusinessDetail(sender: UITapGestureRecognizer){
        
        let businessVC = GYZBusinessVC()
        businessVC.shopId = (mineConmentModels[(sender.view?.tag)!].member_info?.member_id)!
        navigationController?.pushViewController(businessVC, animated: true)
    }
}
