//
//  GYZMineVC.swift
//  baking
//  我的
//  Created by gouyz on 2017/3/23.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import Kingfisher
import MBProgressHUD

private let mineCell = "mineCell"

class GYZMineVC: GYZBaseVC,UITableViewDelegate,UITableViewDataSource {
    
    var cellTitles:[[String]] = [[String]]()
    var cellIcons:[[String]] = [[String]]()
    
    var userInfoModel: GYZUserInfoModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        navBarBgAlpha = 0
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named:"icon_mine_msg"), style: .done, target: self, action: #selector(clickedMessageBtn))
//        let rightBtn = UIButton(type: .custom)
//        rightBtn.setTitle("提现记录", for: .normal)
//        rightBtn.titleLabel?.font = k14Font
//        rightBtn.frame = CGRect.init(x: 0, y: 0, width: 60, height: kTitleHeight)
//        rightBtn.addTarget(self, action: #selector(clickedMessageBtn), for: .touchUpInside)
//        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(-kTitleAndStateHeight, 0, 0, 0))
        }
        tableView.tableHeaderView = headerView
        headerView.loginBtn.addTarget(self, action: #selector(clickedLoginBtn), for: .touchUpInside)
    }
    
    ///消息
    func clickedMessageBtn(){
        let msgVC = GYZMineMessageVC()
        navigationController?.pushViewController(msgVC, animated: true)
    }
    ///登录/注册
    func clickedLoginBtn(){
//        KeyWindow.rootViewController = GYZBaseNavigationVC(rootViewController: GYZLoginVC())
        navigationController?.pushViewController(GYZLoginVC(), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if userDefaults.bool(forKey: kIsLoginTagKey) {
            requestUserInfo()
        }else{//未登录
            headerView.signedLab.isHidden = true
            headerView.loginBtn.isHidden = false
            headerView.userNameLab.isHidden = true
            cellTitles = [["个人资料","我的地址"],["我的评价","我的收藏"],["关于我们","设置"]]
            cellIcons = [["icon_mine_profile","icon_mine_address"],["icon_mine_conment","icon_mine_favourite"],["icon_mine_about","icon_mine_setting"]]
        }
    }
    
    /// 设置签约用户信息
    func setSignInfo(){
        headerView.headerImg.kf.setImage(with: URL.init(string: (userInfoModel?.head_img)!), placeholder: UIImage.init(named: "icon_headimg_default"), options: nil, progressBlock: nil, completionHandler: nil)
        
        ///签约
        if userDefaults.string(forKey: "signing") == "1" {
            headerView.signedLab.isHidden = false
            cellTitles = [["个人资料","我的地址","店铺资料"],["我的评价","我的收藏"],["关于我们","设置"]]
            cellIcons = [["icon_mine_profile","icon_mine_address","icon_mine_business"],["icon_mine_conment","icon_mine_favourite"],["icon_mine_about","icon_mine_setting"]]
        }else{
            headerView.signedLab.isHidden = true
            
            cellTitles = [["个人资料","我的地址"],["我的评价","我的收藏"],["关于我们","设置"]]
            cellIcons = [["icon_mine_profile","icon_mine_address"],["icon_mine_conment","icon_mine_favourite"],["icon_mine_about","icon_mine_setting"]]
        }
        headerView.loginBtn.isHidden = true
        headerView.userNameLab.isHidden = false
        headerView.userNameLab.text = userDefaults.string(forKey: "username")
    }
    /// 懒加载UITableView
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.tableFooterView = UIView()
        table.separatorColor = kGrayLineColor
//        table.bounces = false
        
        table.register(GYZMineCell.self, forCellReuseIdentifier: mineCell)
        
        return table
    }()
    
    lazy var headerView: GYZMineHeaderView = GYZMineHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 200))
    
    /// 获取用户信息
    func requestUserInfo(){
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("User/userInfo",parameters: ["user_id":userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                let data = response["result"]
                let info = data["info"]
                guard let infoItem = info.dictionaryObject else { return }
                
                weakSelf?.userInfoModel = GYZUserInfoModel.init(dict: infoItem)
                
                userDefaults.set(info["username"].stringValue, forKey: "username")//用户名称
                userDefaults.set(info["is_signing"].stringValue, forKey: "signing")//0没有签约 1签约
                userDefaults.set(info["shop_longitude"].stringValue, forKey: "longitude")//经度
                userDefaults.set(info["shop_latitude"].stringValue, forKey: "latitude")//纬度
                userDefaults.set(info["province"].stringValue, forKey: "province")//省
                userDefaults.set(info["city"].stringValue, forKey: "city")//市
                userDefaults.set(info["area"].stringValue, forKey: "area")//区
                userDefaults.set(info["address"].stringValue, forKey: "address")//店铺地址
                userDefaults.set(info["balance"].stringValue, forKey: "balance")//余额
                
                weakSelf?.setSignInfo()
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
        return cellTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: mineCell) as! GYZMineCell
        
        cell.logoImgView.image = UIImage.init(named: cellIcons[indexPath.section][indexPath.row])
        cell.nameLab.text = cellTitles[indexPath.section][indexPath.row]
        
        cell.selectionStyle = .none
        return cell
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kTitleHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kMargin
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if checkIsLogin() {
                if indexPath.row == 0 {//个人资料
                    navigationController?.pushViewController(GYZProfileVC(), animated: true)
                } else if indexPath.row == 1{//我的地址
                    navigationController?.pushViewController(GYZMineAddressVC(), animated: true)
                }else if indexPath.row == 2{//店铺资料
                    navigationController?.pushViewController(GYZBusinessProfileVC(), animated: true)
                }
            }
        } else if indexPath.section == 1{
            if checkIsLogin() {
                if indexPath.row == 0 {//我的评价
                    navigationController?.pushViewController(GYZMineConmentVC(), animated: true)
                } else if indexPath.row == 1{//我的收藏
                    let sendVC = GYZSendVC()
                    sendVC.sourceType = .favourite
                    navigationController?.pushViewController(sendVC, animated: true)
                }
            }
            
        }else{
            if indexPath.row == 0 {//关于我们
                let aboutVC = GYZMineAboutVC()
                navigationController?.pushViewController(aboutVC, animated: true)
            } else if indexPath.row == 1{//设置
                navigationController?.pushViewController(GYZSettingVC(), animated: true)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 禁止下拉
        if scrollView.contentOffset.y <= 0 {
            scrollView.contentOffset.y = 0
            return
        }
    }
}
