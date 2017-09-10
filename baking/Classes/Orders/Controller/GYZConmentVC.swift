//
//  GYZConmentVC.swift
//  baking
//  评价
//  Created by gouyz on 2017/4/3.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import Cosmos
import MBProgressHUD
import DKImagePickerController

class GYZConmentVC: GYZBaseVC,GYZConmentPhotosViewDelegate,UITextViewDelegate {
    
    var conmentPlaceHolder = "请写下您的评价..."
    
    var maxImgCount: Int = 4
    var selectImgs: [UIImage] = []
    
    var orderId: String = ""
    var shopId: String = ""
    var conment:String = ""
    
    var shopName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "评价"
        view.backgroundColor = kWhiteColor
        
        setupUI()
        txtView.text = conmentPlaceHolder
        selectView.delegate = self
        nameLab.text = shopName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI(){
        view.addSubview(logoIconView)
        view.addSubview(nameLab)
        view.addSubview(line1)
        
        view.addSubview(desLab)
        view.addSubview(ratingView)
        view.addSubview(line2)
        
        view.addSubview(txtView)
        view.addSubview(selectView)
        view.addSubview(line3)
        
        view.addSubview(submitBtn)
        
        logoIconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(5)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(logoIconView.snp.right).offset(5)
            make.top.equalTo(view)
            make.right.equalTo(-kMargin)
            make.height.equalTo(40)
        }
        line1.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(nameLab.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(logoIconView)
            make.top.equalTo(line1.snp.bottom)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        ratingView.snp.makeConstraints { (make) in
            make.left.equalTo(desLab.snp.right)
            make.centerY.equalTo(desLab)
            make.width.equalTo(100)
        }
        line2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(line1)
            make.top.equalTo(desLab.snp.bottom)
        }
        
        txtView.snp.makeConstraints { (make) in
            make.left.equalTo(desLab)
            make.top.equalTo(line2.snp.bottom).offset(5)
            make.right.equalTo(view).offset(-kMargin)
            make.height.equalTo(100)
        }
        
        selectView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(txtView.snp.bottom).offset(kMargin)
            make.height.equalTo((kScreenWidth - 40)*0.2)
        }
        line3.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(line1)
            make.top.equalTo(selectView.snp.bottom).offset(5)
        }
        
        submitBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(kTitleHeight)
        }
    }
    
    /// 默认商家图标
    fileprivate lazy var logoIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_conment_tag"))
    /// cell title
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        
        return lab
    }()
    fileprivate lazy var line1: UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    
    fileprivate lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "评分"
        
        return lab
    }()
    ///星星评分
    lazy var ratingView: CosmosView = {
        
        let ratingStart = CosmosView()
        ratingStart.settings.updateOnTouch = true
        ratingStart.settings.fillMode = .precise
        ratingStart.settings.filledColor = kYellowFontColor
        ratingStart.settings.emptyBorderColor = kYellowFontColor
        ratingStart.settings.filledBorderColor = kYellowFontColor
        ratingStart.settings.starMargin = 3
        ratingStart.rating = 5
        
        return ratingStart
        
    }()
    fileprivate lazy var line2: UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    
    /// 评价内容
    lazy var txtView : UITextView = {
        let txtView = UITextView()
        txtView.textColor = kGaryFontColor
        txtView.font = k14Font
        txtView.delegate = self
        
        return txtView
    }()
    
    /// 选择图片view
    lazy var selectView: GYZConmentPhotosView = GYZConmentPhotosView()

    
    fileprivate lazy var line3: UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    /// 提交
    lazy var submitBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kYellowFontColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("提交", for: .normal)
        btn.addTarget(self, action: #selector(clickedSubmitBtn), for: .touchUpInside)
        return btn
    }()
    /// 提交
    func clickedSubmitBtn(){
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        var imgsParam: [ImageFileUploadParam] = [ImageFileUploadParam]()
        for (index,imgItem) in selectImgs.enumerated() {
            let imgParam: ImageFileUploadParam = ImageFileUploadParam()
            imgParam.name = "file[]"
            imgParam.fileName = "header\(index).png"
            imgParam.mimeType = "image/png"
            imgParam.data = UIImageJPEGRepresentation(imgItem, 0.5)
            
            imgsParam.append(imgParam)
        }
        
        let params: [String : String] = ["user_id": userDefaults.string(forKey: "userId") ?? "","member_id": shopId,"content": conment ,"star_num": "\(ratingView.rating)","order_id": orderId]
        
        GYZNetWork.uploadImageRequest("Order/comments", parameters: params, uploadParam: imgsParam, success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
            }
            MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    ///打开相机
    func openCamera(){
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            MBProgressHUD.showAutoDismissHUD(message: "该设备无摄像头")
            return
        }
        
        let photo = UIImagePickerController()
        photo.delegate = self
        photo.sourceType = .camera
        photo.allowsEditing = true
        self.present(photo, animated: true, completion: nil)
    }
    
    ///打开相册
    func openPhotos(){
        
        let pickerController = DKImagePickerController()
        pickerController.maxSelectableCount = maxImgCount
        
        weak var weakSelf = self
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            
            for item in assets {
                item.fetchFullScreenImageWithCompleteBlock({ (image, info) in
                    
                    weakSelf?.selectImgs.append(image!)
                    weakSelf?.maxImgCount = kMaxSelectCount - (weakSelf?.selectImgs.count)!
                    let rowIndex = ((weakSelf?.selectImgs.count)! + 1)/5 + 1
                    weakSelf?.selectView.snp.updateConstraints({ (make) in
                        make.height.equalTo((kScreenWidth - 40)*0.2 * CGFloat.init(rowIndex))
                    })
                    weakSelf?.selectView.selectImgs = weakSelf?.selectImgs
                })
            }
        }
        
        self.present(pickerController, animated: true) {}
    }
    
    ///MARK: GYZConmentPhotosViewDelegate
    func didClickAddImage() {
        GYZAlertViewTools.alertViewTools.showSheet(title: "选择照片", message: nil, cancleTitle: "取消", titleArray: ["拍照","从相册选取"], viewController: self) { [weak self](index) in
            
            if index == 0{//拍照
                self?.openCamera()
            }else if index == 1 {//从相册选取
                self?.openPhotos()
            }
        }
    }
    
    ///MARK UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let text = textView.text
        if text == conmentPlaceHolder {
            textView.text = ""
        }
        
    }
    func textViewDidChange(_ textView: UITextView) {
        
        let text : String = textView.text
        
        if text.isEmpty {
            textView.text = conmentPlaceHolder
        }else{
            conment = text
        }
    }
}


extension GYZConmentVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        guard let image = info[picker.allowsEditing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage] as? UIImage else { return }
        picker.dismiss(animated: true) { [weak self] in

            if self?.selectImgs.count == kMaxSelectCount{
                MBProgressHUD.showAutoDismissHUD(message: "最多只能上传\(kMaxSelectCount)张图片")
                return
            }
            self?.selectImgs.append(image)
            self?.maxImgCount = kMaxSelectCount - (self?.selectImgs.count)!
            let rowIndex = (self?.selectImgs.count)!/5 + 1
            self?.selectView.snp.updateConstraints({ (make) in
                make.height.equalTo((kScreenWidth - 40)*0.2 * CGFloat.init(rowIndex))
            })
            self?.selectView.selectImgs = self?.selectImgs
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        picker.dismiss(animated: true, completion: nil)
        
    }
}
