//
//  GYZBusinessProfileVC.swift
//  baking
//  店铺资料
//  Created by gouyz on 2017/4/2.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD


private let businessProfileCell = "businessProfileCell"
private let businessProfileImagesCell = "businessProfileImagesCell"

class GYZBusinessProfileVC: GYZBaseVC,UITableViewDelegate,UITableViewDataSource {
    
    let titles: [String] = ["店铺名称","店铺地址","签约时间","店铺实景"]
    var signInfoModel: GYZSignInfoModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "店铺资料"

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        requestSignInfoData()
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
        
        table.register(GYZBusinessProfileCell.self, forCellReuseIdentifier: businessProfileCell)
        table.register(GYZBusinessImgCell.self, forCellReuseIdentifier: businessProfileImagesCell)
        
        return table
    }()
    
    ///获取签约用户店铺信息
    func requestSignInfoData(){
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("User/shopInfo",parameters: ["user_id":userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                let data = response["result"]
                guard let info = data["info"].dictionaryObject else { return }
                
                weakSelf?.signInfoModel = GYZSignInfoModel.init(dict: info)
                
                weakSelf?.tableView.reloadData()
                
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
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < titles.count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: businessProfileCell) as! GYZBusinessProfileCell
            cell.nameLab.text = titles[indexPath.row]
            if indexPath.row == 0 {
                cell.desLab.text = signInfoModel?.shop_name
            } else if indexPath.row == 1 {
                cell.desLab.text = signInfoModel?.address
            }else if indexPath.row == 2 {
                cell.desLab.text = signInfoModel?.signing_time?.dateFromTimeInterval()?.dateToStringWithFormat(format: "yyyy/MM/dd")
            }
            
            cell.selectionStyle = .none
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: businessProfileImagesCell) as! GYZBusinessImgCell
            cell.nameLab.text = titles[indexPath.row]
            cell.imgUrls = signInfoModel?.shop_img
            
            cell.backgroundColor = kWhiteColor
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kMargin
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < titles.count - 1 {
            return 40
        }
        return 40 + kBusinessImgHeight + kMargin
    }
}
