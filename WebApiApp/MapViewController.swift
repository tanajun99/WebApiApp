//
//  MapViewController.swift
//  
//
//  Created by Junya Tanaka on 7/1/15.
//
//

import UIKit

class MapViewController: UIViewController , YMKMapViewDelegate{
    
    var mapView: YMKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        
        //YMKMapViewを生成する
        mapView = YMKMapView(frame: self.view.bounds, appid: "<アプリケーションID>")
        mapView.showsUserLocation = true
        mapView.scalebarVisible = true
        mapView.delegate = self
        self.view.addSubview(mapView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func  viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mapView.frame = self.view.bounds
        
        self.view.layoutIfNeeded()
    }
    
    func setLocation(location: CLLocationCoordinate2D){
        //緯度・経度ともに世界測地系で0.02の範囲とする
        
        let span = YMKCoodinateSpanMake(0.02, 0.02)
        //引数でわたされたlocationを中心として、上記の範囲を表示領域とする。
        let region = YMKCoodinateRegionMake(location, span)
        
        mapView.setRegion(region, animated:true)
        
    }
    
    func setAnnotations(annotations: [AnyObject]!){
        mapView.removeAnnotations(mapView.annotations)
        
        if annotations != nil && annotations.count > 0 {
            mapView.addAnnotations(annotations)
        }
    }
    
    func mapView(mapView: YMKMapView!, viewForAnnotation annotation: YMKAnnotation!) -> YMKAnnotation! {
        if annotation is MyAnnotation{
            let myAnnotation = annotation as! MyAnnotation
            var pin = YMKPinAnnotationView(annotation: annotation, reuseIdentifier:"Pin")
            pin.animateDrop = true
            
            //マーカーをタップしたときに開くバルーンの右側にボタンを表示する。
            var rightView = UIButton.buttonWithType(UIButtonType.InfoLight) as! UIButton
            rightView.frame = CGRectMake(0.0, 0.0, 40.0, 40.0)
            
            //ボタンのtagに、何番目のannotationに対応するものかを設定できる。
            rightView.tag = myAnnotation.annotationIndex
            pin.rightCalloutAccessoryView = rightView
            
            return pin
        }
        return nil
    }
    
    func mapView(mapView: YMKMapView!, annotationView view: YMKAnnotation!, calloutAccessoryControlTapped control: UIControl!){
        let index = control.tag
        let parentViewController = self.parentViewController as! ViewController
        
        parentViewController.parentShopViewController(index)
    }
}
