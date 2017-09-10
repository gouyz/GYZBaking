//
//  GYZCategoryDetailsVC.swift
//  baking
//  某分类的产品列表
//  Created by gouyz on 2017/3/26.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import DOPDropDownMenu_Enhanced
import MBProgressHUD

private let categoryDetailsCell = "categoryDetailsCell"

class GYZCategoryDetailsVC: GYZBaseVC,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    var categoryModels: [GYZCategoryModel] = [GYZCategoryModel]()
    var sortModels: [GYZSortModel] = [GYZSortModel]()
    
    var goodsModels: [GoodInfoModel] = [GoodInfoModel]()
    
    var categoriesArr: [String] = [String]()
    var sortsArr: [String] = [String]()
    let sortsIconArr: [String] = ["icon_sort","icon_distance","icon_sell","icon_start_send","icon_person_most"]
    
    var currPage : Int = 1
    
    /// 当前分类ID
    var mCurrCategoryId: String = "0"
    /// 当前排序ID
    var mCurrSortId: String = "0"
    ///1通货市场 2商家立减
    var type: String = "0"

    override func viewDidLoad() {
        super.viewDidLoad()

        if type == "1" {
            self.title = "通货市场"
        }else{
            self.title = "商家立减"
        }
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named:"icon_search_white"), style: .done, target: self, action: #selector(searchClick))
        
//        dropDownMenu = DOPDropDownMenu.init(origin: CGPoint.init(x: 0, y: 0), andHeight: kTitleHeight)
//        dropDownMenu.textColor = kGaryFontColor
//        dropDownMenu.indicatorColor = kGaryFontColor
//        dropDownMenu.textSelectedColor = kYellowFontColor
//        dropDownMenu.delegate = self
//        dropDownMenu.dataSource = self
//        view.addSubview(dropDownMenu)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
//        requestCategoryData()
//        requestSortData()
        requestGoodsListData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collView.dataSource = self
        collView.delegate = self
        collView.backgroundColor = kBackgroundColor
        
        collView.register(GYZCategoryDetailsCell.self, forCellWithReuseIdentifier: categoryDetailsCell)
        
        weak var weakSelf = self
        ///添加下拉刷新
        GYZTool.addPullRefresh(scorllView: collView, pullRefreshCallBack: {
            weakSelf?.refresh()
        })
        ///添加上拉加载更多
        GYZTool.addLoadMore(scorllView: collView, loadMoreCallBack: {
            weakSelf?.loadMore()
        })
        
        return collView
    }()
    
    ///下拉菜单
    lazy var dropDownMenu: DOPDropDownMenu = DOPDropDownMenu()
    /// 搜索
    func searchClick(){
        let searchVC = GYZSearchGoodsVC()
        
        let navVC = GYZBaseNavigationVC(rootViewController : searchVC)
        self.present(navVC, animated: false, completion: nil)
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
    
    ///获取商品数据
    func requestGoodsListData(){
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Goods/goodsList",parameters: ["type":type,"sort": mCurrSortId,"p":currPage],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            weakSelf?.closeRefresh()
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                let data = response["result"]
                guard let info = data["info"].array else { return }
                
                for item in info{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = GoodInfoModel.init(dict: itemInfo)
                    
                    weakSelf?.goodsModels.append(model)
                }
                if weakSelf?.goodsModels.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.collectionView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无商品信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
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
        requestGoodsListData()
    }
    
    /// 上拉加载更多
    func loadMore(){
        currPage += 1
        requestGoodsListData()
    }
    
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if collectionView.mj_header.isRefreshing(){//下拉刷新
            goodsModels.removeAll()
            GYZTool.endRefresh(scorllView: collectionView)
        }else if collectionView.mj_footer.isRefreshing(){//上拉加载更多
            GYZTool.endLoadMore(scorllView: collectionView)
        }
    }
    
    // MARK: UICollectionViewDataSource 代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodsModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryDetailsCell, for: indexPath) as! GYZCategoryDetailsCell
        cell.dataModel = goodsModels[indexPath.row]
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let shopVC = GYZBusinessVC()
        shopVC.shopId = goodsModels[indexPath.row].member_id!
        shopVC.selectGoodsInfo = goodsModels[indexPath.row]
        navigationController?.pushViewController(shopVC, animated: true)
    }

    //MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (kScreenWidth-kMargin*2)*0.5, height: 230)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: kMargin, left: 5, bottom: 0, right: 5)
    }
}

extension GYZCategoryDetailsVC : DOPDropDownMenuDataSource,DOPDropDownMenuDelegate{
    
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
        
        goodsModels.removeAll()
        createHUD(message: "加载中...")
        requestGoodsListData()
    }
}
