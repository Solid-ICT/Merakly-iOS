//
//  MRKSurveyCollectionViewCell.swift
//  merakly-ios
//
//  Created by Fikri Can Cankurtaran on 14/11/2017.
//  Copyright © 2017 Solid-ICT. All rights reserved.
//

import UIKit

class MRKSurveyCollectionViewCell: UICollectionViewCell, Reusable, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var optionsTableView: UITableView!
    
    var questions: [MRKSurveyQuestion]!
    var index: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        

    }
    
    override func layoutSubviews() {
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        optionsTableView.register(cellType: MRKSurveyQuestionTableViewCell.self)
        
        questionLabel.text = questions[index].question

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions[index].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MRKSurveyQuestionTableViewCell = tableView.dequeueReusableCell(for: indexPath, cellType: MRKSurveyQuestionTableViewCell.self)
        let questionOption = questions[index].options[indexPath.row]
        cell.optionLabel.text = questionOption.option
        return cell
        
    }

}
