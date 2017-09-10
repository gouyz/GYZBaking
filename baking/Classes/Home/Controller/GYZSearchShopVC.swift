//
//  GYZSearchShopVC.swift
//  baking
//  搜索店铺 
//  Created by gouyz on 2017/4/24.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let searchShopCell = "searchShopCell"

class GYZSearchShopVC: GYZBaseVC,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {
    
    /// 店铺名称
    var shopName: String = ""
    var shopModels: [GYZShopModel] = [GYZShopModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupUI(){
        
        navigationItem.titleView = searchBar
        
        let btn = UIButton(type: .custom)
        btn.setTitle("取消", for: .normal)
        btn.titleLabel?.font = k14Font
        btn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        btn.addTarget(self, action: #selector(cancleSearchClick), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
    }
    
    /// 懒加载UITableView
    fileprivate lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.dataSource = self
        table.delegate = self
        table.tableFooterView = UIView()
        table.separatorColor = kGrayLineColor
        
        table.register(GYZSendBusinessCell.self, forCellReuseIdentifier: searchShopCell)
        return table
    }()
    
    /// 搜索框
    lazy var searchBar : UISearchBar = {
        let search = UISearchBar()
        
        search.backgroundImage = UIImage.init(named: "icon_search_clearbg")
        search.placeholder = "请输入店铺名称"
        search.delegate = self
        //显示输入光标
        search.tintColor = kYellowFontColor
        //弹出键盘
        search.becomeFirstResponder()
        
        return search
    }()
    
    /// 取消搜索
    func cancleSearchClick(){
        searchBar.resignFirstResponder()
        
        self.dismiss(animated: false, completion: nil)
    }
    ///mark - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        shopName = searchBar.text!
        if shopName.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入搜索内容")
            return
        }
        shopModels.removeAll()
        requestShopListData()
    }
    
    ///获取商家数据
    func requestShopListData(){
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("Member/seachByMemberName",parameters: ["user_id":userDefaults.string(forKey: "userId") ?? "","key":shopName],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                let data = response["result"]
                guard let info = data["info"].array else { return }
                
                for item in info{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = GYZShopModel.init(dict: itemInfo)
                    
                    weakSelf?.shopModels.append(model)
                }
                
                if weakSelf?.shopModels.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无店铺信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
        })
    }
    
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: searchShopCell) as! GYZSendBusinessCell
        cell.dataModel = shopModels[indexPath.row]
        
        cell.selectionStyle = .none
        return cell
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = shopModels[indexPath.row]
        let businessVC = GYZBusinessVC()
        businessVC.shopId = item.id!
        navigationController?.pushViewController(businessVC, animated: true)
    }

}
