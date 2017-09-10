//
//  GYZEditAddressVC.swift
//  baking
//  编辑/新增地址
//  Created by gouyz on 2017/4/2.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class GYZEditAddressVC: GYZBaseVC {
    
    /// 是否新增地址
    var isAdd: Bool = false
    /// 性别 0男 1女
    var sex: String = "0"
    /// 0不是默认 1默认
    var isDefault: String = "1"
    ///经度
    var longitude: Double = 0
    ///纬度
    var latitude: Double = 0
    ///省份
    var province: String = ""
    ///城市
    var city: String = ""
    ///区
    var area: String = ""
    ///定位地址街道
    var district: String = ""
    ///地址
    var address: String = ""
    
    /// 编辑时传入地址信息，新增时为nil
    var addressInfo: GYZAddressModel?
    
    ///定位
    var locationManager: AMapLocationManager = AMapLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .done, target: self, action: #selector(saveClick))
        
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        if !area.isEmpty{ //选择地址返回值
            addressFiled.text = area
            roomFiled.text = address
        }
    }
    
    /// 保存
    func saveClick(){
        requestUpdateAddress()
    }
    
    /// 定位配置
    func configLocationManager(){
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        //   定位超时时间，最低2s，此处设置为2s
        locationManager.locationTimeout = 2
        //   逆地理请求超时时间，最低2s，此处设置为2s
        locationManager.reGeocodeTimeout = 2
        
        locationManager.requestLocation(withReGeocode: true) { [weak self](location, regeocode, error) in
            
            if error == nil{
                if regeocode != nil{
                    
                    self?.province = regeocode?.province ?? ""
                    self?.city = regeocode?.city ?? ""
                    self?.area = regeocode?.district  ?? ""
                    
                    let street: String = regeocode?.street ?? ""
                    let number: String = regeocode?.number ?? ""
                    
                    if regeocode?.aoiName != nil{
                        self?.area += (regeocode?.aoiName)!
                    }else{
                        self?.area += street + number
                    }
                    self?.addressFiled.text = (self?.province)! + (self?.city)! + (self?.area)!
                }
                
                self?.longitude = location!.coordinate.longitude
                self?.latitude = location!.coordinate.latitude
            }else{
                MBProgressHUD.showAutoDismissHUD(message: "定位失败，请重新定位")
            }
        }
    }
    
    func setupUI(){
        
        let viewBg1: UIView = UIView()
        viewBg1.backgroundColor = kWhiteColor
        view.addSubview(viewBg1)
        
        let desLab1: UILabel = UILabel()
        desLab1.text = "联系人"
        desLab1.textColor = kGaryFontColor
        desLab1.font = k15Font
        viewBg1.addSubview(desLab1)
        
        let line1: UIView = UIView()
        line1.backgroundColor = kGrayLineColor
        viewBg1.addSubview(line1)
        
        let nameLab: UILabel = UILabel()
        nameLab.text = "姓名："
        nameLab.textColor = kBlackFontColor
        nameLab.font = k15Font
        viewBg1.addSubview(nameLab)
        
        viewBg1.addSubview(nameFiled)
        
        let line2: UIView = UIView()
        line2.backgroundColor = kGrayLineColor
        viewBg1.addSubview(line2)
        
        viewBg1.addSubview(manCheckBtn)
        viewBg1.addSubview(womanCheckBtn)
        
        let line3: UIView = UIView()
        line3.backgroundColor = kGrayLineColor
        viewBg1.addSubview(line3)
        
        let phoneLab: UILabel = UILabel()
        phoneLab.text = "电话："
        phoneLab.textColor = kBlackFontColor
        phoneLab.font = k15Font
        viewBg1.addSubview(phoneLab)
        
        viewBg1.addSubview(phoneFiled)
        
        let viewBg2: UIView = UIView()
        viewBg2.backgroundColor = kWhiteColor
        view.addSubview(viewBg2)
        
        let desLab2: UILabel = UILabel()
        desLab2.text = "收货地址"
        desLab2.textColor = kGaryFontColor
        desLab2.font = k15Font
        viewBg2.addSubview(desLab2)
        
        let line4: UIView = UIView()
        line4.backgroundColor = kGrayLineColor
        viewBg2.addSubview(line4)
        
        let addressLab: UILabel = UILabel()
        addressLab.text = "详细地址："
        addressLab.textColor = kBlackFontColor
        addressLab.font = k15Font
        viewBg2.addSubview(addressLab)
        
        viewBg2.addSubview(addressFiled)
        
        let rightImg: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_gray"))
        viewBg2.addSubview(rightImg)
        
        let line5: UIView = UIView()
        line5.backgroundColor = kGrayLineColor
        viewBg2.addSubview(line5)
        
        let roomLab: UILabel = UILabel()
        roomLab.text = "楼号-门牌号："
        roomLab.textColor = kBlackFontColor
        roomLab.font = k15Font
        viewBg2.addSubview(roomLab)
        
        viewBg2.addSubview(roomFiled)
        
        let line6: UIView = UIView()
        line6.backgroundColor = kGrayLineColor
        viewBg2.addSubview(line6)
        
        viewBg2.addSubview(defaultCheckBtn)
        
        viewBg1.snp.makeConstraints { (make) in
            make.top.equalTo(kMargin)
            make.left.right.equalTo(view)
            make.height.equalTo(kTitleHeight*3+30+klineWidth*3)
        }
        desLab1.snp.makeConstraints { (make) in
            make.left.equalTo(viewBg1).offset(kMargin)
            make.top.equalTo(viewBg1)
            make.right.equalTo(viewBg1).offset(-kMargin)
            make.height.equalTo(30)
        }
        line1.snp.makeConstraints { (make) in
            make.top.equalTo(desLab1.snp.bottom)
            make.left.right.equalTo(viewBg1)
            make.height.equalTo(klineWidth)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(desLab1)
            make.top.equalTo(line1.snp.bottom)
            make.size.equalTo(CGSize.init(width: 50, height: kTitleHeight))
        }
        nameFiled.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab.snp.right)
            make.top.height.equalTo(nameLab)
            make.right.equalTo(desLab1)
        }
        line2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(line1)
            make.top.equalTo(nameLab.snp.bottom)
        }
        manCheckBtn.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.top.equalTo(line2.snp.bottom)
            make.right.equalTo(womanCheckBtn.snp.left).offset(-kMargin)
            make.width.equalTo(womanCheckBtn)
            make.height.equalTo(kTitleHeight)
        }
        womanCheckBtn.snp.makeConstraints { (make) in
            make.right.equalTo(nameFiled)
            make.top.size.equalTo(manCheckBtn)
        }
        line3.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(line2)
            make.top.equalTo(manCheckBtn.snp.bottom)
        }
        phoneLab.snp.makeConstraints { (make) in
            make.left.size.equalTo(nameLab)
            make.top.equalTo(line3.snp.bottom)
        }
        phoneFiled.snp.makeConstraints { (make) in
            make.left.size.equalTo(nameFiled)
            make.top.equalTo(phoneLab)
        }
        
        viewBg2.snp.makeConstraints { (make) in
            make.left.right.equalTo(viewBg1)
            make.top.equalTo(viewBg1.snp.bottom).offset(kMargin)
            make.height.equalTo(kTitleHeight*2+30+60)
        }
        desLab2.snp.makeConstraints { (make) in
            make.left.equalTo(viewBg2).offset(kMargin)
            make.top.equalTo(viewBg2)
            make.right.equalTo(viewBg2).offset(-kMargin)
            make.height.equalTo(30)
        }
        line4.snp.makeConstraints { (make) in
            make.left.right.equalTo(viewBg2)
            make.top.equalTo(desLab2.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        addressLab.snp.makeConstraints { (make) in
            make.left.equalTo(desLab2)
            make.top.equalTo(line4.snp.bottom)
            make.size.equalTo(CGSize.init(width: 80, height: kTitleHeight))
        }
        addressFiled.snp.makeConstraints { (make) in
            make.top.height.equalTo(addressLab)
            make.left.equalTo(addressLab.snp.right)
            make.right.equalTo(rightImg.snp.left).offset(-5)
        }
        rightImg.snp.makeConstraints { (make) in
            make.right.equalTo(viewBg2).offset(-kMargin)
            make.top.equalTo(line4.snp.bottom).offset(12)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        line5.snp.makeConstraints { (make) in
            make.right.left.height.equalTo(line4)
            make.top.equalTo(addressLab.snp.bottom)
        }
        roomLab.snp.makeConstraints { (make) in
            make.left.height.equalTo(addressLab)
            make.top.equalTo(line5.snp.bottom)
            make.width.equalTo(100)
        }
        roomFiled.snp.makeConstraints { (make) in
            make.left.equalTo(roomLab.snp.right)
            make.top.height.equalTo(roomLab)
            make.right.equalTo(viewBg2).offset(-kMargin)
        }
        line6.snp.makeConstraints { (make) in
            make.right.left.height.equalTo(line4)
            make.top.equalTo(roomLab.snp.bottom)
        }
        
        defaultCheckBtn.snp.makeConstraints { (make) in
            make.left.equalTo(roomLab)
            make.bottom.equalTo(viewBg2).offset(-kStateHeight)
            make.size.equalTo(CGSize.init(width: 120, height: 30))
        }
        
        
        if isAdd {
            self.title = "新增收货地址"
            defaultCheckBtn.isSelected = true
            manCheckBtn.isSelected = true
        } else {
            self.title = "编辑收货地址"
            nameFiled.text = addressInfo?.consignee
            if addressInfo?.sex == "0" {
                manCheckBtn.isSelected = true
            }else{
                womanCheckBtn.isSelected = true
            }
            phoneFiled.text = addressInfo?.tel
            
//            if (addressInfo?.province?.isEmpty)!{
//                addressFiled.text = addressInfo?.address
//            }else{
//                addressFiled.text = (addressInfo?.province)! + ""  + (addressInfo?.city)! + (addressInfo?.area)!
//                roomFiled.text = addressInfo?.address
//            }
            
            province = (addressInfo?.province)!
            city = (addressInfo?.city)!
            area = (addressInfo?.area)!
            address = (addressInfo?.address)!
            
            addressFiled.text = /*province + city +*/ area
            roomFiled.text = address
            latitude = Double.init((addressInfo?.ads_latitude)!)!
            longitude = Double.init((addressInfo?.ads_longitude)!)!
            isDefault = (addressInfo?.is_default)!
            sex = (addressInfo?.sex)!
            
            if isDefault == "1"{
                defaultCheckBtn.isSelected = true
            }
        }
        
    }
    
    /// 姓名输入框
    lazy var nameFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.clearButtonMode = .whileEditing
        textFiled.placeholder = "请输入姓名"
        
        return textFiled
    }()
    
    /// 手机号输入框
    lazy var phoneFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.placeholder = "请输入手机号"
        textFiled.keyboardType = .namePhonePad
        
        return textFiled
    }()
    /// 地址输入框
    lazy var addressFiled : UILabel = {
        
        let textFiled = UILabel()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.text = "点击定位"
        textFiled.addOnClickListener(target: self, action: #selector(selectAddressClick))
        
        return textFiled
    }()
    /// 房间号输入框
    lazy var roomFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.placeholder = "例 15栋甲单元201室"
        
        return textFiled
    }()
    
    /// 先生
    lazy var manCheckBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.setTitle("先生", for: .normal)
        btn.setImage(UIImage.init(named: "icon_check_normal"), for: .normal)
        btn.setImage(UIImage.init(named: "icon_check_selected"), for: .selected)
        btn.addTarget(self, action: #selector(radioBtnChecked(btn:)), for: .touchUpInside)
        btn.tag = 101
        
        return btn
    }()
    
    /// 女士
    lazy var womanCheckBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.setTitle("女士", for: .normal)
        btn.setImage(UIImage.init(named: "icon_check_normal"), for: .normal)
        btn.setImage(UIImage.init(named: "icon_check_selected"), for: .selected)
        btn.addTarget(self, action: #selector(radioBtnChecked(btn:)), for: .touchUpInside)
        btn.tag = 102
        
        return btn
    }()
    /// 设为默认地址
    lazy var defaultCheckBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kYellowFontColor, for: .normal)
        btn.setTitle("设为默认地址", for: .normal)
        btn.setImage(UIImage.init(named: "icon_check_normal"), for: .normal)
        btn.setImage(UIImage.init(named: "icon_check_selected"), for: .selected)
        btn.addTarget(self, action: #selector(defaultCheckBtnClick), for: .touchUpInside)
        
        return btn
    }()
    
    /// 设为默认地址
    func defaultCheckBtnClick(){
        defaultCheckBtn.isSelected = !defaultCheckBtn.isSelected
        if defaultCheckBtn.isSelected {
            isDefault = "1"
        }else{
            isDefault = "0"
        }
    }
    /// 选择先生/女士
    ///
    /// - Parameter btn:
    func radioBtnChecked(btn: UIButton){
        let tag = btn.tag
        
        btn.isSelected = !btn.isSelected
        
        if tag == 101 {/// 先生
            sex = "0"
            womanCheckBtn.isSelected = false
        } else {/// 女士
            sex = "1"
            manCheckBtn.isSelected = false
        }
    }
    
    /// 选择地址
    func goAddressVC(){
        let selectAddressVC = GYZSelectAddressVC()
        navigationController?.pushViewController(selectAddressVC, animated: true)
    }
    
    /// 数据是否有效
    func dataIsVailue() ->Bool{
        if (nameFiled.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入姓名")
            return false
        }
        if (phoneFiled.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入电话")
            return false
        }
        if (addressFiled.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入详细地址")
            return false
        }
        
        return true
    }
    
    /// 增加地址
    func requestUpdateAddress(){
        
        if !dataIsVailue() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        address = roomFiled.text!
        if address.isEmpty {
            address = ""
        }
        
        var params: [String : Any] = ["user_id":userDefaults.string(forKey: "userId") ?? "","consignee":nameFiled.text!,"province":province,"city":city,"area":area,"address":address,"is_default":isDefault,"ads_longitude":longitude,"ads_latitude":latitude,"sex":sex,"tel" : phoneFiled.text!]
        
        var url: String = "Address/add"
        if !isAdd {
            url = "Address/update"
            params["add_id"] = (addressInfo?.add_id)!
        }
        
        GYZNetWork.requestNetwork(url, parameters: params, success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
//            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                _ = weakSelf?.navigationController?.popViewController(animated: true)
            }
//            MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    func selectAddressClick(){
        goAddressVC()
    }
    
    ///MARK UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //textField变为不可编辑
//        configLocationManager()
        
        if textField == addressFiled {
            goAddressVC()
            return false
        }
//        goAddressVC()
        return true
    }
}
