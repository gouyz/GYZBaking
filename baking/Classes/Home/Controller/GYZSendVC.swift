//
//  GYZSendVC.swift
//  baking
//
//  Created by gouyz on 2017/3/25.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import DOPDropDownMenu_Enhanced
import MBProgressHUD


private let sendCell = "sendCell"

//设置跳转来源
enum SourceViewType: Int {
    case send = 1  //同城配送
    case hot     //热门市场
    case recommend //新店推荐
    case good     //今日好店
    case favourite     //我的收藏
    case category     //分类获取商家
}


class GYZSendVC: GYZBaseVC,UITableViewDelegate,UITableViewDataSource {
    
    var categoryModels: [GYZCategoryModel] = [GYZCategoryModel]()
    var sortModels: [GYZSortModel] = [GYZSortModel]()
    
    var shopModels: [GYZShopModel] = [GYZShopModel]()
    
    var categoriesArr: [String] = [String]()
    var sortsArr: [String] = [String]()
    let sortsIconArr: [String] = ["icon_sort","icon_distance","icon_sell","icon_start_send","icon_person_most"]
    
    var sourceType: SourceViewType = .send
    //分类获取商家时，分类名称
    var categoryName: String = "";
    
    /// 当前分类ID
    var mCurrCategoryId: String = "0"
    /// 当前排序ID
    var mCurrSortId: String = "0"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named:"icon_search_white"), style: .done, target: self, action: #selector(searchClick))
        
        switch sourceType {
        case .hot:
            self.title = "热门市场"
        case .recommend:
            self.title = "新店推荐"
        case .good:
            self.title = "每日好店"
        case .favourite:
            self.title = "我的收藏"
            navigationItem.rightBarButtonItem = nil
        case .category: //分类获取商家
            self.title = categoryName
        default:
            self.title = "同城配送"
        }
        
        dropDownMenu = DOPDropDownMenu.init(origin: CGPoint.init(x: 0, y: 0), andHeight: kTitleHeight)
        dropDownMenu.textColor = kGaryFontColor
        dropDownMenu.indicatorColor = kGaryFontColor
        dropDownMenu.textSelectedColor = kYellowFontColor
        dropDownMenu.delegate = self
        dropDownMenu.dataSource = self
        view.addSubview(dropDownMenu)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(dropDownMenu.snp.bottom)
        }
        
        requestCategoryData()
        requestSortData()
    
        requestDataType()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ///下拉菜单
    lazy var dropDownMenu: DOPDropDownMenu = DOPDropDownMenu()
    
    /// 懒加载UITableView
    fileprivate lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.dataSource = self
        table.delegate = self
        table.tableFooterView = UIView()
        table.separatorColor = kGrayLineColor
        
        table.register(GYZSendBusinessCell.self, forCellReuseIdentifier: sendCell)
        return table
    }()

    /// 搜索 
    func searchClick(){
        let searchVC = GYZSearchShopVC()
        
        let navVC = GYZBaseNavigationVC(rootViewController : searchVC)
        self.present(navVC, animated: false, completion: nil)
    }
    
    /// 网络请求
    func requestDataType(){
        
        var params: [String:Any] = [String:Any]()
        params["user_id"] = userDefaults.string(forKey: "userId") ?? ""
        params["class_id"] = mCurrCategoryId
        params["sort"] = mCurrSortId
        
        switch sourceType {
        case .hot://热门市场
            params["ads_longitude"] = userDefaults.double(forKey: "currlongitude")
            params["ads_latitude"] = userDefaults.double(forKey: "currlatitude")
            requestShopListData(url: "Member/hotShop",param: params)
        case .recommend://新店推荐
            params["ads_longitude"] = userDefaults.double(forKey: "currlongitude")
            params["ads_latitude"] = userDefaults.double(forKey: "currlatitude")
            requestShopListData(url: "Member/newShop",param: params)
        case .good://每日好店
            params["ads_longitude"] = userDefaults.double(forKey: "currlongitude")
            params["ads_latitude"] = userDefaults.double(forKey: "currlatitude")
            requestShopListData(url: "Member/goodShop",param: params)
        case .favourite://我的收藏
            requestShopListData(url: "User/collectList",param: params)
        case .category: //分类获取商家
            requestShopListData(url: "Member/seachByClass",param: params)
        default:
            //同城配送
            params["ads_longitude"] = userDefaults.double(forKey: "currlongitude")
            params["ads_latitude"] = userDefaults.double(forKey: "currlatitude")
            requestShopListData(url: "Member/cityShop",param: params)
        }
    }
    
    ///获取分类数据
    func requestCategoryData(){
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Goods/classList",  success: { (response) in
            
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                let data = response["result"]
                guard let info = data["info"].array else { return }
                
                ///添加全部
                weakSelf?.categoriesArr.append("全部")
                for item in info{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = GYZCategoryModel.init(dict: itemInfo)
                    
                    weakSelf?.categoriesArr.append(model.class_cn_name!)
                    weakSelf?.categoryModels.append(model)
                }
                
                weakSelf?.dropDownMenu.reloadData()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    ///获取排序数据
    func requestSortData(){
        
        weak var weakSelf = self
        
        GYZNetWork.requestNetwork("Member/sortList",  success: { (response) in
            
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                let data = response["result"]
                guard let info = data["info"].array else { return }
                
                for item in info{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = GYZSortModel.init(dict: itemInfo)
                    weakSelf?.sortsArr.append(model.name!)
                    weakSelf?.sortModels.append(model)
                }
                
                weakSelf?.dropDownMenu.reloadData()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    ///获取商家数据
    func requestShopListData(url: String,param : [String:Any]){
        
        weak var weakSelf = self
        
        GYZNetWork.requestNetwork(url,parameters: param,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
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
                    weakSelf?.showEmptyView(content:"暂无信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    ///删除收藏
    func requestDeleteFavourite(favouriteId: String,index: Int){
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("User/delCollect", parameters: ["collect_id":favouriteId,"user_id":userDefaults.string(forKey: "userId") ?? ""], success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.shopModels.remove(at: index)
                
                weakSelf?.tableView.reloadData()
            }
            MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            
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
        return shopModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: sendCell) as! GYZSendBusinessCell
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
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
//        if sourceType == .favourite {
//            return "删除"
//        }
        return "删除"
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        if sourceType == .favourite {
            return .delete
        }
        return .none
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {//删除收藏
            
            requestDeleteFavourite(favouriteId: shopModels[indexPath.row].collect_id!, index: indexPath.row)
        }
    }
}

extension GYZSendVC : DOPDropDownMenuDataSource,DOPDropDownMenuDelegate{
    
    ///MARK DOPDropDownMenuDataSource
    //返回当前显示的MenuTitle列总数
    func numberOfColumns(in menu: DOPDropDownMenu!) -> Int {
        return 2
    }
    ///返回 menu 第column列有多少行
    func menu(_ menu: DOPDropDownMenu!, numberOfRowsInColumn column: Int) -> Int {
        if column == 0 {
            return categoriesArr.count
        }
        
        return sortsArr.count
    }
    ///返回 menu 第column列 每行title
    func menu(_ menu: DOPDropDownMenu!, titleForRowAt indexPath: DOPIndexPath!) -> String! {
        if indexPath.column == 0 {
            if categoriesArr.count == 0 {
                return ""
            }
            return categoriesArr[indexPath.row]
        }
        
        if sortsArr.count == 0 {
            return ""
        }
        return sortsArr[indexPath.row]
    }
    /// 返回 menu 第column列 每行image
    func menu(_ menu: DOPDropDownMenu!, imageNameForRowAt indexPath: DOPIndexPath!) -> String! {
        if indexPath.column == 1 {
            return sortsIconArr[indexPath.row]
        }
        return nil
    }
    ///MARK DOPDropDownMenuDelegate
    func menu(_ menu: DOPDropDownMenu!, didSelectRowAt indexPath: DOPIndexPath!) {
        if indexPath.column == 0 {
            if indexPath.row == 0 {
                mCurrCategoryId = "0"
            } else {
                let model = categoryModels[indexPath.row - 1]
                mCurrCategoryId = model.class_id!
            }
        }else {
            let model = sortModels[indexPath.row]
            mCurrSortId = model.sort_id!
        }
        createHUD(message: "加载中...")
        shopModels.removeAll()
        requestDataType()
    }
}
