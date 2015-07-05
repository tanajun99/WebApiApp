//
//  YahooLocationWrapper.swift
//  WebApiApp
//
//  Created by Junya Tanaka on 7/5/15.
//  Copyright (c) 2015 Tanajun99. All rights reserved.
//

import Foundation

class YahooLocationWrapper {
    let appId = "<アプリケーションID>"
    let baseUrl = "http://search.olp.yahooapis.jp/OpenLocalPlatform/v1/localSearch?appid="
    //レスポンス形式はjson
    let outputParam = "&output=json"
    //上限件数30
    let resultsParam = "&results=30"
    //距離、適合順でソート
    let sortParam = "&sort=hybrid"
    //出力に詳細情報含める
    let detailparam = "&detail=full"
    //検索範囲の半径（km）
    let distParam = "&dist="
    //検索ワード
    let queryParam = "&query="
    //緯度
    let latParam = "&lat="
    //経度
    let lonParam = "&lon="
    
    class var sharedInstance: YahooLocationWrapper {
        var sharedInstance = YahooLocationWrapper()
    }
    
    func requestList(queryWord: String, location: CLLocationCoordinate2D, distance: CLLocationDistance, completation: ((response: NSURLResponse!, data: [ShopModel]?, error:NSError?) -> Void)){
        //検索キーワードをURLエンコード
        let queryValue = queryWord.stringByAddingParentEncodingWithAllowedCharacters(
            NSCharacterSet.URLQueryAllowedCharacterSet()
        )
        
        //URL文字列くみたて
        let urlStr = "\(baseUrl)\(appId)\(outputParam)\(detailParam)\(resultsParam)\(sortParam)" + "\(latParam)\(location.latitude)\(lonParam)\(location.longitude)" + "\(distParam)\(distance)" + "\(queryParam)\(queryValue!)"
        //NSURLRequestインスタンスを生成
        let req = NSURLRequest(URL: NSURL(string: urlStr)!,cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60.0)
        
        //非同期処理をGCDに依頼するため、NSOperationQueueインスタンスを生成
        let queue: NSOperationQueue = NSOperationQueue()
        
        //NSURLConnectionクラスによって非同期でAPIをよびだし、レスポンスをクロージャでよびだす。
        NSURLConnection.sendAsynchronousRequest(req, queue: queue, completionHandler: {
            [unowned self]
            (response: NSURLResponse, data: NSData!, error: NSError!) -> Void in
            
            var jsonResult: NSDictionary? = nil
            var resultError: NSError? = error
            var resultData: [ShopModel]?
            
            //errorがnilであればサバート通信
            if error == nil {
                 //NSJSONSerializationをもちいてJSONをNSDictionary型のデータ変換
                jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &resultError) as? NSDictionary
                
                if resultError == nil && jsonResult != nil{
                    resultData = self.parseResponseJson(jsonResult!)
                }
            }
            
            //結果を返す
            completion(response: response, data: resultData, error: resultError)
        })
    }
    
    //レスポンスjsonを解析し、ShopModelオブジェクトの配列を返す
    func parseResponseJson(json: NSDictionary) -> [ShopModel]? {
        //ResultInfoがない場合は検索に失敗している
        if json.objectForKey("ResultInfo") == nil {
            return nil
        }
        
        let resultInfo = json["ResultInfo"] as! NSDictionary
        let count = resultInfo["Count"] as! Int
        
        //ResultInfo内のCountが0の場合は検索結果が0件
        if count == 0 {
            return nil
        }
        
        let features = json["Feature"] as? [NSDictionary]
        
        //Featureがない場合にも検索に失敗。
        if features == nil{
            return nil
        }
        
        //shopmodelの配列を生成
        var shopList = [ShopModel]()
        
        //Feature以下のデータから、ShopModelオブジェクトを生成し配列に登録
        for feature in features! {
            var shopData = ShopModel()
            
            let property = feature["Property"] as? NSDictionary
            let detail = property!["Detail"] as? NSDictionary
            
            shopData.name = feature["Name"] as! String
            shopData.uid = property!["Uid"] as! String
            shopData.address = property!["Address"] as? String
            shopData.catchCopy = property!["CatchCopy"] as? String
            shopData.tel = property!["Tel1"] as? String
            shopData.thumbnail = property!["LeadImage"] as? String
            shopData.imageUrl = detail!["Image1"] as? String
            shopData.url = detail!["YUrl"] as? String
            shopData.pcUrl = detail!["PcUrl1"] as? String
            shopData.mobileUrl = detail!["MobileUrl1"] as? String
            
            let geometry = feature["Geometory"] as? NSDictionary
            
            if let geo = geometry {
                //緯度・経度の文字列を取得して","で分割
                let coordinates = geo["Coordinates"] as! String
                let coordinatesArray = split(coordinates, isSeparator: { $0 == ","})
                
                //CLLocationCoordinate2D型に変換して登録
                shopData.location = CLLocationCoordinate2DMake(atof(coordinatesArray[1]) as CLLocationDegree,atof(coordinatesArray[0]) as CLLocationDegree)
            }
            
            shopList.append(shopData)
        }
        return shopList
    }
}
