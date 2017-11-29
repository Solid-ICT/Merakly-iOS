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

@objc public class MRKBannerView: UIView {
    
    //MARK: Variables
    var campaign: MRKCampaign! {
        didSet {
            campaignObjectDidSetClosure?()
        }
    }
    var timer: Timer!
    var totalTime: Float = 0.0
    var campaignObjectDidSetClosure: (()->())?
    var isVisible: Bool = false
    var isLoadCampaignCalled: Bool = false
    
    //MARK: Delegate
    public weak var delegate: MeraklyDelegate?
    
    //MARK: UIView
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var adContainerView: UIView!
    @IBOutlet weak var infoContainerView: UIView!
    
    //MARK: UILabel
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
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
        guard let bannerId = selectedOption.banner?.bannerId else { return }
        postInlineBannerClickEvent(withCampaignOption: selectedOption, bannerId: bannerId)
        if let url = selectedOption.banner?.targetUrl {
            UIApplication.shared.openURL(url)
        } else {
            containerView.setViewWithAnimation(hidden: true)
            infoContainerView.setViewWithAnimation(hidden: false)
            infoLabel.text = "Cevap verdiğiniz için teşekkürler."
        }
        
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        
        if campaign != nil {
            postCampaignSkipEvent()
        }
        delegate?.campaignSkipped?()
        
        if isLoadCampaignCalled {
            getRandomCampaign()
        }
        
    }
    
    @IBAction func segmentedControlValueDidChange(_ sender: Any) {
        
        timer.invalidate()
        let selectedOption = self.campaign.options[answersSegmentedControl.selectedSegmentIndex]
        postCampaignOptionClickEvent(withCampaignOption: selectedOption)
        deciderAfterUserSelection(withCampaignOption: selectedOption)
        
    }

    //MARK: Init functions
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        
        let bundle = Bundle(for: MRKBannerView.self)
        bundle.loadNibNamed("MRKBannerView", owner: self, options: nil)
        contentView.frame = bounds
        self.addSubview(contentView)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }

}

//MARK: UIView Delegates

public extension MRKBannerView {
    
    override public func didMoveToWindow() {
        
    }
    
    override public func willMove(toWindow newWindow: UIWindow?) {
        
        if newWindow == nil {
            //View visible değil

        } else {
            //View is visible

//            if campaign != nil {
//                self.loadCampaign()
//            }

        }
        
    }
    
}

public extension MRKBannerView {
    
    public func loadCampaign() {
        
        activityIndicator.startAnimating()
        isLoadCampaignCalled = true
        loadDataToView()
        
    }
 
}

//MARK: Helper functions

private extension MRKBannerView {
    
    func loadDataToView() {
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)

        if MRKAPIRouter.identifierBase64.count > 0 {
            self.getRandomCampaign()
        }else {
            MRKAPIRouter.identifierBase64DidChangeClosure = {
                self.getRandomCampaign()
            }
        }
        
        campaignObjectDidSetClosure = {
            
            self.questionLabel.text = self.campaign.question
            self.answersSegmentedControl.removeAllSegments()
            for (index, option) in self.campaign.options.enumerated() {
                self.answersSegmentedControl.insertSegment(withTitle: option.option, at: index, animated: false)
            }
            
            self.activityIndicator.stopAnimating()
            self.containerView.setViewWithAnimation(hidden: false)
            
            self.delegate?.campaignLoaded?()
            
            self.postCampaignViewEvent()
            
        }
        
    }
    
    func deciderAfterUserSelection(withCampaignOption selectedOption: MRKCampaignOption) {
        
        if let banner = selectedOption.banner {
            //banner gösterilecek
            adImageView.sd_setImage(with: banner.imageUrl, completed: { (_, _, _, _) in
                self.delegate?.adLoaded?()
            })
            
            containerView.setViewWithAnimation(hidden: true)
            adContainerView.setViewWithAnimation(hidden: false)
            
        }else if let survey = selectedOption.survey {
            //anket gösterilecek
            let bundle = Bundle(for: MRKBannerView.self)
            let surveyVC = MRKSurveyViewController(nibName: "MRKSurveyViewController", bundle: bundle)
            surveyVC.survey = survey
            surveyVC.campaignId = self.campaign.campaignId
            surveyVC.campaignOptionId = selectedOption.campaignOptionId
            surveyVC.delegate = delegate
            self.window?.rootViewController?.present(surveyVC, animated: true, completion: nil)
        }else {
            noAdToShow(withMessage: "Cevap verdiğiniz için teşekkürler.")
        }
        
    }
    
    func noCampaignToShow(withMessage message: String) {
        
        containerView.setViewWithAnimation(hidden: true)
        adContainerView.setViewWithAnimation(hidden: true)
        infoContainerView.setViewWithAnimation(hidden: false)
        
        infoLabel.text = message
        
        delegate?.noCampaignToLoad?()
        
    }
    
    func noAdToShow(withMessage message: String) {
        
        containerView.setViewWithAnimation(hidden: true)
        adContainerView.setViewWithAnimation(hidden: true)
        infoContainerView.setViewWithAnimation(hidden: false)
        
        infoLabel.text = message
        
    }
    
    @objc func updateCounter() {
        totalTime = totalTime + 0.1
    }
    
}

//MARK: API calls

private extension MRKBannerView {
    
    func getRandomCampaign() {
        
        print("getRandomCampaign CALLED")
        MRKAPIWrapper.getRandomAd(params: [:], success: { (response) in
            
            if response.succeed {
                guard let campaignJson = response.data as? [String: Any] else { return }
                let campaign = try! MRKCampaign(object: campaignJson)
                self.campaign = campaign
            } else { //no campaign to show
                self.noCampaignToShow(withMessage: response.message ?? "Şu anda siz uygun bir kampanya bulunmamaktadır.")
            }
            
        }) {(err, statusCode) in
            print(err.localizedDescription)
            print("getRandomCampaign HTTP Response Code: \(String(describing: statusCode))")
        }
        
    }
    
    func postCampaignViewEvent() {
        
        let params: [String : Any] = ["campaignId": campaign.campaignId]
        
        MRKAPIWrapper.postCampaignViewEvent(params: params, success: { (response) in
            
        }) { (err, statusCode) in
            print(err.localizedDescription)
            print("postCampaignViewEvent HTTP Response Code: \(String(describing: statusCode))")
        }
        
    }
    
    func postCampaignSkipEvent() {
        
        let params: [String : Any] = ["campaignId": campaign.campaignId]
        
        MRKAPIWrapper.postCampaignSkipEvent(params: params, success: { (response) in
            
        }) { (err, statusCode) in
            print(err.localizedDescription)
            print("postCampaignSkipEvent HTTP Response Code: \(String(describing: statusCode))")
        }
        
    }
    
    func postCampaignOptionClickEvent(withCampaignOption clickedOption: MRKCampaignOption) {
        
        let params: [String : Any] = ["campaignOptionId": clickedOption.campaignOptionId, "replyTime": totalTime]
        
        MRKAPIWrapper.postCampaignOptionClickEvent(params: params, success: { (response) in
            
        }) { (err, statusCode) in
            print(err.localizedDescription)
            print("postCampaignOptionClickEvent HTTP Response Code: \(String(describing: statusCode))")
        }
        
    }
    
    func postInlineBannerClickEvent(withCampaignOption clickedOption: MRKCampaignOption, bannerId: Int) {
        
        let params: [String: Any] = ["campaignOptionId": clickedOption.campaignOptionId, "bannerId": bannerId]
        
        MRKAPIWrapper.postInlineBannerClickEvent(params: params, success: { (response) in
            
        }) { (err, statusCode) in
            print(err.localizedDescription)
            print("postInlineBannerClickEvent HTTP Response Code: \(String(describing: statusCode))")
        }
        
        
    }
    
}



