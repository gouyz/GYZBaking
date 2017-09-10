//
//  GYZSearchGoodsVC.swift
//  baking
//  搜索商品
//  Created by gouyz on 2017/4/24.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let searchGoodsCell = "searchGoodsCell"

class GYZSearchGoodsVC: GYZBaseVC,UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    /// 商品名称
    var goodsName: String = ""
    var currPage : Int = 1
    var goodsModels: [GoodInfoModel] = [GoodInfoModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
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
        
        collView.register(GYZCategoryDetailsCell.self, forCellWithReuseIdentifier: searchGoodsCell)
        
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
    func setupUI(){
        
        navigationItem.titleView = searchBar
        
        let btn = UIButton(type: .custom)
        btn.setTitle("取消", for: .normal)
        btn.titleLabel?.font = k14Font
        btn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        btn.addTarget(self, action: #selector(cancleSearchClick), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
    }
    
    /// 搜索框
    lazy var searchBar : UISearchBar = {
        let search = UISearchBar()
        
        search.backgroundImage = UIImage.init(named: "icon_search_clearbg")
        search.placeholder = "请输入商品名称"
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
    
    ///获取商品数据
    func requestGoodsListData(){
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("Goods/seachByClass",parameters: ["key":goodsName,"p":currPage,"user_id":userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchGoodsCell, for: indexPath) as! GYZCategoryDetailsCell
        cell.dataModel = goodsModels[indexPath.row]
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let goodsDetailVC = GYZGoodsDetailsVC()
        goodsDetailVC.goodId = goodsModels[indexPath.row].id!
        navigationController?.pushViewController(goodsDetailVC, animated: true)
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (kScreenWidth-kMargin*2)*0.5, height: 230)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: kMargin, left: 5, bottom: 0, right: 5)
    }

    
    ///mark - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        goodsName = searchBar.text!
        if goodsName.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入搜索内容")
            return
        }
        currPage = 1
        goodsModels.removeAll()
        requestGoodsListData()
    }
}
