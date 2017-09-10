//
//  GYZBusinessVC.swift
//  baking
//  店铺详情页
//  Created by gouyz on 2017/3/27.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD


/** 偏移方法操作枚举 */
enum headerMenuShowType:UInt {
    case up = 1 // 固定在navigation上面
    case buttom = 2 // 固定在navigation下面
}

class GYZBusinessVC: GYZBaseVC,UIScrollViewDelegate,GYZSegmentViewDelegate,GYZGoodsVCDelegate,GYZBusinessConmentVCDelegate,GYZBusinessDetailVCDelegate,GYZBusinessHeaderViewDelegate {
    
    var backgroundScrollView:UIScrollView?// 底部scrollView
    var menuView:GYZSegmentView!// 菜单
    var headerView:GYZBusinessHeaderView!
    var topView:GYZNavBarView!// 假TitleView
    
    var tableViewArr:Array<UIScrollView> = []// 存放scrollView
    
    var titlesArr:Array = ["商品","评价","商家"]  // 存放菜单的内容
    var scrollY:CGFloat = 0// 记录当偏移量
    var scrollX:CGFloat = 0// 记录当偏移量
    var navigaionTitle: String? // title
    
    let goodsVC = GYZGoodsVC()
    let detailVC = GYZBusinessDetailVC(style: UITableViewStyle.grouped)
    
    /// 商家ID
    var shopId: String = ""
    var shopGoodsModels: GYZShopGoodsModel?
    ///选择的商品信息，用于定位商品位置
    var selectGoodsInfo: GoodInfoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named:"icon_search_white"), style: .done, target: self, action: #selector(searchClick))
        
        setUI()
        requestCartInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isTranslucent = true
        // didAppear隐藏,不会让整个页面向上移动64
        self.navigationController?.navigationBar.alpha = 0
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
        // 消失的时候恢复
        self.navigationController?.navigationBar.alpha = 1
    }
    func setUI(){
        self.automaticallyAdjustsScrollViewInsets = false
        layoutBackgroundScrollView()
        layoutHeaderMenuView()
        layoutTopView()
    }
    
    /** 创建底部scrollView,并将tableViewController添加到上面 */
    func layoutBackgroundScrollView(){
        // 需要创建到高度0上,所以backgroundScrollView.y要等于-64
        self.backgroundScrollView = UIScrollView(frame:CGRect(x: 0,y: 0,width: kScreenWidth,height: kScreenHeight))
        self.backgroundScrollView?.isPagingEnabled = true
        self.backgroundScrollView?.bounces = false
        self.backgroundScrollView?.delegate = self
        let floatArrCount = CGFloat(titlesArr.count)
        self.backgroundScrollView?.contentSize = CGSize(width: floatArrCount*kScreenWidth,height: self.view.frame.size.height)
        
        // 给scrollY赋初值避免一上来滑动就乱
        scrollY = -kScrollHorizY // tableView自己持有的偏移量和赋值时给的偏移量符号是相反的
        
        ///添加商品view
        // tableView顶部流出HeaderView和MenuView的位置
        goodsVC.leftTableView.contentInset = UIEdgeInsetsMake(kScrollHorizY, 0, 0, 0 )
        goodsVC.rightTableView.contentInset = UIEdgeInsetsMake(kScrollHorizY, 0, 0, 0 )
        goodsVC.delegate = self
        goodsVC.shopId = shopId
        goodsVC.view.frame = CGRect(x: 0,y: 0, width: kScreenWidth, height: kScreenHeight)
    
        // 将tableViewVC添加进数组方便管理
        tableViewArr.append(goodsVC.rightTableView)
        self.addChildViewController(goodsVC)
        // 需要用到的时候再添加到view上,避免一上来就占用太多资源
        backgroundScrollView?.addSubview(goodsVC.rightTableView)
        backgroundScrollView?.addSubview(goodsVC.leftTableView)
        backgroundScrollView?.addSubview(goodsVC.bottomView)
        backgroundScrollView?.addSubview(goodsVC.topScrollView)
        
        ///添加评论
        let conmentVC = GYZBusinessConmentVC(style: UITableViewStyle.plain)
        // tableView顶部流出HeaderView和MenuView的位置
        conmentVC.tableView.contentInset = UIEdgeInsetsMake(kScrollHorizY, 0, 0, 0 )
        conmentVC.delegate = self
        conmentVC.memberId = shopId
        conmentVC.view.frame = CGRect(x: kScreenWidth,y: 0, width: self.view.frame.size.width, height: kScreenHeight)
        
        // 将tableViewVC添加进数组方便管理
        tableViewArr.append(conmentVC.tableView)
        self.addChildViewController(conmentVC)
        conmentVC.requestConmentListData()
        
        //let detailVC = GYZBusinessDetailVC(style: UITableViewStyle.grouped)
        // tableView顶部流出HeaderView和MenuView的位置
        detailVC.tableView.contentInset = UIEdgeInsetsMake(kScrollHorizY, 0, 0, 0 )
        detailVC.delegate = self
        detailVC.view.frame = CGRect(x: 2 * kScreenWidth,y: 0, width: self.view.frame.size.width, height: kScreenHeight)
        
        // 将tableViewVC添加进数组方便管理
        tableViewArr.append(detailVC.tableView)
        self.addChildViewController(detailVC)
        self.view.addSubview(backgroundScrollView!)
        
    }
    
    /** 创建HeaderView和MenuView */
    func layoutHeaderMenuView(){
        // headerView
        headerView = GYZBusinessHeaderView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kHeaderHight))
        headerView.delegate = self
        self.view.addSubview(headerView)
        
        // MenuView
        menuView = GYZSegmentView(frame:CGRect(x: 0,y: headerView.frame.maxY,width: kScreenWidth,height: kTitleHeight))
        menuView.delegate = self
        menuView.setUIWithArr(titlesArr)
        self.view.addSubview(self.menuView)
    }
    
    // 搭建假NAvigation...
    func layoutTopView(){
        // 创建假Title
        topView = GYZNavBarView.init(frame: CGRect(x: 0,y: 0, width: kScreenWidth, height: kTitleAndStateHeight))
        self.view.addSubview(topView)
        
        topView.backBtn.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
        topView.rightBtn.addTarget(self, action: #selector(searchClick), for: .touchUpInside)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 返回
    func clickBackBtn(){
        _ = navigationController?.popViewController(animated: true)
    }
    /// 搜索
    func searchClick(){
        let searchVC = GYZShopSerchGoodsVC()
        searchVC.shopId = shopId
        searchVC.blockGoodsInfo = { [weak self] (goodsInfo) in
            self?.selectGoodsInfo = goodsInfo
            self?.dealSearchResult()
            
        }
        let navVC = GYZBaseNavigationVC(rootViewController : searchVC)
        self.present(navVC, animated: false, completion: nil)
    }
    
    /// 处理搜索返回的数据
    ///
    /// - Parameter goodsInfo:
    func dealSearchResult(){
        if selectGoodsInfo != nil {
            var selectParentIndex : Int = 0
            var selectChildIndex : Int = 0
            
            for (index,item) in goodsVC.categoryParentData.enumerated() {
                if item == selectGoodsInfo?.class_member_name{
                    goodsVC.topScrollView.zk_itemClick(by: index)
                    selectParentIndex = index
                    break
                }
            }
            
            for (index,item) in goodsVC.categoryData[selectParentIndex].enumerated() {
                if item.class_member_id == selectGoodsInfo?.class_child_member_id{
                    selectChildIndex = index
                    break
                }
            }
            for (index,item) in goodsVC.foodData[selectParentIndex][selectChildIndex].enumerated() {
                if item.id == selectGoodsInfo?.id {
                    goodsVC.selectRightRow(row: index, section: selectChildIndex)
                    goodsVC.selectRow(index: selectChildIndex)
                    break
                }
            }

        }
    }
    
    /// 增加收藏
    func requestAddFavourite(){
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("User/addCollect", parameters: ["type":"1","member_id":shopId,"user_id": userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            //            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                let data = response["result"]
                
                let itemInfo = data["info"]
                if itemInfo["is_collect"].stringValue == "0"{
                    weakSelf?.headerView.favoriteBtn.backgroundColor = UIColor.clear
                }else{
                    weakSelf?.headerView.favoriteBtn.backgroundColor = kYellowFontColor
                }
                
            }
            MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /** 因为频繁用到header和menu的固定,所以声明一个方法用于偷懒 */
    func headerMenuViewShowType(_ showType:headerMenuShowType){
        switch showType {
        case .up:
            menuView.frame.origin.y = kTitleAndStateHeight
            headerView.frame.origin.y = -kHeaderHight+kTitleAndStateHeight
            self.navigationController?.navigationBar.alpha = 1
            
            break
        case .buttom:
            headerView.frame.origin.y = 0
            menuView.frame.origin.y = headerView.frame.maxY
            self.navigationController?.navigationBar.alpha = 0
            break
        }
    }
    
    // MARK:GYZBusinessDetailVCDelegate
    func detailsDidScrollPassY(_ tableviewScrollY: CGFloat) {
        
        scrollPassY(viewScrollY: tableviewScrollY)
    }
    ///MARK: GYZBusinessConmentVCDelegate
    func conmentDidScrollPassY(_ tableviewScrollY: CGFloat) {
        
        scrollPassY(viewScrollY: tableviewScrollY)
    }
    // MARK:GYZGoodsVCDelegate
    func goodsDidScrollPassY(_ tableviewScrollY: CGFloat) {
        
        scrollPassY(viewScrollY: tableviewScrollY)
        
        goodsVC.leftTableView.contentInset = UIEdgeInsetsMake(menuView.frame.maxY, 0, 0, 0 )
        goodsVC.rightTableView.contentInset = UIEdgeInsetsMake(menuView.frame.maxY, 0, 0, 0 )
        goodsVC.topScrollView.frame = CGRect.init(x: 0, y: menuView.frame.maxY, width: kScreenWidth, height: kTitleHeight)
    }
    
    /// 依据代理计算y值
    ///
    /// - Parameter viewScrollY:
    func scrollPassY(viewScrollY: CGFloat){
        // 计算每次改变的值
        let seleoffSetY = viewScrollY - scrollY
        // 将scrollY的值同步
        scrollY = viewScrollY
        // 偏移量超出Navigation之上
        if scrollY >= -kTitleHeight-kTitleAndStateHeight {
            headerMenuViewShowType(.up)
        }else if  scrollY <= -kScrollHorizY {
            // 偏移量超出Navigation之下
            headerMenuViewShowType(.buttom)
        }else{
            // 剩下的只有需要跟随的情况了
            // 将headerView的y值按照偏移量更改
            headerView.frame.origin.y -= seleoffSetY
            menuView.frame.origin.y = headerView.frame.maxY
            // 基准线 用于当做计算0-1的..被除数..分母...
            let datumLine = -kTitleHeight-kTitleAndStateHeight + kScrollHorizY
            // 计算当前的值..除数...分子..
            let nowY = scrollY + kTitleHeight+kTitleAndStateHeight
            // 一个0-1的值
            let nowAlpa = 1+nowY/datumLine
            
            self.navigationController?.navigationBar.alpha = nowAlpa
        }
    }
    // MARK:GYZSegmentViewDelegate
    func segmentViewSelectIndex(_ index: Int) {
        // 0.3秒的动画为了显得不太突兀
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundScrollView?.contentOffset = CGPoint(x: kScreenWidth*CGFloat(index),y: 0)
        })
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 判断是否有X变动,这里只处理横向滑动
        if scrollX == scrollView.contentOffset.x{
            return;
        }
        // 当tableview滑动到很靠上的时候,下一个tableview出现时只用在menuView之下
        if scrollY >= -kTitleHeight-kTitleAndStateHeight {
            scrollY = -kTitleHeight-kTitleAndStateHeight
        }
        
        for (index,scroView) in tableViewArr.enumerated() {
            scroView.contentOffset = CGPoint(x: 0, y: scrollY)
            if index == 0 {
                goodsVC.leftTableView.contentOffset = CGPoint(x: 0, y: scrollY)
            }
        }
        
        // 用于改变menuView的状态
        let rate = (scrollView.contentOffset.x/kScreenWidth)
        self.menuView.scrollToRate(rate)
        let index = Int(rate+0.7)
        // +0.7的意思是 当滑动到30%的时候加载下一个tableView
        backgroundScrollView?.addSubview(tableViewArr[index])
        if index == 0 {
            backgroundScrollView?.addSubview(goodsVC.leftTableView)
            backgroundScrollView?.addSubview(goodsVC.bottomView)
            backgroundScrollView?.addSubview(goodsVC.topScrollView)
            if goodsVC.foodData.count > 0 && goodsVC.categoryData.count > 0{
                goodsVC.leftTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
            }
            
            goodsVC.leftTableView.contentInset = UIEdgeInsetsMake(menuView.frame.maxY, 0, 0, 0 )
            goodsVC.rightTableView.contentInset = UIEdgeInsetsMake(menuView.frame.maxY, 0, 0, 0 )
            goodsVC.topScrollView.frame = CGRect.init(x: 0, y: menuView.frame.maxY, width: kScreenWidth, height: kTitleHeight)
        }
        
        // 记录x
        scrollX = scrollView.contentOffset.x
    }
    /// 获取购物车信息
    func requestCartInfo(){
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("User/myCard", parameters: ["user_id":userDefaults.string(forKey: "userId") ?? "","member_id": shopId],  success: { (response) in
            
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                let data = response["result"]
                weakSelf?.requestShopGoodsInfo()
                
                guard let itemInfo = data["info"].array else { return }
                if itemInfo.count == 0{
                    return
                }
                let memberInfo = itemInfo[0]["member_info"]
                guard let goodList = memberInfo["goods_list"].array else { return }
                
                for cart in goodList{
                    guard let itemInfo = cart.dictionaryObject else { return }
                    let model = CartModel.init(dict: itemInfo)
                    
                    let goodId = model.good_id!
                    weakSelf?.goodsVC.selectGoodsAtts[goodId] = model.attr
                    weakSelf?.goodsVC.selectTotalNum += Int.init(model.num!)!
                    weakSelf?.goodsVC.selectTotalPrice += Float.init((model.attr?.price)!)! * Float.init(model.num!)!
                    
                    let goodsModel = GoodInfoModel()
                    goodsModel.id = model.good_id
                    goodsModel.cn_name = model.cn_name
                    goodsModel.goods_img = model.goods_img
                    goodsModel.goods_thumb_img = model.goods_thumb_img
                    goodsModel.preferential_type = model.preferential_type
                    goodsModel.preferential_price = model.preferential_price
                    goodsModel.buy_num = model.buy_num
                    goodsModel.preferential_buy_num = model.preferential_buy_num
                    goodsModel.class_member_id = model.class_member_id
                    goodsModel.class_member_name = model.class_member_name
                    goodsModel.class_child_member_id = model.class_child_member_id
                    goodsModel.class_child_member_name = model.class_child_member_name
                    
                    weakSelf?.goodsVC.selectGoodsItems[goodId] = goodsModel
                    weakSelf?.goodsVC.selectGoods[goodId] = Int.init(model.num!)!
                    weakSelf?.goodsVC.selectGoodsModels.append(goodsModel)
                }
                if weakSelf?.goodsVC.selectGoodsModels.count > 0{
                    weakSelf?.goodsVC.bottomView.dataSource = (weakSelf?.goodsVC.selectGoodsModels)!
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
//                weakSelf?.hud?.hide(animated: true)
                weakSelf?.requestShopGoodsInfo()
            }
            
        }, failture: { (error) in
//            weakSelf?.hud?.hide(animated: true)
            weakSelf?.requestShopGoodsInfo()
            GYZLog(error)
        })
    }
    /// 获取商家商品及商家信息
    func requestShopGoodsInfo(){
        weak var weakSelf = self
//        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Goods/seachByMember", parameters: ["user_id":userDefaults.string(forKey: "userId") ?? "","member_id": shopId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                let data = response["result"]
                
                guard let itemInfo = data["info"].dictionaryObject else { return }
                
                weakSelf?.shopGoodsModels = GYZShopGoodsModel.init(dict: itemInfo)
                weakSelf?.setGoodsData()
                
                weakSelf?.navigaionTitle = weakSelf?.shopGoodsModels?.member_info?.company_name
                // 给title赋值..我也不知道为什么突然只能用这种方式赋值了,需要研究一下
                weakSelf?.navigationController?.navigationBar.topItem?.title = weakSelf?.navigaionTitle
                // 给假的title赋值
                weakSelf?.topView.titleLab.text = weakSelf?.navigaionTitle
                
                weakSelf?.setDetailsData()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 设置商品数据
    func setGoodsData(){
        
        headerView.dataModel = shopGoodsModels
        
        if shopGoodsModels?.goods?.count > 0 {
            let model: GoodsCategoryModel = (shopGoodsModels?.goods![0].goods_class)!
            var parentId: String = model.parent_class_id!
            goodsVC.categoryParentData.append(model.parent_class_name!)
            
            var childs: [GoodsCategoryModel] = [GoodsCategoryModel]()
            var goods: [[GoodInfoModel]] = [[GoodInfoModel]]()
            
            for (index,item) in (shopGoodsModels?.goods?.enumerated())! {
//                if item.goods_list!.count == 0 {
//                    continue
//                }
                let categoryModel: GoodsCategoryModel = item.goods_class!
                
                if parentId != categoryModel.parent_class_id {
                    
                    parentId = categoryModel.parent_class_id!
                    goodsVC.categoryParentData.append(categoryModel.parent_class_name!)
                    
                    ///增加子类
                    goodsVC.categoryData.append(childs)
                    childs.removeAll()
                    
                    goodsVC.foodData.append(goods)
                    goods.removeAll()
                }
                
                childs.append(categoryModel)
                goods.append(item.goods_list!)
                
                ///最后一项时添加子类
                if index == (shopGoodsModels?.goods?.count)! - 1 {
                    ///增加子类
                    goodsVC.categoryData.append(childs)
                    childs.removeAll()
                    
                    goodsVC.foodData.append(goods)
                    goods.removeAll()
                }
            }
            
            goodsVC.shopInfo = shopGoodsModels?.member_info
            
            goodsVC.changeBottomView()
            goodsVC.topScrollView.zk_setItems(goodsVC.categoryParentData)
            goodsVC.leftTableView.reloadData()
            goodsVC.rightTableView.reloadData()
            if goodsVC.foodData.count > 0 && goodsVC.categoryData.count > 0{
                
                if selectGoodsInfo == nil {
                    goodsVC.leftTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
                }else{
                    dealSearchResult()
                }
                
            }
        }
        
    }
    /// 设置商家详情数据
    func setDetailsData(){
        detailVC.shopInfo = shopGoodsModels?.member_info
        
        detailVC.tableView.reloadData()
    }
    
    ///MARK GYZBusinessHeaderViewDelegate
    func didFavouriteBusiness() {
        requestAddFavourite()
    }
}
