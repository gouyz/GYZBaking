//
//  GYZGoodsDetailsVC.swift
//  baking
//  商品详情
//  Created by gouyz on 2017/4/17.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import SKPhotoBrowser

private let goodsDetailsCell = "goodsDetailsCell"
private let goodsDetailsConmentHeader = "goodsDetailsConmentHeader"

class GYZGoodsDetailsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var hud : MBProgressHUD?
    /// 商品ID
    var goodId: String = ""
    
    var detailsModel: GYZGoodsDetailModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        navBarBgAlpha = 0
        let leftBtn = UIButton(type: .custom)
        leftBtn.backgroundColor = kYellowFontColor
        leftBtn.setImage(UIImage(named: "icon_black_white"), for: .normal)
        leftBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        leftBtn.addTarget(self, action: #selector(clickedBackBtn), for: .touchUpInside)
        leftBtn.cornerRadius = 22
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBtn)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(-kTitleAndStateHeight, 0, 0, 0))
        }
        tableView.tableHeaderView = headerView
        headerView.headerImg.addOnClickListener(target: self, action: #selector(clickImgDetail))
        
        requestGoodsDetailData()
    }
    
    /// 返回
    func clickedBackBtn() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navBarBgAlpha = 1
    }
    func clickImgDetail(){
        let urlArr = GYZTool.getImgUrls(url: detailsModel?.goods_img)
        if urlArr == nil {
            return
        }
        let browser = SKPhotoBrowser(photos: createWebPhotos(urls: urlArr))
        browser.initializePageIndex(0)
//        browser.delegate = self
        
        present(browser, animated: true, completion: nil)
        
    }
    
    func createWebPhotos(urls: [String]?) -> [SKPhotoProtocol] {
        return (0..<(urls?.count)!).map { (i: Int) -> SKPhotoProtocol in
            
            let photo = SKPhoto.photoWithImageURL((urls?[i])!)
            SKPhotoBrowserOptions.displayToolbar = false
            //            photo.shouldCachePhotoURLImage = true
            return photo
        }
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
        // 设置大概高度
        table.estimatedRowHeight = 110
        // 设置行高为自动适配
        table.rowHeight = UITableViewAutomaticDimension
        
        table.register(GYZBusinessConmentCell.self, forCellReuseIdentifier: goodsDetailsCell)
        table.register(GYZGoodsConmentHeader.self, forHeaderFooterViewReuseIdentifier: goodsDetailsConmentHeader)
        return table
    }()
    
    lazy var headerView: GYZGoodsDetailsHeaderView = GYZGoodsDetailsHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 300))
    
    /// 创建HUD
    func createHUD(message: String){
        if hud == nil {
            hud = MBProgressHUD.showHUD(message: message,toView: view)
        }else{
            hud?.show(animated: true)
        }
    }
    ///获取商品详情数据
    func requestGoodsDetailData(){
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Goods/goodsInfo", parameters : ["good_id" : goodId], success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                let data = response["result"]
                guard let info = data["info"].dictionaryObject else { return }
                
                weakSelf?.detailsModel = GYZGoodsDetailModel.init(dict: info)
                
                weakSelf?.headerView.dataModel = weakSelf?.detailsModel
                
                weakSelf?.tableView.reloadData()
                
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
        return detailsModel?.comment == nil ? 0 : (detailsModel?.comment?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: goodsDetailsCell) as! GYZBusinessConmentCell
        
        cell.dataModel = detailsModel?.comment?[indexPath.row]
        
        cell.selectionStyle = .none
        return cell
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: goodsDetailsConmentHeader) as! GYZGoodsConmentHeader
        
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kTitleHeight
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    //MARK:UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        // 禁止下拉
        if scrollView.contentOffset.y <= 0 {
            scrollView.contentOffset.y = 0
            return
        }
        
        let contentOffsetY = scrollView.contentOffset.y
        let showNavBarOffsetY = 200 - topLayoutGuide.length
        
        
        //navigationBar alpha
        if contentOffsetY > showNavBarOffsetY  {
            var navAlpha = (contentOffsetY - (showNavBarOffsetY)) / 40.0
            if navAlpha > 1 {
                navAlpha = 1
            }
            navBarBgAlpha = navAlpha
        }else{
            navBarBgAlpha = 0
        }
    }
}
