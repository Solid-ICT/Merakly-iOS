//
//  MRKFullPageAdView.swift
//  merakly-ios
//
//  Created by Fikri Can Cankurtaran on 20/11/2017.
//  Copyright © 2017 Solid-ICT. All rights reserved.
//

import UIKit

class MRKFullPageAdView: UIView {

    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var banner: MRKBanner! {
        didSet {
            addImageView.sd_setImage(with: banner.imageUrl) { (_, _, _, _) in
                self.activityIndicator.stopAnimating()
            }
        }
    }
    var campaignId: Int!
    var surveyId: Int!
    
    @IBAction func adButtonTapped(_ sender: Any) {
        
        guard let url = banner.targetUrl else { return }
        postFullPageBannerClickEvent(bannerId: banner.bannerId, surveyId: surveyId, campaignId: campaignId)
        UIApplication.shared.openURL(url)
        self.removeFromSuperview()
        
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
        bundle.loadNibNamed("MRKFullPageAdView", owner: self, options: nil)
        contentView.frame = bounds
        self.addSubview(contentView)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }
    
    func postFullPageBannerClickEvent(bannerId: Int, surveyId: Int, campaignId: Int) {
        
        let params = ["campaignId": campaignId, "surveyId": surveyId, "bannerId": bannerId]
        
        MRKAPIWrapper.postFullPageBannerClickEvent(params: params, success: { (response) in
 
        }) { (err, statusCode) in
            print(err)
            print("STATUS CODE: \(String(describing: statusCode))")
        }
        
        
        
    }
    
}
