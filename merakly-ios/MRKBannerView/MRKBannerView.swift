//
//  MRKBannerView.swift
//  merakly-ios
//
//  Created by Fikri Can Cankurtaran on 10/11/2017.
//  Copyright © 2017 Solid-ICT. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class MRKBannerView: UIView {
    
    //MARK: Variables
    var campaign: MRKCampaign!
    var timer: Timer!
    var totalTime: Float = 0.0
    
    //MARK: UIView
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var adContainerView: UIView!
    
    //MARK: UILabel
    @IBOutlet weak var questionLabel: UILabel!
    
    //MARK: UISegmentedControl
    @IBOutlet weak var answersSegmentedControl: UISegmentedControl!
    
    //MARK: UIImageView
    @IBOutlet weak var adImageView: UIImageView!
    
    //MARK: UIButton
    @IBOutlet weak var adButton: UIButton!
    
    //MARK: UIActivityIndicator
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: IBAction
    @IBAction func adButtonTapped(_ sender: Any) {
        
        let selectedOption = self.campaign.options[answersSegmentedControl.selectedSegmentIndex]
        guard let url = selectedOption.banner?.targetUrl else { return }
        UIApplication.shared.openURL(url)
        
    }
    
    @IBAction func segmentedControlValueDidChange(_ sender: Any) {
        
        timer.invalidate()
        let selectedOption = self.campaign.options[answersSegmentedControl.selectedSegmentIndex]
        postCampaignOptionClickEvent(withCampaignOption: selectedOption)
        deciderAfterUserSelection(withCampaignOption: selectedOption)
        
    }

    //MARK: Init functions
    override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        
        let bundle = Bundle(for: MRKBannerView.self)
        bundle.loadNibNamed("MRKBannerView", owner: self, options: nil)
        contentView.frame = bounds
        self.addSubview(contentView)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        getBannerServiceMethod()
                
    }
    
    //MARK: didMoveToWindow

    override func didMoveToWindow() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }

    
    //MARK: Helper functions
    
    func loadDataToView(campaign: MRKCampaign) {
        
        questionLabel.text = campaign.question
        answersSegmentedControl.removeAllSegments()
        for (index, option) in campaign.options.enumerated() {
            answersSegmentedControl.insertSegment(withTitle: option.option, at: index, animated: false)
        }

        self.activityIndicator.stopAnimating()
        self.containerView.isHidden = false
        
    }
    
    func deciderAfterUserSelection(withCampaignOption selectedOption: MRKCampaignOption) {
        
        if let banner = selectedOption.banner {
            //banner gösterilecek
            adImageView.sd_setImage(with: banner.imageUrl, completed: nil)
            containerView.isHidden = true
            adContainerView.isHidden = false
            
        }else if let survey = selectedOption.survey {
            //anket gösterilecek
            let bundle = Bundle(for: MRKBannerView.self)
            let surveyVC = MRKSurveyViewController(nibName: "MRKSurveyViewController", bundle: bundle)
            surveyVC.survey = survey
            surveyVC.campaignId = self.campaign.campaignId
            surveyVC.campaignOptionId = selectedOption.campaignOptionId
            self.window?.rootViewController?.present(surveyVC, animated: true, completion: nil)
            
        }
        
    }
    
    @objc func updateCounter() {
        totalTime = totalTime + 0.1
    }
    
    //MARK: API calls
    
    func getBannerServiceMethod() {
        
        let params = ["applicationId": "1", "deviceId": "123", "osType": "1"]
        
        MRKAPIWrapper.requestRandomAd(params: params, success: { (campaign) in
            
            self.campaign = campaign
            self.loadDataToView(campaign: campaign)
            
        }) {(err, statusCode) in
            print(err.localizedDescription)
            print("HTTP Response Code: \(String(describing: statusCode))")
        }

    }
    
    func postCampaignOptionClickEvent(withCampaignOption clickedOption: MRKCampaignOption) {
        
        let params: [String : Any] = ["campaignOptionId": clickedOption.campaignOptionId, "replyTime": totalTime]
        
        MRKAPIWrapper.sendCampaignOptionClickEvent(params: params, success: { (response) in
            
        }) { (err, statusCode) in
            print(err.localizedDescription)
            print("HTTP Response Code: \(String(describing: statusCode))")
        }
        
        
    }
    
}
