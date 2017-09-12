//
//  GYZProfileVC.swift
//  baking
//  个人资料
//  Created by gouyz on 2017/3/31.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let profileCell = "profileCell"
private let profileFooter = "profileFooter"

class GYZProfileVC: GYZBaseVC,UITableViewDelegate,UITableViewDataSource {
    
    
    /// 选择用户头像
    var selectUserImg: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "个人资料"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
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
        table.bounces = false
        
        table.register(GYZProfileCell.self, forCellReuseIdentifier: profileCell)
        table.register(GYZProfileFooterView.self, forHeaderFooterViewReuseIdentifier: profileFooter)
        
        return table
    }()
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: profileCell) as! GYZProfileCell
        cell.userImgView.isHidden = true
        cell.desLab.isHidden = true
        cell.rightIconView.isHidden = false
        
        if indexPath.row == 0 {
            cell.nameLab.text = "头像"
            cell.userImgView.isHidden = false
            if selectUserImg != nil {
                cell.userImgView.image = selectUserImg
            }
        } else if indexPath.row == 1{
            cell.nameLab.text = "账户余额"
            cell.desLab.isHidden = false
            cell.desLab.text = "￥" + userDefaults.string(forKey: "balance")!
            cell.rightIconView.isHidden = true
        }else if indexPath.row == 2{
            cell.nameLab.text = userDefaults.string(forKey: "phone")
            cell.desLab.isHidden = false
            cell.desLab.text = "修改"
        }else if indexPath.row == 3{
            cell.nameLab.text = "修改账户密码"
        }else if indexPath.row == 4{
            cell.nameLab.text = "红包"
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: profileFooter) as! GYZProfileFooterView
        footerView.contentView.backgroundColor = kWhiteColor
        
        footerView.loginOutBtn.addTarget(self, action: #selector(clickedLoginOutBtn(btn:)), for: .touchUpInside)
        
        return footerView
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return kTitleAndStateHeight
        }
        return kTitleHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kMargin
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {//选择头像
            selectHeaderImg()
        } else if indexPath.row == 2{//修改账号
            modifyAccount(type: true)
        }else if indexPath.row == 3{//修改账号密码
            modifyAccount(type: false)
        }else if indexPath.row == 4{//红包
            goRedPacket()
        }
    }

    ///退出当前账号
    func clickedLoginOutBtn(btn : UIButton){
        GYZTool.removeUserInfo()
        navigationController?.pushViewController(GYZLoginVC(), animated: true)
    }
    /// 修改账号
    func modifyAccount(type: Bool){
        let modifyVC = GYZModifyAccountVC()
        modifyVC.isModifyAccount = type
        navigationController?.pushViewController(modifyVC, animated: true)
    }
    
    /// 红包
    func goRedPacket(){
        let packetVC = GYZMyRedPacketVC()
        navigationController?.pushViewController(packetVC, animated: true)
    }
    /// 选择头像
    func selectHeaderImg(){
        
        GYZOpenCameraPhotosTool.shareTool.choosePicture(self, editor: true, finished: { [weak self] (image) in
            
            self?.selectUserImg = image
            self?.requestUpdateHeaderImg()
        })
    }
    
    /// 上传头像
    func requestUpdateHeaderImg(){
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        let imgParam: ImageFileUploadParam = ImageFileUploadParam()
        imgParam.name = "file"
        imgParam.fileName = "header.png"
        imgParam.mimeType = "image/png"
        imgParam.data = UIImageJPEGRepresentation(selectUserImg, 0.5)
        
        GYZNetWork.uploadImageRequest("User/updateHeaderImg", parameters: ["user_id":userDefaults.string(forKey: "userId") ?? ""], uploadParam: [imgParam], success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.tableView.reloadData()
                
                let data = response["result"]
                let info = data["info"]
                userDefaults.set(info["url"].url, forKey: "headImg")//用户logo
                
            }
            MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
