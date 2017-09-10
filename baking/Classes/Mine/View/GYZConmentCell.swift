//
//  GYZConmentCell.swift
//  baking
//  评价cell
//  Created by gouyz on 2017/4/2.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import Cosmos

class GYZConmentCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(conmentView)
        
        conmentView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }

    lazy var conmentView: GYZConmentView = GYZConmentView()
    /// 填充数据
    var dataModel : GYZMineConmentModel?{
        didSet{
            if let model = dataModel {
                
                if let urlArr = GYZTool.getImgUrls(url: model.img){
                    
                    conmentView.imageViews.isHidden = false
                    conmentView.imageViews.snp.updateConstraints({ (make) in
                        make.height.equalTo(kBusinessImgHeight)
                    })
                    
                    for (index,item) in urlArr.enumerated() {
                        switch index {
                        case 1:
                            conmentView.imageViews.imgViewTwo.kf.setImage(with: URL.init(string: item), placeholder: UIImage.init(named: "icon_logo_default"), options: nil, progressBlock: nil, completionHandler: nil)
                        case 2:
                            conmentView.imageViews.imgViewThree.kf.setImage(with: URL.init(string: item), placeholder: UIImage.init(named: "icon_logo_default"), options: nil, progressBlock: nil, completionHandler: nil)
                        case 3:
                            conmentView.imageViews.imgViewFour.kf.setImage(with: URL.init(string: item), placeholder: UIImage.init(named: "icon_logo_default"), options: nil, progressBlock: nil, completionHandler: nil)
                        default:
                            conmentView.imageViews.imgViewOne.kf.setImage(with: URL.init(string: item), placeholder: UIImage.init(named: "icon_logo_default"), options: nil, progressBlock: nil, completionHandler: nil)
                        }
                    }
                }else{
                    conmentView.imageViews.isHidden = true
                    conmentView.imageViews.snp.updateConstraints({ (make) in
                        make.height.equalTo(0)
                    })
                }
                //设置数据
                
                conmentView.contentLab.text = model.content
                conmentView.ratingView.rating = Double.init(model.star_num!)!
            }
        }
    }
}
