//
//  GYZHomeMenuCell.swift
//  baking
//  首页menu  cell
//  Created by gouyz on 2017/3/24.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit


protocol HomeMenuCellDelegate : NSObjectProtocol {
    func didSelectMenuIndex(index : Int)
}

class GYZHomeMenuCell: UITableViewCell {
    
    /// 代理变量
    weak var delegate : HomeMenuCellDelegate?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        let plistPath : String = Bundle.main.path(forResource: "menuData", ofType: "plist")!
        let menuArr : [[String:String]] = NSArray(contentsOfFile: plistPath) as! [[String : String]]
        let width : CGFloat = kScreenWidth * 0.25
        
        for index in 0 ..< menuArr.count {
            let dic : [String : String] = menuArr[index]
            
            /// 行数,向下取整
            let rows : Int = Int(floor(Double(index/4)))
            /// 列数
            let colums : Int = index % 4
            
            
            let menuView = GYZHomeMenuView(frame:CGRect(x: CGFloat(colums) * width, y:CGFloat( rows * 80), width: width, height: 80.0), iconName: dic["image"]!, title: dic["title"]!)
            menuView.tag = 100 + index
            contentView.addSubview(menuView)
            menuView.addOnClickListener(target: self, action: #selector(menuViewClick(sender : )))
            
//            if colums < 2 {//加竖线
//                let line : UIView = UIView(frame: CGRect.init(x: CGFloat(colums + 1) * width - klineDoubleWidth, y: menuView.y, width: klineDoubleWidth, height: menuView.height))
//                line.backgroundColor = kGrayLineColor
//                contentView.addSubview(line)
//            }else if colums == 2 {//加底部线
//                let bottomLine : UIView = UIView(frame: CGRect.init(x: 0, y: menuView.bottomY, width: getScreenWidth(), height: klineDoubleWidth))
//                bottomLine.backgroundColor = kGrayLineColor
//                contentView.addSubview(bottomLine)
//            }
            
        }
    }
    ///点击事件
    func menuViewClick(sender : UITapGestureRecognizer){
        let tag = sender.view?.tag
        
        GYZLog(tag)
        delegate?.didSelectMenuIndex(index: tag! - 100)
    }
}
