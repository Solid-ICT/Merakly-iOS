//
//  Merakly.swift
//  merakly-ios
//
//  Created by Fikri Can Cankurtaran on 22/11/2017.
//  Copyright © 2017 Solid-ICT. All rights reserved.
//

@objc public class Merakly: NSObject {
    
    private static var locationManager = MRKLocationManager()

    public override init() {}
    
    @objc static public func configure(withApiKey apiKey: String, andAppSecret appSecret:String) {
        
        var identifier: MRKIdentifier!
        
        self.locationManager.fetchWithCompletion { (location, err) in
            
            guard let latitude = location?.coordinate.latitude else { return }
            guard let longitude = location?.coordinate.longitude else { return }

            identifier = MRKIdentifier(apiKey: apiKey, secretKey: appSecret, latitude: latitude, longitude: longitude)
            
            do {
                let identifierData = try JSONSerialization.data(withJSONObject: identifier.marshaled(), options: JSONSerialization.WritingOptions.prettyPrinted)
                let identifierBase64 = identifierData.base64EncodedString()
                MRKAPIRouter.identifierBase64 = identifierBase64
            } catch {
                print("Could not create JSON from identifier")
            }
            
        }
        
    }
 
}
