//
//  Merakly.swift
//  merakly-ios
//
//  Created by Fikri Can Cankurtaran on 22/11/2017.
//  Copyright © 2017 Solid-ICT. All rights reserved.
//

public class Merakly {
    
    private static var locationManager = MRKLocationManager()
    
    public init() {}
    
    static public func configure() {
        
        self.locationManager.fetchWithCompletion { (location, err) in
            print(location?.coordinate)
        }
        
    }
    
    
}
