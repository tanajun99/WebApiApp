//
//  MyAnnotation.swift
//  WebApiApp
//
//  Created by Junya Tanaka on 7/1/15.
//  Copyright (c) 2015 Tanajun99. All rights reserved.
//

import Foundation

class MyAnnotation: NSObject, YMKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    var annotationTitle: String!
    var annotationSubtitle: String!
    var annotationIndex: Int!
    
    init(locationCoordinate: CLLocationCoordinate2D, title: String!, subtitle:String!, index: Int){
        coordinate = locationCoordinate
        annotationTitle = title
        annotationSubtitle = subtitle
        annotationIndex = index
    }
    
    func title() -> NSString! {
        return annotationTitle
    }
    
    func subtitle() -> NSString! {
        return annotationSubtitle
    }
    
    
}