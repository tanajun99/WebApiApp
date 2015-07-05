//
//  ShopInfoViewController.swift
//  
//
//  Created by Junya Tanaka on 7/1/15.
//
//

import UIKit

class ShopInfoViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var shopNameLabel: UILabel!
    @IBOutlet var catchCopyLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var browserButton: UIButton!
    @IBOutlet var telButton: UIButton!
    
    var shopInfo: ShopModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if shopInfo == nil{
            return
        }
        //ラベルのテキスト設定
        shopNameLabel.text = shopInfo.name
        catchCopyLabel.text = shopInfo.catchCopy
        //ボタンの設定
        browserButton.enabled = shopInfo.url != nil || shopInfo.mobileUrl != nil||; shopInfo.pcUrl != nil
        telButton.enabled = shopInfo.tel != nil
        
        //画像表示。shop.imageURlがある場合はそちらを優先して表示する
        var imageUrlStr: String!
        if shopInfo.imageUrl != nil && shopinfo.imageUrl! != "" {
            imageUrlStr = shopInfo.imageUrl
        }else if shopInfo.thumbnailUrl != nil && shopInfo.thumbnailUrl! != ""{
            imageUrlStr = shopInfo.thumbnailUrl
        }
        if imageUrlStr == nil{
            imageView.backgroundColor = UIColor.blackColor()
            return
        }
        imageView.image = nil
        //画像を非同期に読み込み、読み込み完了後に表示する。
        let imageUrl = NSURL(string: imageUrlStr!)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIMARITY_DEFAULT,0),{
        [unowned self] in
        let data = NSData(contentsOfURL: imageUrl!)
        
        if data != nil {
        let image = UIImage(data: data!)
        dispatch_async(dispatch_get_main_queue(), {
        self.imageView.image = image
        })
        
        }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func browserButtonClicked(sender: UIButton){
        if shopInfo == nil {
            return
        }
        
        //url, modelUrl, ocUrlの優先度で、開くUrlを決定
        let urlStr = shopInfo.url ?? shopInfo.mobileUrl ?? shopInfo.pcUrl
        
        let url = NSURL(string: urlStr!)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    //電話ボタンが押された時、電話番号
    @IBAction func telButtonClicked(sender: UIButton){
        if shopinfo == nil || shopInfo.tel == nil{
            return
        }
        
        let url = NSURL(string: "tel:" + shopInfo.tel!)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    class func createInstance() -> ShopInfoViewController {
        //"shop.storybordを読み込み、UIStoryboardのインスタンスを生成する"
        let storyboad = UIStoryboard(name: "ShopInfo", bundle:NSBundle.mainBundle())
        //storyboardにて指定された初期ビューコントローラーをインスタンス化する
        let viewController = storyboad.instantiateInitialViewController() as! ShopInfoViewController
        //インスタンス化されたビューコントローラーを返す
        return ViewController
    }
    
    func setShopInfo(shopInfo: ShopModel){
        self.shopInfo = shopInfo
    }
    
}
