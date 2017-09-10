//
//  GYZSelectAddressVC.swift
//  baking
//  地图定位，选择地址
//  Created by gouyz on 2017/5/6.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZSelectAddressVC: GYZBaseVC,MAMapViewDelegate,PlaceAroundTableViewDeleagate {
    
    var search: AMapSearchAPI!
    var mapView: MAMapView!
    
    var tableView: PlaceAroundTableView!
    
    var centerAnnotationView: UIImageView!
    var locationBtn: UIButton!
    var imageLocated: UIImage!
    var imageNotLocate: UIImage!
    
    var searchTypeSegment: UISegmentedControl!
    var searchTypes: Array<String>!
    var currentType: String?
    
    var isMapViewRegionChangedFromTableView: Bool = false
    var isLocated: Bool = false
    var searchPage: Int = 0
    
    //////搜索关键字
    var searchController: UISearchController!
    var keyTableView: UITableView!
    
    var keyTableData: Array<AMapTip>!
    var keySearch: AMapSearchAPI!
    var currentRequest: AMapInputTipsSearchRequest?
    ///当前定位城市
    var currCity: String = "南京市"
    var currProvince: String = ""
    var currArea: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "选择地址"
        
        keyTableData = Array()
        
        initTableView()
        initSearch()
        initMapView()
        
        initCenterView()
        initLocationButton()
        initSearchTypeView()
        
        ////关键字搜索
        initKeySearch()
        initSearchController()
        initKeyTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        searchController.isActive = false
        searchController.searchBar.removeFromSuperview()
    }
    
    func initSearch() {
        search = AMapSearchAPI()
        search.delegate = self.tableView
    }
    
    func initMapView() {
        mapView = MAMapView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height / 2.0))
        mapView.delegate = self
        self.mapView.zoomLevel = 17
        self.mapView.showsUserLocation = true
        self.view.addSubview(mapView)
    }
    func initTableView() {
        
        self.tableView = PlaceAroundTableView(frame: CGRect(x: 0, y: self.view.bounds.height / 2.0 - kTitleAndStateHeight, width: self.view.bounds.width, height: self.view.bounds.height / 2.0))
        self.tableView.delegate = self;
        
        self.view.addSubview(self.tableView)
    }
    
    func initCenterView() {
        self.centerAnnotationView = UIImageView(image: UIImage(named: "wateRedBlank"))
        
        self.centerAnnotationView.center = CGPoint(x: self.mapView.center.x, y: self.mapView.center.y - self.centerAnnotationView.bounds.height / 2.0)
        
        self.mapView.addSubview(self.centerAnnotationView)
    }
    
    func initLocationButton() {
        
        self.imageLocated = UIImage(named: "gpssearchbutton")!
        self.imageNotLocate = UIImage(named: "gpsnormal")!
        self.locationBtn = UIButton(frame: CGRect(x: CGFloat(self.mapView.bounds.width - 40), y: CGFloat(self.mapView.bounds.height - 50), width: CGFloat(32), height: CGFloat(32)))
        self.locationBtn.autoresizingMask = .flexibleTopMargin
        self.locationBtn.backgroundColor = UIColor.white
        self.locationBtn.layer.cornerRadius = 3
        self.locationBtn.addTarget(self, action: #selector(self.actionLocation), for: .touchUpInside)
        self.locationBtn.setImage(self.imageNotLocate, for: .normal)
        self.view.addSubview(self.locationBtn)
    }
    
    func initSearchTypeView() {
        
        self.searchTypes = ["住宅", "学校", "楼宇", "商场"]
        self.currentType = self.searchTypes.first!
        self.searchTypeSegment = UISegmentedControl(items: self.searchTypes)
        self.searchTypeSegment.frame = CGRect(x: CGFloat(10), y: CGFloat(self.mapView.bounds.height - 50), width: CGFloat(self.mapView.bounds.width - 80), height: CGFloat(32))
        self.searchTypeSegment.layer.cornerRadius = 3
        self.searchTypeSegment.backgroundColor = UIColor.white
        self.searchTypeSegment.autoresizingMask = .flexibleTopMargin
        self.searchTypeSegment.selectedSegmentIndex = 0
        self.searchTypeSegment.addTarget(self, action: #selector(self.actionTypeChanged), for: .valueChanged)
        self.view.addSubview(self.searchTypeSegment)
    }
    
    
    ////关键字搜索
    func initKeyTableView() {
        
//        let tableY = self.navigationController!.navigationBar.frame.maxY
        keyTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), style: UITableViewStyle.plain)
        keyTableView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        keyTableView.delegate = self
        keyTableView.dataSource = self
        keyTableView.isHidden = true
        self.view.addSubview(keyTableView)
    }
    func initKeySearch() {
        keySearch = AMapSearchAPI()
        keySearch.delegate = self
    }
    func initSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self;
        searchController.dimsBackgroundDuringPresentation = false;
        searchController.hidesNavigationBarDuringPresentation = false;
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "请输入关键字"
        searchController.searchBar.sizeToFit()
        
        // fix the warning for [Attempting to load the view of a view controller while it is deallocating is not allowed and may result in undefined behavior]
        if #available(iOS 9.0, *) {
            self.searchController.loadViewIfNeeded()
        } else {
            // Fallback on earlier versions
            let _ = self.searchController.view
        }
        
        
        self.navigationItem.titleView = searchController.searchBar
    }

    //MARK: - Action
    
    func actionSearchAround(at coordinate: CLLocationCoordinate2D) {
        self.searchReGeocode(withCoordinate: coordinate)
        self.searchPoi(withCoordinate: coordinate)
        self.searchPage = 1
        self.centerAnnotationAnimimate()
    }
    
    func actionLocation() {
        if self.mapView.userTrackingMode == .follow {
            self.mapView.setUserTrackingMode(.none, animated: true)
        }
        else {
            self.searchPage = 1
            self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.5 * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {() -> Void in
                // 因为下面这句的动画有bug，所以要延迟0.5s执行，动画由上一句产生
                self.mapView.setUserTrackingMode(.follow, animated: true)
            })
        }
    }
    
    func actionTypeChanged(_ sender: UISegmentedControl) {
        self.currentType = self.searchTypes[sender.selectedSegmentIndex]
        self.actionSearchAround(at: self.mapView.centerCoordinate)
    }
    
    
    func centerAnnotationAnimimate() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            var center = self.centerAnnotationView.center
            center.y -= 20
            self.centerAnnotationView.center = center
        }, completion: { _ in })
        UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseIn, animations: {() -> Void in
            var center = self.centerAnnotationView.center
            center.y += 20
            self.centerAnnotationView.center = center
        }, completion: { _ in })
    }
    
    func searchPoi(withCoordinate coord: CLLocationCoordinate2D) {
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(coord.latitude), longitude: CGFloat(coord.longitude))
        request.radius = 1000
        request.types = self.currentType
        request.sortrule = 0
        request.page = self.searchPage
        self.search.aMapPOIAroundSearch(request)
    }
    
    func searchReGeocode(withCoordinate coord: CLLocationCoordinate2D) {
        let request = AMapReGeocodeSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(coord.latitude), longitude: CGFloat(coord.longitude))
        request.requireExtension = true
        self.search.aMapReGoecodeSearch(request)
    }
    
    
    //MARK: - MAMapViewDelegate
    
    func mapView(_ mapView: MAMapView!, didChange mode: MAUserTrackingMode, animated: Bool) {
        if mode == .none {
            self.locationBtn.setImage(self.imageNotLocate, for: .normal)
        }
        else {
            self.locationBtn.setImage(self.imageLocated, for: .normal)
        }
    }
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        if !updatingLocation {
            return
        }
        if userLocation.location.horizontalAccuracy < 0 {
            return
        }
        // only the first locate used.
        if !self.isLocated {
            self.isLocated = true
            self.mapView.userTrackingMode = .follow
            self.mapView.centerCoordinate = userLocation.location.coordinate
            self.actionSearchAround(at: userLocation.location.coordinate)
            
            getCityByReGeo(coordinate: userLocation.location.coordinate)
        }
    }
    
    func mapView(_ mapView: MAMapView!, regionDidChangeAnimated animated: Bool) {
        if !self.isMapViewRegionChangedFromTableView && self.mapView.userTrackingMode == .none {
            self.actionSearchAround(at: self.mapView.centerCoordinate)
        }
        self.isMapViewRegionChangedFromTableView = false
    }

    
    //MARK:- PlaceAroundTableViewDeleagate
    
    func didTableViewSelectedChanged(selectedPOI: AMapPOI!) {
        if self.isMapViewRegionChangedFromTableView == true {
            return
        }
        
        self.isMapViewRegionChangedFromTableView = true
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(selectedPOI.location.latitude), longitude: CLLocationDegrees(selectedPOI.location.longitude))
        self.mapView.setCenter(location, animated: true)
        
        for i in 0..<(navigationController?.viewControllers.count)!{
            
            if navigationController?.viewControllers[i].isKind(of: GYZEditAddressVC.self) == true {
                
                let vc = navigationController?.viewControllers[i] as! GYZEditAddressVC
                vc.latitude = location.latitude
                vc.longitude = location.longitude
                vc.province = currProvince
                vc.city = currCity
                vc.area = selectedPOI.name
                vc.address = ""
                _ = navigationController?.popToViewController(vc, animated: true)
                
                break
            }
        }
    }
    
    func didLoadMorePOIButtonTapped() {
        self.searchPage += 1
        self.searchPoi(withCoordinate: self.mapView.centerCoordinate)
    }
    
    func didPositionCellTapped(currAddress: AMapReGeocode) {
        if self.isMapViewRegionChangedFromTableView == true {
            return
        }
        self.isMapViewRegionChangedFromTableView = true
        self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: true)
        for i in 0..<(navigationController?.viewControllers.count)!{
            
            if navigationController?.viewControllers[i].isKind(of: GYZEditAddressVC.self) == true {
                
                let vc = navigationController?.viewControllers[i] as! GYZEditAddressVC
                vc.latitude = self.mapView.userLocation.coordinate.latitude
                vc.longitude = self.mapView.userLocation.coordinate.longitude
                vc.province = ""
                vc.city = ""
                vc.area = currAddress.formattedAddress
                vc.address = ""
                _ = navigationController?.popToViewController(vc, animated: true)
                
                break
            }
        }
    }
    
}

extension GYZSelectAddressVC : AMapSearchDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating{
    
    
    /// 坐标转地址
    ///
    /// - Parameter coordinate: 坐标
    func getCityByReGeo(coordinate: CLLocationCoordinate2D){
        
        let request = AMapReGeocodeSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
        request.requireExtension = true
        
        keySearch.aMapReGoecodeSearch(request)
    }
    //MARK: - Action
    
    func searchTip(withKeyword keyword: String?) {
        
        if keyword == nil || keyword! == "" {
            return
        }
        
        let request = AMapInputTipsSearchRequest()
        request.keywords = keyword
        
        request.city = currCity
        currentRequest = request
        keySearch.aMapInputTipsSearch(request)
    }
    
//    func searchPOI(withTip tip: AMapTip?) {
//        if tip == nil || tip!.name == "" {
//            return
//        }
//        
//        let request = AMapPOIKeywordsSearchRequest()
//        request.cityLimit = true
//        request.keywords = tip!.name
//        request.city = SearchCity
//        request.requireExtension = true
//        
//        search.aMapPOIKeywordsSearch(request)
//    }
    
    //MARK:- UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        
        keyTableView.isHidden = !searchController.isActive
        searchTip(withKeyword: searchController.searchBar.text)
        
        if searchController.isActive && searchController.searchBar.text != "" {
            searchController.searchBar.placeholder = searchController.searchBar.text
        }
    }
    
    //MARK: - AMapSearchDelegate
    
    /* 输入提示回调. */
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        print("error :\(error)")
    }
    
    func onInputTipsSearchDone(_ request: AMapInputTipsSearchRequest!, response: AMapInputTipsSearchResponse!) {
        
        if currentRequest == nil || currentRequest! != request {
            return
        }
        
        if response.count == 0 {
            return
        }
        
        keyTableData.removeAll()
        for aTip in response.tips {
            keyTableData.append(aTip)
        }
        keyTableView.reloadData()
    }
    
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        
        if response.regeocode == nil {
            return
        }
        
        currCity = response.regeocode.addressComponent.city
        currArea = response.regeocode.addressComponent.district
        currProvince = response.regeocode.addressComponent.province
    }
    
    //MARK:- TableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        
        let tip = keyTableData[indexPath.row]
        
        searchController.isActive = false
        
        for i in 0..<(navigationController?.viewControllers.count)!{
            
            if navigationController?.viewControllers[i].isKind(of: GYZEditAddressVC.self) == true {
                
                let vc = navigationController?.viewControllers[i] as! GYZEditAddressVC
                vc.area = tip.district + tip.address
                vc.province = ""
                vc.city = ""
                vc.address = ""
                vc.latitude = Double(tip.location.latitude)
                vc.longitude = Double(tip.location.longitude)
                _ = navigationController?.popToViewController(vc, animated: true)
                
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyTableData.count
    }
    
    //MARK:- TableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "keyCellIdentifier"
        
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
        }
        
        if !keyTableData.isEmpty {
            
            let tip = keyTableData[indexPath.row]
            
            cell!.textLabel?.text = tip.name
            cell!.detailTextLabel?.text = tip.address
        }
        
        return cell!
    }


}
