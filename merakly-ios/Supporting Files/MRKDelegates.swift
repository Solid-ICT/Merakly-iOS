
//
//  File.swift
//  merakly-ios
//
//  Created by Fikri Can Cankurtaran on 23/11/2017.
//  Copyright © 2017 Solid-ICT. All rights reserved.
//

@objc public protocol MeraklyDelegate {
    
    @objc optional func noCampaignToLoad() //Fires when there is no campaign to show
    @objc optional func campaignLoaded() //Fires when a campaign loaded and showed to use
    @objc optional func campaignSkipped()
    @objc optional func adLoaded()
    @objc optional func surveyStarted()
    @objc optional func surveyCanceled()
    @objc optional func surveyEnded()
    
}
