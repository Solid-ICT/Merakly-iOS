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
    
    var campaign: MRKCampaign!
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var adContainerView: UIView!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var answersSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var adButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func adButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func segmentedControlValueDidChange(_ sender: Any) {
        
        deciderAfterUserSelection()
        
    }

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
    
    func loadDataToView(campaign: MRKCampaign) {
        
        questionLabel.text = campaign.question
        answersSegmentedControl.removeAllSegments()
        for (index, option) in campaign.options.enumerated() {
            answersSegmentedControl.insertSegment(withTitle: option.option, at: index, animated: false)
        }

        self.activityIndicator.stopAnimating()
        self.containerView.isHidden = false
        
    }
    
    func deciderAfterUserSelection() {
        
        let selectedOption = self.campaign.options[answersSegmentedControl.selectedSegmentIndex]
        
        if let banner = selectedOption.banner {
            //banner gösterilecek
            adImageView.sd_setImage(with: banner.imageUrl, completed: nil)
            containerView.isHidden = true
            adContainerView.isHidden = false
            
        }else if let survey = selectedOption.survey {
            //anket gösterilecek
            
            
        }
        
        
    }
    
    func getBannerServiceMethod() {
        
        Alamofire.request("http://merakly.sickthread.com/campaign/random?applicationId=1&deviceId=Fikri&osType=1", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
                
            case .success(let value):
                
                guard let json = value as? [String: Any] else { return }
                let responseObject = try! MRKResponse(object: json)
                guard let campaignJson = responseObject.data as? [String: Any] else { return }
                let campaignObject = try! MRKCampaign(object: campaignJson)
                self.campaign = campaignObject
                self.loadDataToView(campaign: campaignObject)
                
            case .failure(let err):
                
                print(err)
                self.activityIndicator.stopAnimating()
                
                
            }

        }

    }
    
}
