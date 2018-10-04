//
//  MapViewUIViewController.swift
//  VK X
//
//  Created by Artem Kufaev on 26/07/2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import RealmSwift

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager = LocationManager.instance
    
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    
    var isRouting: Bool = false
    
    var beginBackgroundTask: UIBackgroundTaskIdentifier?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurateMapView()
        configurateRoute()
        configurateLocationManager()
    }
    
    fileprivate func setMarker(_ coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
    }
    
    fileprivate func setCamera(_ coordinate: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        mapView.animate(to: camera)
    }
    
    fileprivate func setRoute(_ coordinate: CLLocationCoordinate2D) {
        routePath?.add(coordinate)
        route?.path = routePath
    }
    
    fileprivate func configurateMapView() {
        mapView.settings.rotateGestures = true
        mapView.delegate = self
    }
    
    fileprivate func configurateLocationManager() {
        locationManager.location.asObservable().bind { [weak self] location in
            guard let strongSelf = self else { return }
            guard let location = location else { return }
            
            if strongSelf.isRouting {
                strongSelf.setRoute(location.coordinate)
            }
            
            strongSelf.setCamera(location.coordinate)
            
        }
    }
    
    fileprivate func configurateRoute(routeColor: UIColor = .red, routeWidth: CGFloat = 4.0) {
        isRouting = false
        route?.map = nil
        route = GMSPolyline()
        route?.strokeColor = routeColor
        route?.strokeWidth = routeWidth
        routePath = GMSMutablePath()
        route?.map = mapView
    }
    
    @IBOutlet weak var newRouteButton: UIButton!
    @IBAction func startNewRoute(_ sender: Any) {
        if !isRouting {
            configurateRoute(routeColor: .red, routeWidth: 10)
            beginBackgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
                guard let strongSelf = self else { return }
                UIApplication.shared.endBackgroundTask(strongSelf.beginBackgroundTask!)
                strongSelf.beginBackgroundTask = UIBackgroundTaskIdentifier.invalid
            }
            
            newRouteButton.setImage(#imageLiteral(resourceName: "StopRouting"), for: UIControl.State(rawValue: 0))
            locationManager.startUpdatingLocation()
        } else {
            if let coordinates = getCoordinatesOfPath(routePath) {
                RealmService.shared.saveCoordinates(coordinates: coordinates)
            }
            newRouteButton.setImage(#imageLiteral(resourceName: "StartRouting"), for: UIControl.State(rawValue: 0))
            locationManager.stopUpdatingLocation()
        }
        isRouting = !isRouting
    }
    
    func getCoordinatesOfPath(_ routePath: GMSMutablePath?) -> [Coordinates]? {
        guard let routePath = routePath else { return nil }
        var coordinates = [Coordinates]()
        for index in UInt(0)..<routePath.count() {
            let coordinate = Coordinates(coordinate: routePath.coordinate(at: index))
            coordinates.append(coordinate)
        }
        return coordinates
    }
    
    @IBAction func restorePath(_ sender: Any) {
        if isRouting {
            let alert = UIAlertController(title: "Внимание", message: "Закончить запись трека?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                self.isRouting = false
                
                self.newRouteButton.setImage(#imageLiteral(resourceName: "StartRouting"), for: UIControl.State(rawValue: 0))
                self.locationManager.stopUpdatingLocation()
                self.startRestoreRoute()
            })
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel) { action in
                return
            })
            self.present(alert, animated: true, completion: nil)
        } else {
            startRestoreRoute()
        }
    }
    
    func startRestoreRoute() {
        configurateRoute(routeColor: .blue, routeWidth: 10)
        do {
            let realm = try Realm()
            let coordinates = realm.objects(Coordinates.self)
            for coordinate in coordinates {
                let CLCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                setRoute(CLCoordinate)
            }
            let bounds = GMSCoordinateBounds(path: routePath!)
            mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 100))
        } catch {
            print(error)
        }
    }
    
}
