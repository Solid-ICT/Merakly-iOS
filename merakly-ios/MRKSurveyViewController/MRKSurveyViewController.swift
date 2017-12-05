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
    @IBOutlet weak var fullPageAdContainerView: UIView!
    @IBOutlet weak var surveyContainerView: UIView!
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var survey: MRKSurvey!
    var campaignId: Int!
    var campaignOptionId: Int!
    weak var delegate: MeraklyDelegate?
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        delegate?.surveyCanceled?()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        surveyCollectionView.register(cellType: MRKSurveyCollectionViewCell.self)
        
        delegate?.surveyStarted?()
        
        pageControl.numberOfPages = survey.questions.count
        
    }
    
    //MARK: MRKSurveyCollectionViewCellDelegate
    
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.item
    }
    
    //MARK: Helper Functions
    
    func surveyOptionClicked(withSurveyOption surveyOption: MRKSurveyOption) {
        
        postSurveyOptionClickEvent(surveyOptionId: surveyOption.surveyOptionId, campaignId: campaignId, campaignOptionId: campaignOptionId)
        
    }
    
    func surveyEndend() {
        delegate?.surveyEnded?()
        
        if let banner = self.survey.banner {
            let fullPageAdView = MRKFullPageAdView(frame: CGRect(x: 0, y: 0, width: self.fullPageAdContainerView.frame.size.width, height: self.fullPageAdContainerView.frame.size.height))
            fullPageAdView.banner = banner
            fullPageAdView.campaignId = self.campaignId
            fullPageAdView.surveyId = self.survey.surveyId
            self.fullPageAdContainerView.insertSubview(fullPageAdView, at: 0)
            self.fullPageAdContainerView.setViewWithAnimation(hidden: false)
            self.surveyContainerView.setViewWithAnimation(hidden: true)
            self.infoContainerView.setViewWithAnimation(hidden: true)
        } else {
            self.infoLabel.text = "Anketimize katılım gösterdiğiniz için teşekkürler!"
            self.fullPageAdContainerView.setViewWithAnimation(hidden: true)
            self.surveyContainerView.setViewWithAnimation(hidden: true)
            self.infoContainerView.setViewWithAnimation(hidden: false)
        }
        
    }
    
    //MARK: API calls
    
    func postSurveyOptionClickEvent(surveyOptionId: Int, campaignId: Int, campaignOptionId: Int) {
        
        let params: [String: Any] = ["campaignId": campaignId, "campaignOptionId": campaignOptionId, "surveyOptionId": surveyOptionId]
        
        MRKAPIWrapper.postSurveyOptionClickEvent(params: params, success: { (response) in
            
      
        }) { (err, statusCode) in
            print(err)
            print("STATUS CODE: \(String(describing: statusCode))")
        }
        
    }

}
