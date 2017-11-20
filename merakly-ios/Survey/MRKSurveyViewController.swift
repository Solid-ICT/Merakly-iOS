//
//  MRKSurveyViewController.swift
//  merakly-ios
//
//  Created by Fikri Can Cankurtaran on 14/11/2017.
//  Copyright © 2017 Solid-ICT. All rights reserved.
//

import UIKit

class MRKSurveyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MRKSurveyCollectionViewCellDelegate {
    
    @IBOutlet var surveyCollectionView: UICollectionView!
    
    var survey: MRKSurvey!
    var campaignId: Int!
    var campaignOptionId: Int!
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        surveyCollectionView.register(cellType: MRKSurveyCollectionViewCell.self)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return survey.questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MRKSurveyCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath, cellType: MRKSurveyCollectionViewCell.self)
        cell.delegate = self
        cell.questions = survey.questions
        cell.index = indexPath.item
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height
        let width = collectionView.frame.size.width
        return CGSize(width:width , height: height)
    }
    
    //MARK: MRKSurveyCollectionViewCellDelegate
    
    func surveyOptionClicked(withSurveyOption surveyOption: MRKSurveyOption) {
        
        postSurveyOptionClickEvent(surveyOptionId: surveyOption.surveyOptionId, campaignId: campaignId, campaignOptionId: campaignOptionId)
        
    }
    
    //MARK: API calls
    
    func postSurveyOptionClickEvent(surveyOptionId: Int, campaignId: Int, campaignOptionId: Int) {
        
        let params: [String: Any] = ["campaignId": campaignId, "campaignOptionId": campaignOptionId, "surveyOptionId": surveyOptionId]
        
        MRKAPIWrapper.sendSurveyOptionClickEvent(params: params, success: { (response) in
            
      
        }) { (err, statusCode) in
            print(err)
            print("STATUS CODE: \(String(describing: statusCode))")
        }
        
    }

}
