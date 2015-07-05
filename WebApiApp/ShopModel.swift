//
//  ShopModel.swift
//  WebApiApp
//
//  Created by Junya Tanaka on 7/1/15.
//  Copyright (c) 2015 Tanajun99. All rights reserved.
//

import Foundation

class ShopModel {
    //店舗ユニークID
    var uid: String!
    //店舗名
    var name: String!
    //住所
    var address: String!
    //電話番号
    var tel: String!
    //キャッチコピー
    var catchCopy: String!
    //経度・緯度
    var location: CLLocationCoordinate2D?
    //サムネール画像URL
    var thumbnailUrl: String!
    //画像URL
    var imageUrl: String?
    //Yahoo! JapanロゴのURL
    var url: String?
    //データ提供元のPCむけURL
    var pcUrl: String?
    //データ提供元のモバイル向けURL
    var mobileUrl: String?
    
    init(){
        
    }

}