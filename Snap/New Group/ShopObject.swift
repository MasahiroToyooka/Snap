//
//  ShopObject.swift
//  Snap
//
//  Created by 豊岡正紘 on 2019/05/11.
//  Copyright © 2019 Masahiro Toyooka. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class ShopObject: NSObject, MKAnnotation {
    
    let title: String?
    let name: String
    let foursquareId: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, name: String, foursquareId: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.name = name
        self.foursquareId = foursquareId
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return name
    }
    
    func mapItem() -> MKMapItem {
        let placemark = MKPlacemark(coordinate: coordinate)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        
        return mapItem
    }
}
