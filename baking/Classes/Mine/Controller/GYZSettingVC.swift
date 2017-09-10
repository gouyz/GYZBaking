//
//  GYZSettingVC.swift
//  baking
//  设置
//  Created by gouyz on 2017/3/31.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD


private let settingCell = "settingCell"

class GYZSettingVC: GYZBaseVC,UITableViewDelegate,UITableViewDataSource {
    
    var cellTitles:[String] = ["服务条款","清除缓存"]
    var cellIcons:[String] = ["icon_setting_server","icon_setting_cache"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设置"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
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
        
        table.register(GYZMineCell.self, forCellReuseIdentifier: settingCell)
        
        return table
    }()
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingCell) as! GYZMineCell
        
        cell.logoImgView.image = UIImage.init(named: cellIcons[indexPath.row])
        cell.nameLab.text = cellTitles[indexPath.row]
        
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
        if indexPath.row == 0 {//服务条款
            
        } else if indexPath.row == 1{//清除缓存
            MBProgressHUD.showAutoDismissHUD(message: "清除成功")
        }
    }
}
