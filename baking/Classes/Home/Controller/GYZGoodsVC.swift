//
//  GYZGoodsVC.swift
//  baking
//  商品
//  Created by gouyz on 2017/3/30.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol GYZGoodsVCDelegate{
    func goodsDidScrollPassY(_ tableviewScrollY:CGFloat)
}

private let kLeftTableViewCell = "LeftTableViewCell"
private let kRightTableViewCell = "RightTableViewCell"
private let kRightTableViewHeaderView = "RightTableViewHeaderView"
private let kTopCategoryCell = "topCategoryCell"
private let kCartDetailCell = "cartDetailCell"
private let kCartDetailHeaderView = "cartDetailHeaderView"

class GYZGoodsVC: GYZBaseVC, UITableViewDataSource, UITableViewDelegate {
    
    var delegate:GYZGoodsVCDelegate?
    
    ///子类
    var categoryData = [[GoodsCategoryModel]]()
    ///父类
    var categoryParentData: [String] = [String]()
    var foodData = [[[GoodInfoModel]]]()
    ///店铺信息
    var shopInfo: ShopInfoModel?
    /// 记录选择的goods，key为ID，value为数量
    var selectGoods: [String : Int] = [:]
    /// 记录选择的goods，key为ID，value为商品信息
    var selectGoodsItems: [String : GoodInfoModel] = [:]
    /// 记录选择的goods规格，key为商品ID，value为规格信息
    var selectGoodsAtts: [String : GoodsAttrModel] = [:]
    ///选择的goods总数量
    var selectTotalNum: Int = 0
    ///选择的goods总价格
    var selectTotalPrice: Float = 0.0
    ///选择商品，购物车详情展示
    var selectGoodsModels: [GoodInfoModel] = [GoodInfoModel]()
    
    /// 商家ID
    var shopId: String = ""
    
    
    fileprivate var selectIndex = 0
    fileprivate var isScrollDown = true
    fileprivate var lastOffsetY : CGFloat = 0.0
    
    ///父类索引
    var currParentIndex = 0
    
    var topScrollView: ZKSegment!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftTableView.delegate = self
        leftTableView.dataSource = self
        view.addSubview(leftTableView)
        
        rightTableView.delegate = self
        rightTableView.dataSource = self
        view.addSubview(rightTableView)
        
        topScrollView = ZKSegment.zk_segment(withFrame: CGRect(x: 0, y: kScrollHorizY, width: kScreenWidth, height: kTitleHeight), style: ZKSegmentTextStyle)
        topScrollView.zk_itemSelectedColor = kYellowFontColor
        topScrollView.zk_backgroundColor = kWhiteColor
        view.addSubview(topScrollView)
        topScrollView.zk_itemClickBlock = { [weak self] (itemName,itemIndex) in
            
            self?.currParentIndex = itemIndex
            self?.leftTableView.reloadData()
            self?.rightTableView.reloadData()
            if self?.foodData.count > 0 && self?.categoryData.count > 0{
                self?.leftTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
            }
        }
        
        view.addSubview(bottomView)
//        bottomView.payBtn.addTarget(self, action: #selector(clickedPayBtn), for: .touchUpInside)
//        bottomView.chartBtn.addTarget(self, action: #selector(clickedCartDetails), for: .touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var leftTableView : UITableView = {
        let leftTableView = UITableView()
        leftTableView.frame = CGRect(x: 0, y: kTitleHeight, width: 80, height: kScreenHeight - kTitleHeight*2)
        leftTableView.rowHeight = 55
        leftTableView.showsVerticalScrollIndicator = false
        leftTableView.separatorColor = UIColor.clear
        leftTableView.tableFooterView = UIView()
        leftTableView.register(GYZGoodsCategoryCell.self, forCellReuseIdentifier: kLeftTableViewCell)
        return leftTableView
    }()
    
    var rightTableView : UITableView = {
        let rightTableView = UITableView()
        rightTableView.frame = CGRect(x: 80, y: kTitleHeight, width: kScreenWidth - 80, height: kScreenHeight - kTitleHeight*2)
        rightTableView.rowHeight = 100
        rightTableView.showsVerticalScrollIndicator = false
        rightTableView.tableFooterView = UIView()
        rightTableView.register(GYZGoodsCell.self, forCellReuseIdentifier: kRightTableViewCell)
        rightTableView.register(GYZCategoryHeaderView.self, forHeaderFooterViewReuseIdentifier: kRightTableViewHeaderView)
        
        return rightTableView
    }()
    
    /// 购物车
    lazy var bottomView: GYZCartView = {
        let cartView = GYZCartView.init(frame: CGRect.init(x: 0, y: kScreenHeight - kBottomTabbarHeight, width: kScreenWidth, height: kBottomTabbarHeight))
        cartView.listTableView.dataSource = self
        cartView.listTableView.delegate = self
        cartView.listTableView.register(GYZCartCell.self, forCellReuseIdentifier: kCartDetailCell)
        cartView.listTableView.register(GYZCategoryHeaderView.self, forHeaderFooterViewReuseIdentifier: kCartDetailHeaderView)
        
        cartView.submitBtn.addTarget(self, action: #selector(clickedPayBtn), for: .touchUpInside)
        
        return cartView
        
    }()
    
    /// 支付
    func clickedPayBtn(){
        if bottomView.isOpen {
            bottomView.dismissAnimated()
        }
        
        let submitOrderVC = GYZSubmitOrderVC()
        submitOrderVC.selectGoods = selectGoods
        submitOrderVC.selectGoodsAtts = selectGoodsAtts
        submitOrderVC.selectTotalPrice = selectTotalPrice
        
        for item in selectGoodsItems {
            submitOrderVC.selectGoodsItems.append(item.value)
        }
        submitOrderVC.shopInfo = shopInfo
        navigationController?.pushViewController(submitOrderVC, animated: true)
    }
}

//MARK: - TableView DataSource Delegate
extension GYZGoodsVC {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if leftTableView == tableView {
            return 1
        } else if rightTableView == tableView{
            return categoryData.count > 0 ? categoryData[currParentIndex].count : 0
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if leftTableView == tableView {
            return categoryData.count > 0 ? categoryData[currParentIndex].count : 0
        } else if rightTableView == tableView {
            return foodData.count > 0 ? foodData[currParentIndex][section].count : 0
        }else{
            return selectGoodsModels.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if leftTableView == tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: kLeftTableViewCell, for: indexPath) as! GYZGoodsCategoryCell
            let model = categoryData[currParentIndex][indexPath.row]
            cell.nameLab.text = model.class_member_name
            
            cell.selectionStyle = .none
            return cell
        } else if rightTableView == tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: kRightTableViewCell, for: indexPath) as! GYZGoodsCell
            let model = foodData[currParentIndex][indexPath.section][indexPath.row]
            cell.setDatas(model)
            cell.delegate = self
            
            if selectGoods.keys.contains(model.id!) {
                cell.minusBtn.isHidden = false
                cell.numLab.isHidden = false
                cell.numLab.text = "\(selectGoods[model.id!]!)"
            }else{
                cell.minusBtn.isHidden = true
                cell.numLab.isHidden = true
            }
            
            cell.selectionStyle = .none
            return cell
        }else{//购物车详情
            let cell = tableView.dequeueReusableCell(withIdentifier: kCartDetailCell, for: indexPath) as! GYZCartCell
            
            let model: GoodInfoModel = selectGoodsModels[indexPath.row]
            let goodsId = model.id!
            let attrmodel = selectGoodsAtts[goodsId]
            
            var name: String = model.cn_name!
            if !(attrmodel?.attr_name?.isEmpty)! {
                name += "[\((attrmodel?.attr_name)!)]"
            }
            cell.nameLab.text = name
            cell.numLab.text = "\(selectGoods[goodsId]!)"
            
            var price: Float = Float.init((attrmodel?.price)!)!
            if model.preferential_type == "1" {///0无优惠 1立减 2打折
                price -= Float.init(model.preferential_price!)!
                
                let str = "￥" + (attrmodel?.price)!
                let discountPrice : NSMutableAttributedString = NSMutableAttributedString(string: str)
                discountPrice.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber(value: 1), range: NSMakeRange(0, str.characters.count))
                cell.discountLab.attributedText = discountPrice
                cell.priceLab.text = String.init(format: "￥%0.2f", price)
            }else{
                cell.discountLab.text = ""
                cell.priceLab.text = "￥" + (attrmodel?.price)!
            }
            
            cell.minusBtn.accessibilityIdentifier = goodsId
            cell.plusBtn.accessibilityIdentifier = goodsId
            cell.minusBtn.addTarget(self, action: #selector(clickedCartMinus(sender:)), for: .touchUpInside)
            cell.plusBtn.addTarget(self, action: #selector(clickedCartPlus(sender:)), for: .touchUpInside)
            
            
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if leftTableView == tableView {
            return 0
        }else if rightTableView == tableView {
            return 30
        }
        return kTitleHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if leftTableView == tableView {
            return nil
        }else if rightTableView == tableView{
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: kRightTableViewHeaderView) as! GYZCategoryHeaderView
            let model = categoryData[currParentIndex][section]
            headerView.nameLab.text = model.class_member_name
            
            return headerView
        }else{
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: kCartDetailHeaderView) as! GYZCategoryHeaderView
            headerView.nameLab.text = "已选商品"
            headerView.clearLab.isHidden = false
            headerView.clearLab.addOnClickListener(target: self, action: #selector(onClickedClearCart))
            
            return headerView
        }
        
    }
    
    // TableView 分区标题即将展示
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // 当前的 tableView 是 RightTableView，RightTableView 滚动的方向向上，RightTableView 是用户拖拽而产生滚动的（（主要判断 RightTableView 用户拖拽而滚动的，还是点击 LeftTableView 而滚动的）
        if (rightTableView == tableView) && !isScrollDown && rightTableView.isDragging {
            selectRow(index: section)
        }
    }
    
    // TableView分区标题展示结束
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        // 当前的 tableView 是 RightTableView，RightTableView 滚动的方向向下，RightTableView 是用户拖拽而产生滚动的（（主要判断 RightTableView 用户拖拽而滚动的，还是点击 LeftTableView 而滚动的）
        if (rightTableView == tableView) && isScrollDown && rightTableView.isDragging {
            selectRow(index: section + 1)
        }
    }
    
    // 当拖动右边 TableView 的时候，处理左边 TableView
    func selectRow(index : Int) {
        leftTableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .top)
    }
    
    // 设置右侧cell
    func selectRightRow(row : Int,section : Int) {
        rightTableView.selectRow(at: IndexPath(row: row, section: section), animated: true, scrollPosition: .top)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if leftTableView == tableView {
            selectIndex = indexPath.row
            rightTableView.scrollToRow(at: IndexPath(row: 0, section: selectIndex), at: .top, animated: true)
            leftTableView.scrollToRow(at: IndexPath(row: selectIndex, section: 0), at: .top, animated: true)
        }else if rightTableView == tableView{
            let model = foodData[currParentIndex][indexPath.section][indexPath.row]
            
            let detailVC = GYZGoodsDetailsVC()
            detailVC.goodId = model.id!
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    // 标记一下 RightTableView 的滚动方向，是向上还是向下
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isKind(of: UITableView.self) {
            let tableView = scrollView as! UITableView
            if rightTableView == tableView {
                isScrollDown = lastOffsetY < scrollView.contentOffset.y
                lastOffsetY = scrollView.contentOffset.y
                if rightTableView.isDragging {
                    delegate?.goodsDidScrollPassY(scrollView.contentOffset.y)
                }
            }
        }
        
    }
}

///MARK GYZGoodsCellDelegate
extension GYZGoodsVC : GYZGoodsCellDelegate{
    
    ///购物车详情加号
    func clickedCartPlus(sender: UIButton){
        let goodsId = sender.accessibilityIdentifier
        
        didClickPlusBtn(goodsId: goodsId!)
        bottomView.listTableView.reloadData()
    }
    ///购物车详情减号
    func clickedCartMinus(sender: UIButton){
        let goodsId = sender.accessibilityIdentifier
        
        didClickMinusBtn(goodsId: goodsId!)
        if selectGoodsModels.count == 0 {
            bottomView.dismissAnimated()
        }else{
            bottomView.updateFrame()
            bottomView.listTableView.reloadData()
        }
        
    }
    /// 加号
    ///
    /// - Parameter goodsId:
    func didClickPlusBtn(goodsId: String) {
        var count: Int = 1
        var price: Float = 0
        
        if selectGoods.keys.contains(goodsId){
            count += selectGoods[goodsId]!
            let item = selectGoodsItems[goodsId]
            
            price = Float.init((selectGoodsAtts[goodsId]?.price)!)!
            
            if selectGoodsAtts[goodsId]?.count != nil {
                if Int.init((selectGoodsAtts[goodsId]?.count)!)! < count {//库存不足
                    MBProgressHUD.showAutoDismissHUD(message: "库存不足")
                    return
                }
                ///限制购买数量
                if Int.init((item?.preferential_buy_num)!) != 0 && Int.init((item?.buy_num)!) != 0 {
                    if count > Int.init((item?.preferential_buy_num)!)! + Int.init((item?.buy_num)!)! {
                        MBProgressHUD.showAutoDismissHUD(message: "超出可购买数量")
                        return
                    }
                }
            }
            
            price = Float.init((selectGoodsAtts[goodsId]?.price)!)!
            selectTotalPrice += price
            requestAddCart(goodsId: goodsId, attrId: (selectGoodsAtts[goodsId]?.attr_id)!)
            
        }else{
            var isFind: Bool = false
            
            for item in foodData[currParentIndex] {
                for goods in item {
                    if goods.id == goodsId {
                        if goods.attr != nil {
                            ///当规格大于1时，显示选择规格，只有一个时不用选择
                            if goods.attr?.count > 1 {
                                var names: [String] = [String]()
                                for attr in goods.attr! {
                                    names.append("￥\(attr.price!)(\(attr.attr_name!))")
                                }
                                
                                showSelectAttrs(names: names, goodModel: goods)
                                return
                            }else{
                                selectGoodsAtts[goodsId] = goods.attr?[0]
                                price = Float.init((selectGoodsAtts[goodsId]?.price)!)!
                                selectTotalPrice += price
                                
                                requestAddCart(goodsId: goodsId, attrId: (selectGoodsAtts[goodsId]?.attr_id)!)
                            }
                        }
                        selectGoodsItems[goodsId] = goods
                        selectGoodsModels.append(goods)
                        isFind = true
                        break
                    }
                }
                
                if isFind {
                    break
                }
            }
        }
        
        selectTotalNum += 1
        selectGoods[goodsId] = count
        bottomView.dataSource = selectGoodsModels
        
        rightTableView.reloadData()
        changeBottomView()
    }
    
    /// 显示选择规格
    ///
    /// - Parameters:
    ///   - names: 规格名称
    ///   - goodModel: 商品信息
    func showSelectAttrs(names: [String],goodModel: GoodInfoModel){
        GYZAlertViewTools.alertViewTools.showSheet(title: "请选择规格", message: nil, cancleTitle: "取消", titleArray: names, viewController: self) { [weak self](index) in
            
            if index != cancelIndex{
                self?.selectGoodsAtts[goodModel.id!] = goodModel.attr?[index]
                let price = Float.init((goodModel.attr?[index].price)!)!
                self?.selectTotalPrice += price
                
                self?.requestAddCart(goodsId: goodModel.id!, attrId: (self?.selectGoodsAtts[goodModel.id!]?.attr_id)!)
                
                self?.selectGoodsItems[goodModel.id!] = goodModel
                self?.selectGoodsModels.append(goodModel)
                self?.selectTotalNum += 1
                self?.selectGoods[goodModel.id!] = 1
                self?.bottomView.dataSource = (self?.selectGoodsModels)!
                
                self?.rightTableView.reloadData()
                self?.changeBottomView()
            }
        }
    }
    /// 减号
    ///
    /// - Parameter goodsId: 
    func didClickMinusBtn(goodsId: String) {
        
        requestDeleteAddCart(goodsId: goodsId, attrId: (selectGoodsAtts[goodsId]?.attr_id)!)
        
        var count: Int = selectGoods[goodsId]!
        count -= 1
        
        var price: Float = 0
        price = Float.init((selectGoodsAtts[goodsId]?.price!)!)!
        
        if count == 0 {
            selectGoodsAtts.removeValue(forKey: goodsId)
            selectGoods.removeValue(forKey: goodsId)
            selectGoodsItems.removeValue(forKey: goodsId)
            for (index,model) in selectGoodsModels.enumerated() {
                if goodsId == model.id {
                    selectGoodsModels.remove(at: index)
                    bottomView.dataSource = selectGoodsModels
                    break
                }
            }
        }else{
            selectGoods[goodsId] = count
        }
        
        selectTotalPrice -= price
        selectTotalNum -= 1
        
        rightTableView.reloadData()
        changeBottomView()
    }
    
    /// 改变底部view
    func changeBottomView(){
        
        let sendPrice : Float = Float.init((shopInfo?.send_price)!)!
        
        bottomView.totalLabel.text = "￥\(selectTotalPrice)"
        
        if selectTotalNum == 0 {
            
            bottomView.shopCartBtn.isUserInteractionEnabled = false
            bottomView.shopCartBtn.clearBadge(animated: false)
            
            bottomView.submitBtn.backgroundColor = kGrayLineColor
            bottomView.submitBtn.isEnabled = false
            bottomView.submitBtn.setTitle("￥\(sendPrice)起送", for: .normal)
        }else{
            
            bottomView.shopCartBtn.isUserInteractionEnabled = true
            bottomView.shopCartBtn.badgeView.text = "\(selectTotalNum)"
            bottomView.shopCartBtn.showBadge(animated: false)
            
            if sendPrice - selectTotalPrice > 0{
                bottomView.submitBtn.backgroundColor = kGrayLineColor
                bottomView.submitBtn.isEnabled = false
                bottomView.submitBtn.setTitle("还差￥\(sendPrice - selectTotalPrice)", for: .normal)
            }else{
                bottomView.submitBtn.backgroundColor = kYellowFontColor
                bottomView.submitBtn.isEnabled = true
                bottomView.submitBtn.setTitle("去结算", for: .normal)
            }
            
        }
    }
    /// 添加购物车
    func requestAddCart(goodsId: String, attrId: String){
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("User/addCard", parameters: ["user_id":userDefaults.string(forKey: "userId") ?? "","member_id": shopId,"goods_id": goodsId,"attr_id": attrId,"num":1],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 减少购物车
    func requestDeleteAddCart(goodsId: String, attrId: String){
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("User/delCard", parameters: ["user_id":userDefaults.string(forKey: "userId") ?? "","member_id": shopId,"goods_id": goodsId,"attr_id": attrId,"num":"1"],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 清空购物车
    func onClickedClearCart(){
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("User/delCardByMemberId", parameters: ["user_id":userDefaults.string(forKey: "userId") ?? "","member_id": shopId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.clearData()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    func clearData(){
        selectGoodsModels.removeAll()
        selectGoods.removeAll()
        selectTotalNum = 0
        selectGoodsAtts.removeAll()
        selectGoodsItems.removeAll()
        selectTotalPrice = 0.0
        bottomView.dataSource.removeAll()
        
        bottomView.dismissAnimated()
        rightTableView.reloadData()
        changeBottomView()
        
    }
}
