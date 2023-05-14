//
//  LocationManager.swift
//  Clima
//
//  Created by Nicole Scholtz on 2023/05/14.
//

import Foundation
import CoreLocation

protocol LocationManagable {
    func setupLocationManager(locationDelegate: LocationManagerDelegate?)
}

protocol LocationManagerDelegate: AnyObject {
    func locationDetermined(lat: Double, lon: Double)
}

class LocationManager: NSObject, LocationManagable, CLLocationManagerDelegate{
    
    private let locationManager = CLLocationManager()
    private weak var locationDelegate: LocationManagerDelegate?
    
    func setupLocationManager(locationDelegate: LocationManagerDelegate?) {
        self.locationDelegate = locationDelegate
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            print("long = \(location.coordinate.longitude)", "lat = \(location.coordinate.latitude)")
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            self.locationDelegate?.locationDetermined(lat: latitude, lon: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

