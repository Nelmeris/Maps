//
//  LocationManager.swift
//  Maps
//
//  Created by Artem Kufaev on 04/10/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCocoa

final class LocationManager: NSObject {
    
    static let instance = LocationManager()
    
    let locationManager = CLLocationManager()
    let location: Variable<CLLocation?> = Variable(nil)
    
    private override init() {
        super.init()
        configureLocationManager()
    }
    
    func configureLocationManager() {
        locationManager.delegate = self
        
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location.value = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
