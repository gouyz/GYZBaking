//
//  GYZRedPacketListView.swift
//  baking
//  领红包列表
//  Created by gouyz on 2017/9/11.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

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
        
        bgView.backgroundColor = kWhiteColor
        addSubview(bgView)
        bgView.addOnClickListener(target: self, action: #selector(onBlankClicked))
        
        bgView.addSubview(topView)
        topView.addSubview(headerImgView)
        topView.addSubview(listTableView)
        
        bgView.addSubview(lineImgView)
        bgView.addSubview(bottomView)
        bottomView.addSubview(myRedPacketBtn)
        addSubview(cancleBtn)
        
        
        
    }
    
    ///整体背景
    var backgroundView: UIView = UIView()
    /// 透明背景
    var bgView: UIView = UIView()
//    var redBgView: UIView = UIView()
    
    var topView: UIView = {
       
        let view = UIView()
        view.roundingCorners(byRoundingCorners: [.topLeft,.topRight], radius: kCornerRadius)
        view.backgroundColor = kRedPacketBgColor
        
        return view
    }()
    ///顶部图片
    var headerImgView:  UIImageView = UIImageView.init(image: UIImage.init(named: "icon_header_redpacket"))
    
    /// 红包列表视图
    lazy var listTableView: UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: .plain)
        table.estimatedRowHeight = kTitleHeight
        // 设置行高为自动适配
        table.rowHeight = UITableViewAutomaticDimension
        //        table.bounces = false
        table.showsHorizontalScrollIndicator = false
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = UIColor.clear
        
        return table
    }()
    ///分割线
    var lineImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_redpacket_line"))
    
    var bottomView: UIView = {
        
        let view = UIView()
        view.roundingCorners(byRoundingCorners: [.bottomLeft,.bottomRight], radius: kCornerRadius)
        view.backgroundColor = kRedPacketBgColor
        
        return view
    }()
    
    /// 查看我的红包
    lazy var myRedPacketBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        
        btn.backgroundColor = kBtnClickBGColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("查看我的红包 >>", for: .normal)
        btn.cornerRadius = 8
        
        btn.addTarget(self, action: #selector(clickedMyRedPacketBtn), for: .touchUpInside)
        
        return btn
    }()
    
    //取消
    var cancleBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setBackgroundImage(UIImage.init(named: "icon_redpacket_cancle"), for: .normal)
        
        btn.addTarget(self, action: #selector(clickedCancleBtn), for: .touchUpInside)
        
        return btn
    }()
    /// 点击bgView不消失
    func onBlankClicked(){
        
    }
    
    /// 点击空白取消
    func onTapCancle(sender:UITapGestureRecognizer){
        
//        hide()
    }
    
    /// 取消
    func clickedCancleBtn(){
        
    }
    
    /// 查看我的红包
    func clickedMyRedPacketBtn(){
        
    }
}
