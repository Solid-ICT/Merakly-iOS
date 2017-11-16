//
//  MRKApiRouter.swift
//  merakly-ios
//
//  Created by Fikri Can Cankurtaran on 16/11/2017.
//  Copyright © 2017 Solid-ICT. All rights reserved.
//

import Alamofire

enum MRKAPIRouter: URLRequestConvertible {
    
    static let baseUrl = "http://merakly.sickthread.com"
    
    case getRandomAd([String: String])
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .getRandomAd:
                return .get
            }
        }
        
        let params: ([String: Any]?) = {
            switch self {
            case .getRandomAd:
                return nil
            }
        }()
        
        let url: URL = {
            // build up and return the URL for each endpoint
            let relativePath: String?
            let query: String?
            switch self {
            case .getRandomAd(let urlParams):
                let applicationId = urlParams["applicationId"] ?? ""
                let deviceId = urlParams["deviceId"] ?? ""
                let osType = urlParams["osType"] ?? ""
                relativePath = "/campaign/random"
                query = "applicationId=\(applicationId)&deviceId=\(deviceId)&osType=\(osType)"
            }
            
            var urlComponents = URLComponents(string: MRKAPIRouter.baseUrl)!
            if let relativePath = relativePath {
                urlComponents.path = relativePath
            }
            if let query = query {
                urlComponents.query = query
            }
            return urlComponents.url!
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        let encoding: ParameterEncoding
        
        switch self {
        case .getRandomAd:
            encoding = JSONEncoding.default
        }
        
        return try encoding.encode(urlRequest, with: params)
    }
}

class MRKAPIWrapper: NSObject {
    
    class func requestRandomAd(urlParams: [String: String], success:@escaping (MRKCampaign) -> Void, failure:@escaping (Error) -> Void) {
        
        Alamofire.request(MRKAPIRouter.getRandomAd(urlParams)).responseJSON { (responseObject) in
            
            switch responseObject.result {
            case .success(let value):
                guard let json = value as? [String: Any] else { return }
                let responseObject = try! MRKResponse(object: json)
                guard let campaignJson = responseObject.data as? [String: Any] else { return }
                let campaignObject = try! MRKCampaign(object: campaignJson)
                success(campaignObject)
            case .failure(let err):
                failure(err)
            }
            
        }
        
    }
    
}
