//
//  VoteActionExtension.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 1/3/19.
//  Copyright © 2019 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

extension HomeViewController {
    // Actions of HomeViewController when self.builder == .vote
    
    func updateUserPoints(user: UserData, points: Int) {
        user.points = user.points + points
        self.scoreLabel.text = String(user.points) + " pts"
    }
    
    func hideAnswer(){
        self.image1PercentageLabel.alpha = 0.0
        self.image2PercentageLabel.alpha = 0.0
        
        self.image1View.layer.borderColor = self.getTextColor().cgColor
        self.image2View.layer.borderColor = self.getTextColor().cgColor
        
        heartView?.removeFromSuperview()
    }
    
    func showAnswer() -> UIImageView {
        
        var longerImageView: UIImageView!
        
        if Int(self.image1PercentageLabel.text ?? "50") ?? 50 > Int(self.image2PercentageLabel.text ?? "50") ?? 50 {
            longerImageView = self.image1View
        }else{
            longerImageView = self.image2View
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.image1PercentageLabel.alpha = 1.0
            self.image2PercentageLabel.alpha = 1.0
            longerImageView.layer.borderColor = self.getThirdAccentColor().cgColor
        })
        
        return longerImageView
    }
    
    
    func submitVote(completion: @escaping (_ sucess: Bool) -> Void){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            // Put your code which should be executed with a delay here
            completion(true)
        })
    }
    
    
    
    func evaluateAnswer(correctness: Bool) -> Int {
        
        var currentStatus: GameStatus!
        
        if (pastGameStatus != nil) {
            if pastGameStatus == .win && correctness == true {
                currentStatus = .consecutiveWin
            }else if pastGameStatus == .lose && correctness == false {
                currentStatus = .consecutiveLose
            }else if (pastGameStatus == .win || pastGameStatus == .consecutiveWin) && correctness == false {
                currentStatus = .lose
            }else{
                currentStatus = .win
            }
        }else{
            if correctness == true {
                currentStatus = .win
            }else {
                currentStatus = .lose
            }
        }
        
        self.commentaryMessageLabel.text = currentStatus.commentary
        pastGameStatus = currentStatus
        
        return currentStatus.pointsEarned
    }
    
    func getPercentageFormat(percent: Int?) -> String {
        return "( " + String(percent ?? 50) + "% )"
    }
    
    func enableVoting(){
        prepareNext()
        dequeuePost()
    }
    
    func dequeuePost(){
        //dequeue from queue
        //set value with new peak()
        
        if let postToBeVoted = self.queue.dequeue() {
            self.image1PercentageLabel.text = getPercentageFormat(percent: postToBeVoted.image1Percentage)
            self.image2PercentageLabel.text = getPercentageFormat(percent: postToBeVoted.image2Percentage)
            
            self.image1View.image = postToBeVoted.img1 ?? UIImage()
            self.image2View.image = postToBeVoted.img2 ?? UIImage()
        }else{
            print("notrhing to vote")
        }
        
        prepareNext()
        //set values with this
    }
    
    func prepareNext(){
        
        if let nextPost = self.queue.peek() {
            self.network.downloadImage(stringUrl: nextPost.image1Url) { (img) in
                nextPost.img1 = img
            }
            self.network.downloadImage(stringUrl: nextPost.image2Url) { (img) in
                nextPost.img2 = img
            }
        }
        
    }
    
    func placeHeartViewOnImageView(imgView: UIImageView) {
        
        heartView = UIImageView()
        guard let heartView = heartView else { return }
        heartView.image = UIImage()
        heartView.backgroundColor = .white
        heartView.translatesAutoresizingMaskIntoConstraints = false
        imgView.addSubview(heartView)
        heartView.centerXAnchor.constraint(equalTo: imgView.centerXAnchor).isActive = true
        heartView.centerYAnchor.constraint(equalTo: imgView.centerYAnchor).isActive = true
        heartView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        heartView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func switchInteractionOfImageViews(enabled: Bool) {
        
        if enabled {
            self.image1View.isUserInteractionEnabled = true
            self.image2View.isUserInteractionEnabled = true
        }else{
            self.image1View.isUserInteractionEnabled = false
            self.image2View.isUserInteractionEnabled = false
        }
    }
    
    func voteExecute(imgView: UIImageView){
        
        guard let user = self.network.user else { return }
        
        self.switchInteractionOfImageViews(enabled: false)
        self.placeHeartViewOnImageView(imgView: imgView)
        let correctAns = self.showAnswer()
        let points = self.evaluateAnswer(correctness: correctAns == imgView ? true : false)
        self.updateUserPoints(user: user, points: points)
        
        self.submitVote { (success) in
            self.hideAnswer()
            self.dequeuePost()
            self.switchInteractionOfImageViews(enabled: true)
        }
    }
    
    @objc func toProfile(){
        if let navigator = self.navigationController {
            navigator.pushViewController(ProfileViewController(theme: self.theme, network: self.network), animated: true)
        }
    }
    
    @objc func mainButtonPressed(sender: UIButton){
        
        let customAlert = VoteAlertViewController(type: .post, theme: self.theme, color: self.getMainAccentColor())
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self
        self.present(customAlert, animated: true, completion: nil)
        
    }
    
    
    @objc func firstImageVoted() {
        self.voteExecute(imgView: self.image1View)
    }
    
    @objc func secondImageVoted() {
        self.voteExecute(imgView: self.image2View)
    }
    
    
}
