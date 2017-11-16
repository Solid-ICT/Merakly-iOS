//
//  MRKModals.swift
//  merakly-ios
//
//  Created by Fikri Can Cankurtaran on 14/11/2017.
//  Copyright © 2017 Solid-ICT. All rights reserved.
//

import Foundation
import Marshal

struct MRKResponse: Unmarshaling {
    
    var succeed: Bool
    var message: String?
    var data: Any?
  
    init(object: MarshaledObject) throws {
        
        succeed = try object.value(for: "succeed")
        message = try object.value(for: "message")
        data = try object.any(for: "object")

    }
    
}

struct MRKCampaign: Unmarshaling {
    
    var campaignId: Int
    var question: String
    var options: [MRKCampaignOption]
    
    init(object: MarshaledObject) throws {
        
        campaignId = try object.value(for: "id")
        question = try object.value(for: "question")
        options = try object.value(for: "options")

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
        banner = try? object.value(for: "banner")
        survey = try? object.value(for: "survey")
        
    }
    
}

struct MRKBanner: Unmarshaling {
    
    var bannerId: Int
    var imageUrl: URL
    var targetUrl: URL
    
    init(object: MarshaledObject) throws {
        
        bannerId = try object.value(for: "id")
        imageUrl = try object.value(for: "imageUrl")
        targetUrl = try object.value(for: "targetUrl")

    }
    
}

struct MRKSurvey: Unmarshaling {
    
    var surveyId: Int
    var questions: [MRKSurveyQuestion]
    var banner: MRKBanner
    
    init(object: MarshaledObject) throws {
        
        surveyId = try object.value(for: "id")
        questions = try object.value(for: "questions")
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
        options = try object.value(for: "options")
        
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


