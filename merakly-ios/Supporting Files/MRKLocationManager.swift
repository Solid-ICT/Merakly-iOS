//
//  MRKLocationManager.swift
//  merakly-ios
//
//  Created by Fikri Can Cankurtaran on 21/11/2017.
//  Copyright © 2017 Solid-ICT. All rights reserved.
//

import UIKit
import CoreLocation

//possible errors
enum MRKLocationManagerErrors: Int {
    case AuthorizationDenied
    case AuthorizationNotDetermined
    case InvalidLocation
}

@objc public class MRKLocationManager: NSObject, CLLocationManagerDelegate {
    
    //location manager
    var locationManager: CLLocationManager = CLLocationManager()
    
    //destroy the manager
    
    typealias LocationClosure = ((_ location: CLLocation?, _ error: Error?)->())
    var didComplete: LocationClosure?
    
    //location manager returned, call didcomplete closure
    @objc public func _didComplete(location: CLLocation?, error: Error?) {
        locationManager.stopUpdatingLocation()
        didComplete?(location, error)
        locationManager.delegate = nil
    }
    
    //location authorization status changed
    
    @objc public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            self.locationManager.requestLocation()
        case .denied:
            _didComplete(location: nil, error: NSError(domain: self.classForCoder.description(),
                                                       code: MRKLocationManagerErrors.AuthorizationDenied.rawValue,
                                                       userInfo: nil))
        default:
            break
        }
    }
    
    @objc public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _didComplete(location: nil, error: error)
    }
    
    @objc public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            _didComplete(location: location, error: nil)
        }
    }
    
    //ask for location permissions, fetch 1 location, and return
    func fetchWithCompletion(completion: @escaping LocationClosure) {
        //store the completion closure
        didComplete = completion
        
        //fire the location manager
        locationManager.delegate = self
        
        //check for description key and ask permissions
        if (Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") != nil) {
            locationManager.requestWhenInUseAuthorization()
        } else if (Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") != nil) {
            locationManager.requestAlwaysAuthorization()
        } else {
            fatalError("To use location in iOS8 you need to define either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription in the app bundle's Info.plist file")
        }
        
    }
}
