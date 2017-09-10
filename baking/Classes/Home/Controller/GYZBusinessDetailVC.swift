//
//  GYZBusinessDetailVC.swift
//  baking
//  商家
//  Created by gouyz on 2017/4/4.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

protocol GYZBusinessDetailVCDelegate{
    func detailsDidScrollPassY(_ tableviewScrollY:CGFloat)
}

private let businessDetailsCell = "businessDetailsCell"
private let businessDetailsPhotosCell = "businessDetailsPhotosCell"
private let businessDetailsDynamicCell = "businessDetailsDynamicCell"
private let businessDetailsOperateCell = "businessDetailsOperateCell"

class GYZBusinessDetailVC: UITableViewController {
    
    var delegate: GYZBusinessDetailVCDelegate?
    
    var shopInfo: ShopInfoModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = kBackgroundColor
        
        self.tableView.separatorColor = kGrayLineColor
        self.tableView.register(GYZMineCell.self, forCellReuseIdentifier: businessDetailsCell)
        self.tableView.register(GYZBusinessDetailPhotosCell.self, forCellReuseIdentifier: businessDetailsPhotosCell)
        self.tableView.register(GYZBusinessDynamicCell.self, forCellReuseIdentifier: businessDetailsDynamicCell)
        self.tableView.register(GYZProfileCell.self, forCellReuseIdentifier: businessDetailsOperateCell)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row < 2 {//电话、地址
                let cell = tableView.dequeueReusableCell(withIdentifier: businessDetailsCell) as! GYZMineCell
                
                if indexPath.row == 0 {
                    cell.logoImgView.image = UIImage.init(named: "icon_business_phone")
                    cell.nameLab.text = shopInfo?.tel
                } else {
                    cell.logoImgView.image = UIImage.init(named: "icon_business_address")
                    cell.nameLab.text = shopInfo?.address
                }
                
                cell.selectionStyle = .none
                return cell
            }else if indexPath.row == 4{//说说
                let cell = tableView.dequeueReusableCell(withIdentifier: businessDetailsDynamicCell) as! GYZBusinessDynamicCell
                
                cell.contentLab.text = shopInfo?.features
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: businessDetailsPhotosCell) as! GYZBusinessDetailPhotosCell
                
                if indexPath.row == 2 {
                    cell.logoImgView.image = UIImage.init(named: "icon_business_photo")
                    cell.nameLab.text = "商铺实景图"
                    cell.imgUrls = shopInfo?.shop_img
                } else {
                    cell.logoImgView.image = UIImage.init(named: "icon_business_photo")
                    cell.nameLab.text = "营业资质"
                    cell.imgUrls = shopInfo?.cert_img
                }
                
                cell.selectionStyle = .none
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: businessDetailsOperateCell) as! GYZProfileCell
            
            cell.userImgView.isHidden = true
            cell.desLab.isHidden = true
            
            cell.nameLab.textColor = kRedFontColor
            cell.nameLab.text = "举报商家"
            cell.selectionStyle = .none
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 2 || indexPath.row == 3 {
                if shopInfo?.shop_img == "" && indexPath.row == 2 {
                    return kTitleHeight
                }
                if shopInfo?.cert_img == "" && indexPath.row == 3 {
                    return kTitleHeight
                }
                return kTitleHeight + kBusinessImgHeight + kMargin
            }else if indexPath.row == 4{
                return 100
            }
        }
        
        return kTitleHeight
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kMargin
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            let reportVC = GYZReportVC()
            reportVC.shopId = (shopInfo?.member_id)!
            navigationController?.pushViewController(reportVC, animated: true)
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.detailsDidScrollPassY(scrollView.contentOffset.y)
        
    }
}
