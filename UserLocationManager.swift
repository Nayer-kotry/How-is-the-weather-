//
//  locationManager.swift
//  How is the weather?
//
//  Created by Nayer Kotry on 06/09/2023.
//

import Foundation
import UIKit
import CoreLocation

protocol LocationProtocol {
    func locationUpdated(with Coordinates: Coordinates?)
}

final class UserLocationManager: NSObject, CLLocationManagerDelegate {
    
  
    //MARK: variables
    
    var locationManager: CLLocationManager?
    private var userLocation: Coordinates? = nil
    var delegate: LocationProtocol?
    
    //MARK: functions
    
    func getUserLocation() -> Coordinates? {
        return userLocation
    }
    
    func checkIfLocationServicesIsEnabled() {
        DispatchQueue.global().async { [weak self] in
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    self?.locationManager = CLLocationManager()
                    self?.locationManager!.delegate = self
                
                }
            } else {
                print("please enable location services")
            }
            
        }
      
    }
    
    func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        switch locationManager.authorizationStatus {
        case .notDetermined:
           
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("location is restricted likely due to parental controls")
        case .denied:
            print("location permission denied, please go to settings to enable it")
        case .authorizedAlways,  .authorizedWhenInUse:
            if let location = locationManager.location {
                let longitude = location.coordinate.longitude.magnitude
                let latitude = location.coordinate.latitude.magnitude
                userLocation = Coordinates(longitude: longitude,latitude: latitude)
                NotificationCenter.default.post(name: NSNotification.Name("DidUpdateLocation"), object: nil, userInfo: ["location": userLocation!])
                delegate?.locationUpdated(with:userLocation)
            }
            break
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
 
}
