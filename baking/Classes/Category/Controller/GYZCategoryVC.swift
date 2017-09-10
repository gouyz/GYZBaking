//
//  GYZCategoryVC.swift
//  baking
//  分类 
//  Created by gouyz on 2017/3/23.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let categoryCell = "categoryCell"

class GYZCategoryVC: GYZBaseVC,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    var categoryModels: [GYZCategoryModel] = [GYZCategoryModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "分类"
//        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named:"icon_search_white"), style: .done, target: self, action: #selector(searchClick))
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        requestCategoryData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collView.dataSource = self
        collView.delegate = self
        collView.backgroundColor = kWhiteColor
        
        collView.register(GYZCategoryCell.self, forCellWithReuseIdentifier: categoryCell)
        
        return collView
    }()
    /// 搜索
//    func searchClick(){
//        
//    }
    
    ///获取分类数据
    func requestCategoryData(){
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Goods/classList",  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                let data = response["result"]
                guard let info = data["info"].array else { return }
                
                for item in info{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = GYZCategoryModel.init(dict: itemInfo)
                    
                    weakSelf?.categoryModels.append(model)
                }
                
                weakSelf?.collectionView.reloadData()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    
    // MARK: UICollectionViewDataSource 代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCell, for: indexPath) as! GYZCategoryCell
        
        cell.dataModel = categoryModels[indexPath.row]
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if checkIsLogin() {
//            let detailsVC = GYZCategoryDetailsVC()
//            detailsVC.mCurrCategoryId = categoryModels[indexPath.row].class_id!
//            navigationController?.pushViewController(detailsVC, animated: true)
            
            let shopVC = GYZSendVC()
            shopVC.categoryName = categoryModels[indexPath.row].class_cn_name!
            shopVC.mCurrCategoryId = categoryModels[indexPath.row].class_id!
            shopVC.sourceType = .category
            navigationController?.pushViewController(shopVC, animated: true)
        }
    }
    //MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (kScreenWidth-kMargin*2)*0.5, height: 120)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: kMargin, left: 5, bottom: 0, right: 5)
    }

}
