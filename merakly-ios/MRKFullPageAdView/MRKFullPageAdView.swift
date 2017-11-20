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
    
    var banner: MRKBanner! {
        didSet {
            addImageView.sd_setImage(with: banner.imageUrl, completed: nil)
        }
    }
    
    @IBAction func adButtonTapped(_ sender: Any) {
        UIApplication.shared.openURL(banner.targetUrl)
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
    
}
