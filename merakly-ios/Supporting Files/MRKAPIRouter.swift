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
    static var identifierBase64: String = "" {
        didSet {
            if oldValue != identifierBase64 {
                identifierBase64DidChangeClosure?()
            }
        }
    }
    
    static var identifierBase64DidChangeClosure: (()->())?

    case getRandomAd([String: String])
    case postCampaignViewEvent([String: Any]) //campaignId(int)
    case postCampaignSkipEvent([String: Any]) //campaignId(int)
    case postCampaignOptionClickEvent([String: Any]) //campaignOptionId(int), replyTime(float)
    case postInlineBannerClickEvent([String: Any]) //campaignOptionId(int), bannerId(int)
    case postSurveyOptionClickEvent([String: Any]) //campaignId(int), campaignOptionId(int), surveyOptionId(int)
    case postFullPageBannerClickEvent([String: Any]) //campaignId(int), surveyId(int), bannerId(int)

    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .getRandomAd:
                return .get
            case .postCampaignViewEvent, .postCampaignSkipEvent, .postCampaignOptionClickEvent, .postInlineBannerClickEvent, .postSurveyOptionClickEvent, .postFullPageBannerClickEvent:
                return .post
            }
        }
        
        let params: ([String: Any]?) = {
            switch self {
            case .getRandomAd:
                return nil
            case .postCampaignViewEvent(let params):
                return params
            case .postCampaignSkipEvent(let params):
                return params
            case .postCampaignOptionClickEvent(let params):
                return params
            case .postInlineBannerClickEvent(let params):
                return params
            case .postSurveyOptionClickEvent(let params):
                return params
            case .postFullPageBannerClickEvent(let params):
                return params
            }
        }()
        
        let url: URL = {
            // build up and return the URL for each endpoint
            let relativePath: String?
            let query: String?
            switch self {
            case .getRandomAd:
                relativePath = "/device/campaign/random"
                query = ""
            case .postCampaignViewEvent:
                relativePath = "/device/action/campaign-view"
                query = ""
            case .postCampaignSkipEvent:
                relativePath = "/device/action/campaign-skip"
                query = ""
            case .postCampaignOptionClickEvent:
                relativePath = "/device/action/campaign-option-click"
                query = ""
            case .postInlineBannerClickEvent:
                relativePath = "/device/action/banner-inline-click"
                query = ""
            case .postSurveyOptionClickEvent:
                relativePath = "/device/action/survey-option-click"
                query = ""
            case .postFullPageBannerClickEvent:
                relativePath = "/device/action/banner-full-page-click"
                query = ""
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
        urlRequest.addValue(MRKAPIRouter.identifierBase64, forHTTPHeaderField: "x-identifier")

        let encoding: ParameterEncoding = JSONEncoding.default
        
        return try encoding.encode(urlRequest, with: params)
    }
}


class MRKAPIWrapper: NSObject {
    
    class func getRandomAd(params: [String: String], success:@escaping (MRKResponse) -> Void, failure:@escaping (Error, Int?) -> Void) {
        
        Alamofire.request(MRKAPIRouter.getRandomAd(params)).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                guard let json = value as? [String: Any] else { return }
                let responseObject = try! MRKResponse(object: json)
                success(responseObject)
            case .failure(let err):
                failure(err, response.response?.statusCode)
            }
            
        }
        
    }
    
    class func postCampaignViewEvent(params: [String: Any], success:@escaping (MRKResponse) -> Void, failure:@escaping (Error, Int?) -> Void) {
        
        Alamofire.request(MRKAPIRouter.postCampaignViewEvent(params)).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                guard let json = value as? [String: Any] else { return }
                let responseObject = try! MRKResponse(object: json)
                success(responseObject)
            case .failure(let err):
                failure(err, response.response?.statusCode)
            }
            
        }
        
    }
    class func postCampaignSkipEvent(params: [String: Any], success:@escaping (MRKResponse) -> Void, failure:@escaping (Error, Int?) -> Void) {
        
        Alamofire.request(MRKAPIRouter.postCampaignSkipEvent(params)).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                guard let json = value as? [String: Any] else { return }
                let responseObject = try! MRKResponse(object: json)
                success(responseObject)
            case .failure(let err):
                failure(err, response.response?.statusCode)
            }
            
        }
        
    }
    
    class func postCampaignOptionClickEvent(params: [String: Any], success:@escaping (MRKResponse) -> Void, failure:@escaping (Error, Int?) -> Void) {
        
        Alamofire.request(MRKAPIRouter.postCampaignOptionClickEvent(params)).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                guard let json = value as? [String: Any] else { return }
                let responseObject = try! MRKResponse(object: json)
                success(responseObject)
            case .failure(let err):
                failure(err, response.response?.statusCode)
            }
            
        }
        
    }
    
    class func postInlineBannerClickEvent(params: [String: Any], success:@escaping (MRKResponse) -> Void, failure:@escaping (Error, Int?) -> Void) {
        
        Alamofire.request(MRKAPIRouter.postInlineBannerClickEvent(params)).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                guard let json = value as? [String: Any] else { return }
                let responseObject = try! MRKResponse(object: json)
                success(responseObject)
            case .failure(let err):
                failure(err, response.response?.statusCode)
            }
            
        }
        
    }
    
    class func postSurveyOptionClickEvent(params: [String: Any], success:@escaping (MRKResponse) -> Void, failure:@escaping (Error, Int?) -> Void) {
        
        Alamofire.request(MRKAPIRouter.postSurveyOptionClickEvent(params)).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                guard let json = value as? [String: Any] else { return }
                let responseObject = try! MRKResponse(object: json)
                success(responseObject)
            case .failure(let err):
                failure(err, response.response?.statusCode)
            }
            
        }
        
    }
    
    class func postFullPageBannerClickEvent(params: [String: Any], success:@escaping (MRKResponse) -> Void, failure:@escaping (Error, Int?) -> Void) {
        
        Alamofire.request(MRKAPIRouter.postFullPageBannerClickEvent(params)).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                guard let json = value as? [String: Any] else { return }
                let responseObject = try! MRKResponse(object: json)
                success(responseObject)
            case .failure(let err):
                failure(err, response.response?.statusCode)
            }
            
        }
        
    }
    
}
