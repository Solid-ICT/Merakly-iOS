//
//  MRKBannerView.swift
//  merakly-ios
//
//  Created by Fikri Can Cankurtaran on 10/11/2017.
//  Copyright © 2017 Solid-ICT. All rights reserved.
//

import UIKit

class MRKBannerView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var answersSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var adButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func adButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func segmentedControlValueDidChange(_ sender: Any) {
        
        print(answersSegmentedControl.selectedSegmentIndex)
        
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
                
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        
    }
    
    override func didMoveToSuperview() {
        
    }
    
}
