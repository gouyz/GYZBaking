//
//  GYZHomeVC.swift
//  baking
//  首页
//  Created by gouyz on 2017/3/23.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let homeMenuCell = "homeMenuCell"
private let homeCell = "homeCell"


class GYZHomeVC: GYZBaseVC,UITableViewDelegate,UITableViewDataSource,HomeMenuCellDelegate,HomeCellDelegate,GYZHomeHeaderViewDelegate {
    
    var address: String = ""
    
    var homeModel: GYZHomeModel?
    
    /// 轮播图片URL
    var adsImgArr: [String] = []
    /// 轮播连接
    var adsLinkArr: [String] = []
    ///定位
    var locationManager: AMapLocationManager = AMapLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = locationView
        locationView.addOnClickListener(target: self, action: #selector(changeAddress))
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.tableHeaderView = headerView
        headerView.delegate = self
        
        configLocationManager()
        
        /// 消息推送通知
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView(noti:)), name: NSNotification.Name(rawValue: kMessagePush), object: nil)
        
        requestVersion()
        requestHomeData()
        
        showRedPacketView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 显示红包列表
    func showRedPacketView(){
        let redPacketView = GYZRedPacketListView()
        
        redPacketView.show()
    }
    
    /// 切换地址
    func changeAddress(){
        configLocationManager()
    }
    /// 定位配置
    func configLocationManager(){
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        //   定位超时时间，最低2s，此处设置为10s
        locationManager.locationTimeout = 10
        //   逆地理请求超时时间，最低2s，此处设置为10s
        locationManager.reGeocodeTimeout = 10
        
        locationManager.requestLocation(withReGeocode: true) { [weak self](location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            
            if error == nil{
                if reGeocode != nil{
                    
                    //                    print((regeocode?.aoiName)!)
                    //
                    //                    print((regeocode?.street)! + (regeocode?.number)!)
                    let street: String = reGeocode?.street ?? ""
                    let number: String = reGeocode?.number ?? ""
                    if reGeocode?.aoiName != nil{
                        self?.address = (reGeocode?.aoiName)!
                    }else{
                        self?.address = street + number
                    }
                    
                    if self?.address.characters.count == 0 {//未定位成功
                        self?.address = "南京市"
                        userDefaults.set("", forKey: "currlongitude")//经度
                        userDefaults.set("", forKey: "currlatitude")//纬度
                    }else{
                        userDefaults.set(location?.coordinate.longitude, forKey: "currlongitude")//经度
                        userDefaults.set(location?.coordinate.latitude, forKey: "currlatitude")//纬度
                    }
                    
                    self?.setLocationText()
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: "定位失败，请重新定位")
            }
        }
    }
    
    /// 设置定位信息
    func setLocationText(){
        // 计算文字尺寸
        let size = address.size(attributes: [NSFontAttributeName: locationView.addressLab.font])
        
        var width = kScreenWidth * 0.5
        if width > size.width {
            width = size.width + kMargin
        }
        locationView.addressLab.text = address
        locationView.addressLab.snp.updateConstraints { (make) in
            make.width.equalTo(width)
        }
    }
    /// 自定义头部定位
    fileprivate var locationView: GYZHomeTabbarView = GYZHomeTabbarView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kTitleHeight))
    
    /// tableview 头部
    fileprivate var headerView : GYZHomeHeaderView = GYZHomeHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 210))
    
    /// 懒加载UITableView
    fileprivate lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.tableFooterView = UIView()
        table.separatorStyle = .none
        
        table.register(GYZHomeCell.self, forCellReuseIdentifier: homeCell)
        table.register(GYZHomeMenuCell.self, forCellReuseIdentifier: homeMenuCell)
        return table
    }()
    
    ///获取首页数据
    func requestHomeData(){
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Index/index",  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            //            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                let data = response["result"]
                guard let info = data["info"].dictionaryObject else { return }
                
                weakSelf?.homeModel = GYZHomeModel.init(dict: info)
                weakSelf?.setAdsData()
                weakSelf?.tableView.reloadData()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 设置轮播数据
    func setAdsData(){
        for item in (homeModel?.ad)! {
            adsImgArr.append(item.ad_img!)
            adsLinkArr.append(item.link!)
        }
        
        headerView.bannerView?.imagePaths = adsImgArr
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: homeMenuCell) as! GYZHomeMenuCell
            
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: homeCell) as! GYZHomeCell
            cell.delegate = self
            cell.dataModel = homeModel
            
            cell.selectionStyle = .none
            return cell
        }
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 160
        }
        return 140
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return kMargin
    }
    
    
    ///MARK : HomeMenuCellDelegate
    ///处理点击事件
    func didSelectMenuIndex(index: Int) {
        switch index {
        case 0:// 同城配送
            //如果登录
            if checkIsLogin(){
                goSendVC(type: .send)
            }
            
        case 1://购物商城
            goWait()
        case 2:// 配方教学
            goWait()
        case 3:// 成/半成品
            goWait()
            
        case 4://积分商城
            goWait()
        case 5:// 求职招聘
            goWait()
        case 6:// 烘焙集市
            goWait()
            
        case 7://联系我们
            navigationController?.pushViewController(GYZContractUsVC(), animated: true)
        default:
            return
        }
    }
    
    func goWait(){
        MBProgressHUD.showAutoDismissHUD(message: "敬请期待...")
    }
    
    // 同城配送
    func goSendVC(type: SourceViewType){
        let sendVC = GYZSendVC()
        sendVC.sourceType = type
        navigationController?.pushViewController(sendVC, animated: true)
        
    }
    // 商品列表
    func goGoodsVC(type: String){
        let goodsVC = GYZCategoryDetailsVC()
        goodsVC.type = type
        navigationController?.pushViewController(goodsVC, animated: true)
        
    }
    ///MARK : HomeCellDelegate
    ///处理点击事件
    func didSelectIndex(index: Int) {
        //如果登录
        if checkIsLogin(){
            switch index {
            case 1:// 热门市场 变为通货市场
                //                goSendVC(type: .hot)
                goGoodsVC(type: "1")
            case 2://新店推荐  变为商家立减
                //                goSendVC(type: .recommend)
                goGoodsVC(type: "2")
            case 3:// 今日好店
                goSendVC(type: .good)
            default:
                return
            }
        }
        
    }
    
    ///MARK GYZHomeHeaderViewDelegate
    func didClickedBannerView(index: Int) {
        //let webVC = GYZWebViewVC()
        //webVC.url = adsLinkArr[index]
        //navigationController?.pushViewController(webVC, animated: true)
    }
    /// 搜索商品
    func didSearchView() {
        let searchVC = GYZSearchShopVC()
        
        let navVC = GYZBaseNavigationVC(rootViewController : searchVC)
        self.present(navVC, animated: false, completion: nil)
    }
    ///消息通知跳转消息列表
    func refreshView(noti: NSNotification){
        navigationController?.pushViewController(GYZMineMessageVC(), animated: true)
    }
    
    /// 获取App Store版本信息
    func requestVersion(){
        
        weak var weakSelf = self
        
        GYZNetWork.requestVersionNetwork("http://itunes.apple.com/cn/lookup?id=\(APPID)", success: { (response) in
            
            //            GYZLog(response)
            if response["resultCount"].intValue == 1{//请求成功
                let data = response["results"].arrayValue
                
                var version: String = GYZUpdateVersionTool.getCurrVersion()
                var content: String = ""
                if data.count > 0{
                    version = data[0]["version"].stringValue//版本号
                    content = data[0]["releaseNotes"].stringValue//更新内容
                }
                
                weakSelf?.checkVersion(newVersion: version, content: content)
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            GYZLog(error)
        })
    }
    
    /// 检测APP更新
    func checkVersion(newVersion: String,content: String){
        
        let type: UpdateVersionType = GYZUpdateVersionTool.compareVersion(newVersion: newVersion)
        switch type {
        case .noUpdate:
            break
        default:
            updateVersion(version: newVersion, content: content)
            break
        }
    }
    /**
     * //不强制更新
     * @param version 版本名称
     * @param content 更新内容
     */
    func updateVersion(version: String,content: String){
        
        GYZAlertViewTools.alertViewTools.showAlert(title:"发现新版本\(version)", message: content, cancleTitle: "残忍拒绝", viewController: self, buttonTitles: "立即更新", alertActionBlock: { (index) in
            
            if index == 0{//立即更新
                GYZUpdateVersionTool.goAppStore()
            }
        })
    }
    
}
