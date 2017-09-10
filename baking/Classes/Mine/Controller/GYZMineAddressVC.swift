//
//  GYZMineAddressVC.swift
//  baking
//  我的地址
//  Created by gouyz on 2017/4/2.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD


private let mineAddressCell = "mineAddressCell"

class GYZMineAddressVC: GYZBaseVC,UITableViewDelegate,UITableViewDataSource {
    
    /// 修改/保存按钮
    var rightBtn: UIButton?
    /// 是否编辑状态
    var isEditEnble: Bool = false
    ///是否是选择地址
    var isSelected: Bool = false
    
    var addressModels: [GYZAddressModel] = [GYZAddressModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "收货地址"
        rightBtn = UIButton(type: .custom)
        rightBtn?.setTitle("管理", for: .normal)
        rightBtn?.titleLabel?.font = k14Font
        rightBtn?.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn?.addTarget(self, action: #selector(manageClick), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn!)
        
        view.addSubview(tableView)
        view.addSubview(bottomView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, kTitleAndStateHeight, 0))
        }
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(view)
            make.top.equalTo(tableView.snp.bottom)
            make.left.right.equalTo(view)
        }
        bottomView.addBtn.addTarget(self, action: #selector(clickedAddBtn), for: .touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        addressModels.removeAll()
        requestAddressData()
    }
    
    /// 管理
    func manageClick(){
        isEditEnble = !isEditEnble
        if isEditEnble {
            rightBtn?.setTitle("完成", for: .normal)
        }else{
            rightBtn?.setTitle("管理", for: .normal)
        }
        tableView.reloadData()
    }
    
    ///新增地址
    func clickedAddBtn(){
        goEditVC(isEdit: true)
    }
    
    /// 编辑/新增地址
    ///
    /// - Parameter isEdit: 是增加还是编辑
    func goEditVC(isEdit: Bool,addressInfo : GYZAddressModel? = nil){
        let editVC = GYZEditAddressVC()
        editVC.isAdd = isEdit
        editVC.addressInfo = addressInfo
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    /// 懒加载UITableView
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.tableFooterView = UIView()
        table.separatorColor = kGrayLineColor
        
        table.register(GYZAddressCell.self, forCellReuseIdentifier: mineAddressCell)
        
        return table
    }()
    
    /// 增加地址
    lazy var bottomView: GYZAddAddressView = GYZAddAddressView()
    
    ///获取地址数据
    func requestAddressData(){
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("Address/addressList",parameters: ["user_id":userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                let data = response["result"]
                guard let info = data["info"].array else { return }
                
                for item in info{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = GYZAddressModel.init(dict: itemInfo)
                    
                    weakSelf?.addressModels.append(model)
                }
                
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
        return addressModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: mineAddressCell) as! GYZAddressCell
        
        let item = addressModels[indexPath.row]
        cell.dataModel = item
        
        if isEditEnble {
            cell.deleteIconView.isHidden = false
            cell.editIconView.isHidden = false
            cell.contractLab.snp.updateConstraints({ (make) in
                make.left.equalTo(cell.deleteIconView.snp.right).offset(5)
            })
            
            cell.editIconView.addOnClickListener(target: self, action: #selector(editAddressClick(sender:)))
            cell.editIconView.tag = 100 + indexPath.row
            
            cell.deleteIconView.addOnClickListener(target: self, action: #selector(deleteAddressClick(sender:)))
            cell.deleteIconView.tag = 100 + indexPath.row
            
        } else {
            cell.deleteIconView.isHidden = true
            cell.editIconView.isHidden = true
            cell.contractLab.snp.updateConstraints({ (make) in
                make.left.equalTo(cell.deleteIconView.snp.right).offset(-25)
            })
        }
        
        cell.selectionStyle = .none
        return cell
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kTitleAndStateHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kMargin
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSelected {
            backOrderVC(index: indexPath.row)
        }
    }
    
    
    /// 提交订单选择地址
    ///
    /// - Parameter index: 
    func backOrderVC(index: Int){
        for i in 0..<(navigationController?.viewControllers.count)!{
            
            if navigationController?.viewControllers[i].isKind(of: GYZSubmitOrderVC.self) == true {
                
                let vc = navigationController?.viewControllers[i] as! GYZSubmitOrderVC
                vc.addressModel = addressModels[index]
                _ = navigationController?.popToViewController(vc, animated: true)
                
                break
            }
        }
    }
    
    /// 编辑地址
    ///
    /// - Parameter sender:
    func editAddressClick(sender: UITapGestureRecognizer){
        
        let tag = sender.view?.tag
        goEditVC(isEdit: false, addressInfo: addressModels[tag! - 100])
    }
    ///删除地址
    func deleteAddressClick(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "提示", message: "确定要删除该地址？", cancleTitle: "取消", viewController: self, buttonTitles: "删除") { (index) in
            
            if index != -1{
                weakSelf?.requestDeleteAddress(index: tag!)
            }
        }
        
    }
    
    func requestDeleteAddress(index: Int){
        
        let addId: String = addressModels[index - 100].add_id!
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Address/del", parameters: ["add_id":addId], success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.addressModels.remove(at: index - 100)
                
                weakSelf?.tableView.reloadData()
            }
            MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
