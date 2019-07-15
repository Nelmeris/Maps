//
//  CoordinatesRealmModel.swift
//  Maps
//
//  Created by Artem Kufaev on 25/09/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import RealmSwift
import CoreLocation

class CoordinatesRealmModel: Object {
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    
    required convenience init(coordinate: CLLocationCoordinate2D) {
        self.init()
        
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
}
