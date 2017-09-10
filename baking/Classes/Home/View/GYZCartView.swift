//
//  GYZCartView.swift
//  baking
//  购物车详情
//  Created by gouyz on 2017/7/10.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit


class GYZCartView: UIView {
    
    /** 父视图 */
    let parentView: UIView = KeyWindow
    /// 是否打开详情
    var isOpen: Bool = false
    
    /// 购物车数据
    var dataSource: [GoodInfoModel] = [GoodInfoModel]()
    
    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        addSubview(totalLabel)
        addSubview(submitBtn)
        addSubview(shopCartBtn)
        popOutView.addSubview(self)
        parentView.addSubview(popOutView)
        
        popOutView.addOnClickListener(target: self, action: #selector(onTapCancle(sender:)))
    }
    
    /** 弹出列表背景视图 */
    lazy var popOutView: UIView = {
        let popView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kBottomTabbarHeight))
        popView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        popView.alpha = 0.0
        
        
        return popView
    }()
    /// 购物车详情列表视图
    lazy var listTableView: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: self.parentView.bounds.size.height - kBottomTabbarHeight - self.bounds.size.height, width: kScreenWidth, height: kTitleHeight), style: .plain)
        table.rowHeight = kTitleHeight
        table.bounces = false
        table.showsHorizontalScrollIndicator = false
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = UIColor.clear
        
        table.addOnClickListener(target: self, action: #selector(onBlankClicked))
        
        return table
    }()
    /// 总价
    lazy var totalLabel: UILabel = {
        let lab = UILabel.init(frame: CGRect.init(x: 70, y: 0, width: kScreenWidth - 170, height: kBottomTabbarHeight))
        lab.font = k15Font
        lab.textColor = kYellowFontColor
        lab.text = "￥0.0"
        
        return lab
    }()
    /// 支付
    lazy var submitBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: kScreenWidth - 120, y: 0, width: 120, height: kBottomTabbarHeight)
        btn.backgroundColor = kGrayLineColor
        btn.setTitle("￥20起送", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        
        return btn
    }()
    //购物车按钮
    lazy var shopCartBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: kMargin, y: -10, width: kBottomTabbarHeight, height: kBottomTabbarHeight)
        btn.setBackgroundImage(UIImage.init(named: "icon_chart_normal"), for: .normal)
        btn.addTarget(self, action: #selector(clickedShopCartBtn), for: .touchUpInside)
        btn.badgeView.style = .number
        btn.badgeView.offsets = CGPoint.init(x: 40, y: 5)
        btn.isUserInteractionEnabled = false
        
        return btn
    }()
    
    //购物车按钮
    func clickedShopCartBtn(){
        
        updateFrame()
        popOutView.addSubview(listTableView)
        listTableView.reloadData()
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.5, animations: {
            var point = weakSelf?.shopCartBtn.center
            var labelPoint = weakSelf?.totalLabel.center
            
            point?.y -= ((weakSelf?.listTableView.frame.size.height)! + kBottomTabbarHeight)
            labelPoint?.x -= 60
            weakSelf?.popOutView.alpha = 1.0
            
            weakSelf?.shopCartBtn.center = point!
            weakSelf?.totalLabel.center = labelPoint!
            
        }) { (finished) in
            weakSelf?.isOpen = true
        }
        
    }
    
    /// 点击列表不消失
    func onBlankClicked(){
        
    }
    
    /// 点击空白取消
    func onTapCancle(sender:UITapGestureRecognizer){
        
        dismissAnimated()
    }
    
    func updateFrame(){
        
        //        if dataSource.count == 0 {
        //            dismissAnimated()
        //            return
        //        }
        
        var height: CGFloat = CGFloat(dataSource.count) * kTitleHeight + kTitleHeight
        let maxHeight = parentView.bounds.size.height - 260
        if height > maxHeight {
            height = maxHeight
        }
        let orignY = listTableView.frame.origin.y
        
        listTableView.frame = CGRect.init(x: listTableView.frame.origin.x, y: parentView.bounds.size.height - height - kBottomTabbarHeight, width: kScreenWidth, height: height)
        let currentY = listTableView.frame.origin.y
        
        if isOpen {
            weak var weakSelf = self
            UIView.animate(withDuration: 0.5, animations: {
                var point: CGPoint = (weakSelf?.shopCartBtn.center)!
                point.y -= orignY - currentY
                weakSelf?.shopCartBtn.center = point
            })
        }
    }
    
    // dismiss效果
    func dismissAnimated(){
        
        weak var weakSelf = self
        shopCartBtn.bringSubview(toFront: popOutView)
        UIView.animate(withDuration: 0.5, animations: {
            
            weakSelf?.popOutView.alpha = 0.0
            weakSelf?.shopCartBtn.frame = CGRect.init(x: kMargin, y: -10, width: kBottomTabbarHeight, height: kBottomTabbarHeight)
            weakSelf?.totalLabel.frame = CGRect.init(x: 70, y: 0, width: kScreenWidth - 170, height: kBottomTabbarHeight)
            
        }) { (finished) in
            weakSelf?.isOpen = false
            weakSelf?.listTableView.removeFromSuperview()
        }
    }
}
