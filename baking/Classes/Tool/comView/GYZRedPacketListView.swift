//
//  GYZRedPacketListView.swift
//  baking
//  领红包列表
//  Created by gouyz on 2017/9/11.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

private let homeRedPacketCell = "homeRedPacketCell"

class GYZRedPacketListView: UIView {

    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(){
        let rect = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        self.init(frame: rect)
        
        self.backgroundColor = UIColor.clear
        
        backgroundView.frame = rect
        backgroundView.alpha = 0
        backgroundView.backgroundColor = kBlackColor
        addSubview(backgroundView)
        backgroundView.addOnClickListener(target: self, action: #selector(onTapCancle(sender:)))
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        addSubview(bgView)
        bgView.addOnClickListener(target: self, action: #selector(onBlankClicked))
        
        bgView.addSubview(topView)
        topView.addSubview(headerImgView)
        topView.addSubview(listTableView)
        
        bgView.addSubview(lineImgView)
        bgView.addSubview(bottomView)
        bottomView.addSubview(myRedPacketBtn)
        addSubview(cancleBtn)
        
        bgView.frame = CGRect.init(x: 0, y: 0, width: 280, height: 380)
        bgView.center = self.center
        
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(bgView)
            make.height.equalTo(280)
        }
        headerImgView.snp.makeConstraints { (make) in
            make.top.equalTo(-40)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(120)
        }
        
        listTableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(headerImgView)
            make.top.equalTo(headerImgView.snp.bottom).offset(-10)
            make.bottom.equalTo(topView).offset(-kMargin)
        }
        lineImgView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.equalTo(topView)
            make.height.equalTo(24)
        }
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(lineImgView.snp.bottom)
            make.left.right.equalTo(topView)
            make.bottom.equalTo(bgView.snp.bottom)
        }
        
        myRedPacketBtn.snp.makeConstraints { (make) in
            make.center.equalTo(bottomView)
            make.size.equalTo(CGSize.init(width: 150, height: 40))
        }
        
        cancleBtn.snp.makeConstraints { (make) in
            make.top.equalTo(bottomView.snp.bottom).offset(kMargin)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        
    }
    
    ///整体背景
    var backgroundView: UIView = UIView()
    /// 透明背景
    var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
//        view.cornerRadius  = kCornerRadius
        
        return view
    }()
    
    var topView: UIView = {
       
        let view = UIView()
        view.backgroundColor = kRedPacketBgColor
        
        return view
    }()
    ///顶部图片
    var headerImgView:  UIImageView = UIImageView.init(image: UIImage.init(named: "icon_header_redpacket"))
    
    /// 红包列表视图
    lazy var listTableView: UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: .plain)
        table.separatorStyle = .none
        table.tableFooterView = UIView()
//        table.estimatedRowHeight = kTitleHeight
        // 设置行高为自动适配
//        table.rowHeight = UITableViewAutomaticDimension
        //        table.bounces = false
        table.showsHorizontalScrollIndicator = false
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = kRedPacketBgColor
        
        table.delegate = self
        table.dataSource = self
        table.register(GYZHomeRedPacketCell.self, forCellReuseIdentifier: homeRedPacketCell)
        
        return table
    }()
    ///分割线
    var lineImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_redpacket_line"))
    
    var bottomView: UIView = {
        
        let view = UIView()
//        view.roundingCorners(byRoundingCorners: [.bottomLeft,.bottomRight], radius: kCornerRadius)
        view.backgroundColor = kRedPacketBgColor
        
        return view
    }()
    
    /// 查看我的红包
    lazy var myRedPacketBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        
        btn.backgroundColor = kNavBarColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("查看我的红包 >>", for: .normal)
        btn.cornerRadius = 8
        
        btn.addTarget(self, action: #selector(clickedMyRedPacketBtn), for: .touchUpInside)
        
        return btn
    }()
    
    //取消
    lazy var cancleBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setBackgroundImage(UIImage.init(named: "icon_redpacket_cancle"), for: .normal)
        
        btn.addTarget(self, action: #selector(clickedCancleBtn), for: .touchUpInside)
        
        return btn
    }()
    
    /// 显示
    func show(){
        let window = UIApplication.shared.keyWindow
        window?.subviews[0].addSubview(self)
        
        addAnimation()
    }
    
    ///添加显示动画
    func addAnimation(){
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            
            weakSelf?.bgView.frame = CGRect.init(x: (weakSelf?.bgView.frame.origin.x)!, y: (weakSelf?.frame.size.height)! - (weakSelf?.bgView.frame.size.height)!, width: (weakSelf?.bgView.frame.size.width)!, height: (weakSelf?.bgView.frame.size.height)!)
            
            weakSelf?.bgView.center = (weakSelf?.center)!
            weakSelf?.backgroundView.alpha = 0.6
            
        }) { (finished) in
            
        }
    }
    
    ///移除动画
    func removeAnimation(){
        weak var weakSelf = self
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            
            weakSelf?.bgView.frame = CGRect.init(x: (weakSelf?.bgView.frame.origin.x)!, y: (weakSelf?.frame.size.height)!, width: (weakSelf?.bgView.frame.size.width)!, height: (weakSelf?.bgView.frame.size.height)!)
            weakSelf?.backgroundView.alpha = 0
            
        }) { (finished) in
            weakSelf?.removeFromSuperview()
        }
    }
    
    /// 隐藏
    func hide(){
        removeAnimation()
    }
    
    /// 点击bgView不消失
    func onBlankClicked(){
        
    }
    
    /// 点击空白取消
    func onTapCancle(sender:UITapGestureRecognizer){
        
        hide()
    }
    
    /// 取消
    func clickedCancleBtn(){
        hide()
    }
    
    /// 查看我的红包
    func clickedMyRedPacketBtn(){
        
    }
}

extension GYZRedPacketListView : UITableViewDelegate,UITableViewDataSource{
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
    
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: homeRedPacketCell) as! GYZHomeRedPacketCell
        return cell
        
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
        
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0.0001
//    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return kMargin
//    }
}
