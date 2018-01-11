//
//  MRKModals.swift
//  merakly-ios
//
//  Created by Fikri Can Cankurtaran on 14/11/2017.
//  Copyright © 2017 Solid-ICT. All rights reserved.
//

import Foundation
import Marshal
import AdSupport

struct MRKIdentifier: Marshaling {
    
    var deviceId = ASIdentifierManager.shared().isAdvertisingTrackingEnabled ? ASIdentifierManager.shared().advertisingIdentifier.uuidString : UUID().uuidString
    var version = 1
    var osType = 1
    var osVersion = UIDevice.current.systemVersion
    var locale = NSLocale.preferredLanguages.first?.components(separatedBy: "-").first ?? "tr"
    var apiKey: String
    var secretKey: String
    
    init(apiKey: String, secretKey: String) {
        self.apiKey = apiKey
        self.secretKey = secretKey
    }
    
    func marshaled() -> [String: Any] {
        return {
            ["deviceId" : deviceId,
             "version" : version,
             "osType" : osType,
             "osVersion" : osVersion,
             "locale" : locale,
             "apiKey" : apiKey,
             "secretKey" : secretKey
            ]}()
    }
    
}

public struct MRKUserDetail {
    
    public enum Gender {
        case male
        case female
    }
    
    var age: Int?
    var gender: Gender?
    
    public init(age: Int?, gender: Gender?) {
        if let age = age {
            self.age = age
        }
        if let gender = gender {
            self.gender = gender
        }
    }
    
    public func send() {
        
        let genderInt: Int?
        
        switch self.gender {
        case .male?:
            genderInt = 0
        case .female?:
            genderInt = 1
        case .none:
            genderInt = nil
        }
        
        let params: [String: Any?] = ["age": age, "genderType": genderInt]
        
        MRKAPIWrapper.updateUserDetails(params: params)
        
    }
    
}

struct MRKResponse: Unmarshaling {
    
    var succeed: Bool
    var message: String?
    var data: Any?
  
    init(object: MarshaledObject) throws {
        
        succeed = try object.value(for: "succeed")
        message = try object.value(for: "message")
        data = try? object.any(for: "object")

    }
    
}

struct MRKCampaign: Unmarshaling {
    
    var campaignId: Int
    var question: String
    var options: [MRKCampaignOption]
    
    init(object: MarshaledObject) throws {
        
        campaignId = try object.value(for: "id")
        question = try object.value(for: "question")
        options = try object.value(for: "options", discardingErrors: true)

    }
    
}

struct MRKCampaignOption: Unmarshaling {
    
    var campaignOptionId: Int
    var option: String
    var banner: MRKBanner?
    var survey: MRKSurvey?

    init(object: MarshaledObject) throws {
        
        campaignOptionId = try object.value(for: "id")
        option = try object.value(for: "option")
        banner = try object.value(for: "banner")
        survey = try object.value(for: "survey")

    }
    
}

struct MRKBanner: Unmarshaling {
    
    var bannerId: Int
    var imageUrl: URL
    var targetUrl: URL?
    
    init(object: MarshaledObject) throws {
        
        bannerId = try object.value(for: "id")
        imageUrl = try object.value(for: "imageUrl")
        targetUrl = try? object.value(for: "targetUrl")

    }
    
}

struct MRKSurvey: Unmarshaling {
    
    var surveyId: Int
    var questions: [MRKSurveyQuestion]
    var banner: MRKBanner?
    
    init(object: MarshaledObject) throws {
        
        surveyId = try object.value(for: "id")
        questions = try object.value(for: "questions", discardingErrors: true)
        banner = try object.value(for: "banner")

    }
    
}

struct MRKSurveyQuestion: Unmarshaling {
    
    var surveyQuestionId: Int
    var question: String
    var options: [MRKSurveyOption]
    
    init(object: MarshaledObject) throws {
        
        surveyQuestionId = try object.value(for: "id")
        question = try object.value(for: "question")
        options = try object.value(for: "options", discardingErrors: true)
        
    }
    
}

struct MRKSurveyOption: Unmarshaling {
    
    var surveyOptionId: Int
    var option: String
    
    init(object: MarshaledObject) throws {
        
        surveyOptionId = try object.value(for: "id")
        option = try object.value(for: "option")
        
    }
    
}


