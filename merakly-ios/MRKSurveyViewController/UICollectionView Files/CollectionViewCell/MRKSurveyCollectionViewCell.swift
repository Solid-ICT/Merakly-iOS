//
//  MRKSurveyCollectionViewCell.swift
//  merakly-ios
//
//  Created by Fikri Can Cankurtaran on 14/11/2017.
//  Copyright © 2017 Solid-ICT. All rights reserved.
//

import UIKit

protocol MRKSurveyCollectionViewCellDelegate: class {
    func surveyOptionClicked(withSurveyOption surveyOption:MRKSurveyOption)
    func surveyEndend()
}

class MRKSurveyCollectionViewCell: UICollectionViewCell, Reusable, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var optionsTableView: UITableView!
    
    var questions: [MRKSurveyQuestion]!
    var index: Int!
    
    weak var delegate: MRKSurveyCollectionViewCellDelegate?
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let collectionView = self.superview as? UICollectionView else { return }
        let nextIndex = index + 1
        if nextIndex < collectionView.numberOfItems(inSection: 0) {
            let nextIndexPath = IndexPath(item: index + 1, section: 0)
            collectionView.scrollToItem(at: nextIndexPath, at: .right, animated: true)
        }else {
            //Last question answered, show full page ad
            delegate?.surveyEndend()
        }

        
        let selectedSurveyOption = questions[index].options[indexPath.row]
        delegate?.surveyOptionClicked(withSurveyOption: selectedSurveyOption)
        
    }

}
