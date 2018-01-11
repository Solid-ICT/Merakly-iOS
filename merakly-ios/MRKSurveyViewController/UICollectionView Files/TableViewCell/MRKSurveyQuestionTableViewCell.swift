//
//  MRKSurveyQuestionTableViewCell.swift
//  merakly-ios
//
//  Created by Fikri Can Cankurtaran on 14/11/2017.
//  Copyright © 2017 Solid-ICT. All rights reserved.
//

import UIKit

class MRKSurveyQuestionTableViewCell: UITableViewCell, Reusable {

    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor(red: 171.0/255.0, green: 173.0/255.0, blue: 215.0/255.0, alpha: 1.0).cgColor
        containerView.layer.cornerRadius = 5.0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        if selected {
            containerView.backgroundColor = UIColor(red: 171.0/255.0, green: 173.0/255.0, blue: 215.0/255.0, alpha: 1.0)
            optionLabel.textColor = .black
        } else {
            containerView.backgroundColor = UIColor(red: 31.0/255.0, green: 31.0/255.0, blue: 31.0/255.0, alpha: 1.0)
            optionLabel.textColor = .white
        }
        

    }
    
}
