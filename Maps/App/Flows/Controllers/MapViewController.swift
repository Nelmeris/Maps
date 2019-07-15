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
    @IBOutlet weak var newRouteButton: UIButton!
    
    var locationManager = LocationManager.instance
    
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    
    var isRouting: Bool = false
    
    var markerPosition: GMSMarker?
    
    var beginBackgroundTask: UIBackgroundTaskIdentifier?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurateMapView()
        configurateRoute()
        configurateLocationManager()
        configurateMarker()
    }
    
    fileprivate func setMarkerPosition(_ coordinate: CLLocationCoordinate2D) {
        guard let marker = markerPosition else { return }
        marker.position = coordinate
        marker.map = mapView
    }
    
    fileprivate func setCamera(_ coordinate: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        setMarkerPosition(coordinate)
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
    
    fileprivate func configurateMarker() {
        markerPosition = GMSMarker()
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let markerImagePath = documentsDirectory?.appendingPathComponent("MarkerImage.png").path
        if let image = UIImage(contentsOfFile: markerImagePath!) {
            markerPosition?.icon = UIImage.resize(image: image, targetSize: CGSize(width: 50, height: 50))
        }
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
    
    @IBAction func startNewRoute(_ sender: Any) {
        isRouting ? stopRouting() : startRouting()
        isRouting = !isRouting
    }
    
    /// Старт записи пути
    func startRouting() {
        configurateRoute(routeColor: .red, routeWidth: 10)
        beginBackgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            guard let strongSelf = self else { return }
            UIApplication.shared.endBackgroundTask(strongSelf.beginBackgroundTask!)
            strongSelf.beginBackgroundTask = UIBackgroundTaskIdentifier.invalid
        }
        
        newRouteButton.imageView?.image = #imageLiteral(resourceName: "StopRouting")
        locationManager.startUpdatingLocation()
    }
    
    /// Остановка записи пути и сохранение данных в базу
    func stopRouting() {
        if let coordinates = getCoordinatesOfPath(routePath) {
            RealmService.shared.saveCoordinates(coordinates: coordinates)
        }
        newRouteButton.imageView?.image = #imageLiteral(resourceName: "StopRouting")
        locationManager.stopUpdatingLocation()
    }
    
    /// Разбор путя на координаты
    func getCoordinatesOfPath(_ routePath: GMSMutablePath?) -> [CoordinatesRealmModel]? {
        guard let routePath = routePath else { return nil }
        var coordinates = [CoordinatesRealmModel]()
        for index in UInt(0)..<routePath.count() {
            let coordinate = CoordinatesRealmModel(coordinate: routePath.coordinate(at: index))
            coordinates.append(coordinate)
        }
        return coordinates
    }
    
    /// Восстановление путя из базы
    @IBAction func restorePath(_ sender: Any) {
        guard isRouting else {
            startRestoreRoute()
            return
        }
        
        let alert = UIAlertController(title: "Внимание", message: "Закончить запись трека?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
            self.isRouting = false
            
            self.newRouteButton.imageView?.image = #imageLiteral(resourceName: "StartRouting")
            self.locationManager.stopUpdatingLocation()
            self.startRestoreRoute()
        })
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    func startRestoreRoute() {
        configurateRoute(routeColor: .blue, routeWidth: 10)
        guard let coordinates = RealmService.shared.loadCoordinates() else { return }
        for coordinate in coordinates {
            let CLCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            setRoute(CLCoordinate)
        }
        let bounds = GMSCoordinateBounds(path: routePath!)
        markerPosition?.map = nil
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 100))
    }
    
    @IBAction func setMyLocation(_ sender: Any) {
        guard let location = locationManager.location.value else { return }
        setCamera(location.coordinate)
    }
    
    
    
}
