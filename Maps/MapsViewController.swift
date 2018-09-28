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
    
    var locationManager: CLLocationManager?
    
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    
    var isRouting: Bool = false
    
    var beginBackgroundTask: UIBackgroundTaskIdentifier?
    
    fileprivate func configurateMapView() {
        mapView.settings.rotateGestures = true
        mapView.delegate = self
    }
    
    fileprivate func configurateLocationManager() {
        locationManager = CLLocationManager()
        
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.requestAlwaysAuthorization()
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.delegate = self
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last?.coordinate else { return }
        
        let coordinate = CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        
        if isRouting {
            setRoute(coordinate)
        }
        
        setCamera(coordinate)
    }
    
    @IBOutlet weak var newRouteButton: UIBarButtonItem!
    @IBAction func startNewRoute(_ sender: Any) {
        if !isRouting {
            newRouteButton.title = "Stop"
            newRouteButton.tintColor = .red
            
            beginBackgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
                guard let strongSelf = self else { return }
                UIApplication.shared.endBackgroundTask(strongSelf.beginBackgroundTask!)
                strongSelf.beginBackgroundTask = UIBackgroundTaskIdentifier.invalid
            }
            
            configurateRoute()
            isRouting = true
            locationManager?.startUpdatingLocation()
        } else {
            isRouting = false
            var coordinates = [Coordinates]()
            for index in UInt(0)..<(routePath?.count())! {
                let coordinate = Coordinates(coordinate: (routePath?.coordinate(at: index))!)
                coordinates.append(coordinate)
            }
            do {
                let realm = try Realm()
                realm.beginWrite()
                realm.deleteAll()
                realm.add(coordinates)
                try realm.commitWrite()
            } catch {
                print(error)
            }
            newRouteButton.title = "Start"
            newRouteButton.tintColor = .blue
            locationManager?.stopUpdatingLocation()
        }
    }
    
    @IBAction func restorePath(_ sender: Any) {
        if isRouting {
            let alert = UIAlertController(title: "Внимание", message: "Закончить запись трека?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                self.isRouting = false
                self.newRouteButton.title = "Start"
                self.newRouteButton.tintColor = .blue
                self.locationManager?.stopUpdatingLocation()
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
        configurateRoute(routeColor: .green)
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
