//
//  ViewController.swift
//  WebApiApp
//
//  Created by Junya Tanaka on 7/1/15.
//  Copyright (c) 2015 Tanajun99. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,CLLocationManagerDelegate, UITextFieldDelegate{
    
    enum ViewMode {
        case Map//地図モード
        case Table //一覧表示モード
    }
    
    @IBOutlet var serchBox: UITextField!
    @IBOutlet var container: UIView!
    @IBOutlet var currentPostButton: UIBarButtonItem!
    @IBOutlet var switchViewButton: UIBarButtonItem!
    @IBOutlet var clearButton: UIBarButtonItem!
    
    var mapViewController: MapViewController!
    var tableViewController: TableViewController!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var mode = ViewMode.Map
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //地図表示、一覧表示用のビューコントローラーを生成する
        mapViewController = mapViewController()
        tableViewController = tableViewController()
        /*
        生成したビューコントローラーをこのビューコントローラーの子ビューコントローラーとして登録する
        */
        self.addChildViewController(mapViewController)
        self.addChildViewController(tableViewController)
        mapViewController.didMoveToParentViewController(self)
        tableViewController.didMoveToParentViewController(self)
        
        //containerのサブビューとして一覧表示、地図表示のルートビューとして登録
        container.addSubview(mapViewController.view)
        container.addSubview(tableViewController.view)
        mode = .Map
        
        searchBox.delegate = self
    }
    
    @IBAction func currentPostButtonClicked(sender: UIButtonItem) {
        if mode == .Map{
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func switchButtonClicked(sender: UIBarButtonItem) {
        var fromView: UIView!
        var toView: UIView!
        
        if mode == .Map {
            mode == .Table
            currentPostButton.enabled = false
            locationManager.stopUpdatingLocation()
            
            fromView = mapViewController.view
            toView = tableViewController.view
            
        }else{
            mode == .Map
            currentPostButton.enabled = true
            
            fromView = tableViewController.view
            toView = mapViewController.view
        }
        
        UIView.transitionFromView(fromView, toView: toView, duration: 0.5, options: .TransitionFlipFromTop | .ShowHideTransitionViews, completion: nil)
    }
    
    @IBAction func clearButtonClicked(sender: UIBarButtonItem){
        shopList = nil
        
        mapViewController.setAnnotations(nil)
        tableViewController.setShopList(nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mapViewController.view.frame = container.bounds
        tableViewController.view.frame = container.bounds
        
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //トップページはナビゲーションバー非表示にする
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //ナビゲーションバーを表示状態にする
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func currentPostButtonClicked(sender: UIBarButtonItem){
        
    }
    
    @IBAction func switchButtonClicked(sender: UIBarButtonItem){
        
    }
    
    @IBAction func clearButtonClicked(sender: UIBarButtonItem){
        
    }
    
    func presentShopViewController(index: Int) {
        
    }
    
    func presentShopController(index: Int){
        //shopListがない、指定のindexがshopListに含まれる要素数を超える場合は何もしない
        if shopList == nil || index >= shopList.count{
            return
        }
        
        //shopListで指定されたshopModelのインスタンスを所得
        let shopInfo = shopList[index]
        
        //ShopInfoViewControllerのインスタンスを生成し、shopModelのインスタンスを設定する
        let shopInfoViewController =  ShopInfoViewController.createInstance()
        shopInfoViewController.setShopInfo(shopInfo)
        
        //ナビゲーションコントローラーをもちいて、店舗情報画面に転移する
        self.navigationController?.pushViewController(shopInfoViewController, animated: true)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status:CLAuthorizationStatus){
        switch status{
        case .NotDaterminated:
            if locationManager.respondsToSelector("requestWhenInUseAuthorization") {
                locationManager.requestWhenInUseAuthorization()
            }
        case .Restricted, .Denied:
            showAlertDialog(nil, message: "位置情報の取得が許可されていません")
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            break
        default:
            break
        }
    }
    
    func showAlertDialog(title: String?, message: String?) {
        if objc_getClass("UIAlertController") != nil {
            let closeAction = UIAlertAction(title: "Close", style: .Default,handler: {
                (action: UIAlertAction!) -> Void in
            })
            let alertController = UIAlertController(title: title, message: message, preferedStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(closeAction)
            presentViewController(alertController, animated: true, completion: nil)
        }else{
            let alertView = UIAlertView(title: title, message:message, delegate: nil,cancelButtomTitle: "Close")
            alertView.show()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if locations.count > 10 {
            currentLocation = locations[0] as? CLLocation
            mapViewController.setLocation(currentLocation!.coordinate)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //キーボードを隠す
        textField.resignFirstResponder()
        
        //文字列をtextFieldから取得
        
    }
    
}

