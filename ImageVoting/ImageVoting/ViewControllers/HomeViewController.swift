//
//  ViewController.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/15/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import SCLAlertView
import ContactsUI
import MessageUI


class HomeViewController: UIViewController, ModalController, Stylable {
    
    
    var theme: ColorTheme
    var network: GlobalNetwork
    var builder: HomeViewControllerBuilder
    
    var queue: Queue<ComparisonRecord>!
    
    var imagePicker: UIImagePickerController!
    var uploadOrderIsFirst: Bool!
    
    var circleBackground: UIView!
    
    var closeButton: UIButton!
    var profileButton: UIButton!
    var messageLabel: UILabel!
    var image1View: CircleImageView!
    var image2View: CircleImageView!
    var heartView: UIImageView!
    var vsCircleView: CircleView!
    var image1PercentageLabel: UILabel!
    var image2PercentageLabel: UILabel!
    var commentaryMessageLabel: UILabel!
    var uploadInstructionLabel: UILabel!
    var resultsButton: ResultsButton!
    var postMessageLabel: UILabel!
    var postButton: PostButton!
    
    var pastGameStatus: GameStatus?
    enum GameStatus {
        
        case win
        case lose
        case consecutiveLose
        case consecutiveWin
        
        var commentary: String {
            let randNum = Int.random(in: 0 ..< 4)
            switch  self {
            case .win:
                let strings = ["Good Job! You won 1 pts.", "Correct! You got 1 pts.", "Awesome! You earned 1 pts.", "Great! You won 1 pts."]
                return strings[randNum]
            case .lose:
                let strings = ["Damn.. You guessed wrong.. 0 pts.", "Nope! 0 pts.", "Unlucky! You got 0 pts", "Close! 0 pts"]
                return strings[randNum]
            case .consecutiveLose:
                let strings = ["Unfortunate! Wrong again.. 0 pts", "Not correct! 0 pts.", "Wrong again! 0 pts.", "Try again! 0 pts"]
                return strings[randNum]
            case .consecutiveWin:
                let strings = ["Great! You're right again! 2 pts", "Wow! Amazing! 2 pts", "Holy sh*t! You're on fire! 2 pts", "Awesome again! 2 pts"]
                return strings[randNum]
            }
        }
        
    }
    
    var preFilledImage1: UIImage?
    var preFilledImage2: UIImage?
    
    init(builder: HomeViewControllerBuilder, network: GlobalNetwork, preFilledImage1: UIImage? = nil, preFilledImage2: UIImage? = nil){
        self.builder = builder
        self.network = network
        self.theme = network.appTheme
        self.preFilledImage1 = preFilledImage1
        self.preFilledImage2 = preFilledImage2
        
        super.init(nibName: nil, bundle: nil)
        
        if self.builder == .vote {
            queue = Queue()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.configure()
        self.createView()
        self.constrain()
        self.initializeValue()
        self.setAction()
        
        if self.builder == .vote {
            self.hideAnswer()
        }
        
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func initializeValue(){
        
        if self.builder == .vote {
            profileButton.setImage(UIImage(named: "profileImage")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
            messageLabel.text = "Tap on the best image to earn points"
            image1View.image = UIImage(named: "sample1")
            image2View.image = UIImage(named: "sample2")
            image1PercentageLabel.text = "( 48% )"
            image2PercentageLabel.text = "( 52 % )"
            commentaryMessageLabel.text = "Very close! 0 pts"
            postMessageLabel.text = "Post yours to find your best image"
            
        }else{
            messageLabel.text = "Post Your Own"
            commentaryMessageLabel.text = "Find out the best image for you"
            uploadInstructionLabel.text = "Tap on images below to upload your photo"
            
            postMessageLabel.text = "Are you ready to submit?"
            
            image1View.image = preFilledImage1 != nil ? self.preFilledImage1! : UIImage(named: "addImageBackground")
            image2View.image = preFilledImage2 != nil ? self.preFilledImage2! : UIImage(named: "addImageBackground")
            
            
            imagePicker = UIImagePickerController()
        }
        
    }
    
    
    func setAction(){
        var firstImagePicked: UITapGestureRecognizer!
        var secondImagePicked: UITapGestureRecognizer!
        
        if self.builder == .vote {
            
            firstImagePicked = UITapGestureRecognizer(target: self, action: #selector(self.firstImageVoted))
            secondImagePicked = UITapGestureRecognizer(target: self, action: #selector(self.secondImageVoted))
            
            profileButton.addTarget(self, action: #selector(self.toProfile), for: .touchUpInside)
            resultsButton.addTarget(self, action: #selector(self.resultsButtonPressed), for: .touchUpInside)
            postButton.addTarget(self, action: #selector(self.mainButtonPressed), for: .touchUpInside)
        }else{
            firstImagePicked = UITapGestureRecognizer(target: self, action: #selector(self.firstImagePressed))
            secondImagePicked = UITapGestureRecognizer(target: self, action: #selector(self.secondImagePressed))
            
            
            postButton.addTarget(self, action: #selector(self.uploadButtonPressed), for: .touchUpInside)
        }
        
        image1View.isUserInteractionEnabled = true
        image1View.addGestureRecognizer(firstImagePicked)
        image2View.isUserInteractionEnabled = true
        image2View.addGestureRecognizer(secondImagePicked)
        
    }
    
    func createView(){
        
        let radiusOfLargeCircle = self.view.bounds.height * 0.75
        let radiusOfMediumCircle = self.view.bounds.width * 0.04
        let radiusOfSmallCircle = self.view.bounds.width * 0.09
        
        self.view.backgroundColor = self.getMainBackgroundColor()
        
        circleBackground = UIView()
        circleBackground.translatesAutoresizingMaskIntoConstraints = false
        circleBackground.backgroundColor = self.getSecondaryBackgroundColor()
        circleBackground.layer.cornerRadius = radiusOfLargeCircle
        
        messageLabel = UILabel()
        messageLabel.font = self.builder == .vote ? self.getNormalFont() : self.getTitleFont()
        messageLabel.textColor = self.getTextColor()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.textAlignment = .center
        
        image1View = CircleImageView()
        image1View.makeCircle(radius: radiusOfMediumCircle)
        image1View.clipsToBounds = true
        image1View.contentMode = .scaleAspectFill
        image1View.translatesAutoresizingMaskIntoConstraints = false
        image1View.layer.borderWidth = 3
        image1View.layer.borderColor = self.builder == .vote ? self.getTextColor().cgColor : self.getThirdAccentColor().cgColor
        
        
        image2View = CircleImageView()
        image2View.makeCircle(radius: radiusOfMediumCircle)
        image2View.clipsToBounds = true
        image2View.contentMode = .scaleAspectFill
        image2View.translatesAutoresizingMaskIntoConstraints = false
        image2View.layer.borderWidth = 3
        image2View.layer.borderColor = self.builder == .vote ? self.getTextColor().cgColor : self.getThirdAccentColor().cgColor
        
        vsCircleView = CircleView(title: "VS", theme: self.theme)
        vsCircleView.makeCircle(radius: radiusOfSmallCircle)
        vsCircleView.backgroundColor = self.getMainBackgroundColor()
        vsCircleView.translatesAutoresizingMaskIntoConstraints = false
        vsCircleView.layer.borderColor = self.getSecondaryAccentColor().cgColor
        vsCircleView.layer.borderWidth = 3
        
        
        
        
        commentaryMessageLabel = UILabel()
        commentaryMessageLabel.font = self.builder == .vote ? self.getSmallText() : self.getNormalFont()
        commentaryMessageLabel.textColor = self.getTextColor()
        commentaryMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        commentaryMessageLabel.adjustsFontSizeToFitWidth = true
        commentaryMessageLabel.textAlignment = .center
        
        
        
        
        postMessageLabel = UILabel()
        postMessageLabel.font = self.getNormalFont()
        postMessageLabel.textColor = self.getTextColor()
        postMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        postMessageLabel.adjustsFontSizeToFitWidth = true
        postMessageLabel.textAlignment = .center
        
        postButton = PostButton(title: "POST", theme: self.theme)
        
        if self.builder == .vote {
            profileButton = UIButton()
            profileButton.translatesAutoresizingMaskIntoConstraints = false
            profileButton.backgroundColor = .clear
            profileButton.imageView?.tintColor = self.getTextColor()
            
            image1PercentageLabel = UILabel()
            image1PercentageLabel.font = self.getSmallText()
            image1PercentageLabel.textColor = self.getTextColor()
            image1PercentageLabel.translatesAutoresizingMaskIntoConstraints = false
            image1PercentageLabel.adjustsFontSizeToFitWidth = true
            image1PercentageLabel.textAlignment = .center
            
            image2PercentageLabel = UILabel()
            image2PercentageLabel.font = self.getSmallText()
            image2PercentageLabel.textColor = self.getTextColor()
            image2PercentageLabel.translatesAutoresizingMaskIntoConstraints = false
            image2PercentageLabel.adjustsFontSizeToFitWidth = true
            image2PercentageLabel.textAlignment = .center
            
            resultsButton = ResultsButton(title: "See Your Results", theme: self.theme)
            
            
        }else{
            
            uploadInstructionLabel = UILabel()
            uploadInstructionLabel.font = self.getNormalFont()
            uploadInstructionLabel.textColor = self.getTextColor()
            uploadInstructionLabel.translatesAutoresizingMaskIntoConstraints = false
            uploadInstructionLabel.adjustsFontSizeToFitWidth = true
            uploadInstructionLabel.textAlignment = .center
        }
        
        
        self.view.addSubview(circleBackground)
        self.view.addSubview(messageLabel)
        self.view.addSubview(image1View)
        self.view.addSubview(image2View)
        self.view.addSubview(vsCircleView)
        self.view.addSubview(commentaryMessageLabel)
        self.view.addSubview(postMessageLabel)
        self.view.addSubview(postButton)
        
        if self.builder == .vote {
            self.view.addSubview(profileButton)
            self.view.addSubview(image1PercentageLabel)
            self.view.addSubview(image2PercentageLabel)
            self.view.addSubview(resultsButton)
        }else{
            self.view.addSubview(uploadInstructionLabel)
            self.configureCloseButton(selector: #selector(self.closeView))
        }
        
    }
    
    func constrain(){
        
        if self.builder == .vote {
            circleBackground.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            circleBackground.centerYAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            circleBackground.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1.5).isActive = true
            circleBackground.widthAnchor.constraint(equalTo: circleBackground.heightAnchor).isActive = true
            
            profileButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
            profileButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
            profileButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
            profileButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            image1View.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -40).isActive = true
            image1View.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
            image1View.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -20).isActive = true
            //image1View.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.36).isActive = true
            image1View.heightAnchor.constraint(equalTo: image1View.widthAnchor).isActive = true
            
            image2View.bottomAnchor.constraint(equalTo: image1View.bottomAnchor).isActive = true
            image2View.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
            image2View.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 20).isActive = true
            image2View.heightAnchor.constraint(equalTo: image2View.widthAnchor).isActive = true
            
            messageLabel.bottomAnchor.constraint(equalTo: image1View.topAnchor, constant: -50).isActive = true
            messageLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
            messageLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
            
            vsCircleView.centerYAnchor.constraint(equalTo: image1View.centerYAnchor).isActive = true
            vsCircleView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            vsCircleView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.18).isActive = true
            vsCircleView.heightAnchor.constraint(equalTo: vsCircleView.widthAnchor).isActive = true
            
            image1PercentageLabel.topAnchor.constraint(equalTo: image1View.bottomAnchor, constant: 5).isActive = true
            image1PercentageLabel.leftAnchor.constraint(equalTo: image1View.leftAnchor).isActive = true
            image1PercentageLabel.rightAnchor.constraint(equalTo: image1View.rightAnchor).isActive = true
            
            
            image2PercentageLabel.topAnchor.constraint(equalTo: image2View.bottomAnchor, constant: 5).isActive = true
            image2PercentageLabel.leftAnchor.constraint(equalTo: image2View.leftAnchor).isActive = true
            image2PercentageLabel.rightAnchor.constraint(equalTo: image2View.rightAnchor).isActive = true
            
            
            commentaryMessageLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            commentaryMessageLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
            commentaryMessageLabel.topAnchor.constraint(equalTo: image1View.bottomAnchor, constant: 45).isActive = true
            
            resultsButton.bottomAnchor.constraint(equalTo: circleBackground.bottomAnchor, constant: -70).isActive = true
            resultsButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
            resultsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            resultsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            
            postMessageLabel.topAnchor.constraint(equalTo: circleBackground.bottomAnchor, constant: 40).isActive = true
            postMessageLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
            postMessageLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
            
            postButton.topAnchor.constraint(equalTo: postMessageLabel.bottomAnchor, constant: 50).isActive = true
            postButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            postButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            postButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
        }else{
            circleBackground.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            circleBackground.centerYAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            circleBackground.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1.5).isActive = true
            circleBackground.widthAnchor.constraint(equalTo: circleBackground.heightAnchor).isActive = true
            
            image1View.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -30).isActive = true
            image1View.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
            image1View.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -20).isActive = true
            image1View.heightAnchor.constraint(equalTo: image1View.widthAnchor).isActive = true
            
            image2View.bottomAnchor.constraint(equalTo: image1View.bottomAnchor).isActive = true
            image2View.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
            image2View.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 20).isActive = true
            image2View.heightAnchor.constraint(equalTo: image2View.widthAnchor).isActive = true
            
            messageLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
            messageLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
            messageLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
            
            
            commentaryMessageLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20).isActive = true
            commentaryMessageLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
            commentaryMessageLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
            //commentaryMessageLabel.bottomAnchor.constraint(equalTo: self.image1View.topAnchor, constant: -10).isActive = true
            
            uploadInstructionLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
            uploadInstructionLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
            uploadInstructionLabel.topAnchor.constraint(equalTo: self.image1View.bottomAnchor, constant: 30).isActive = true
            
            vsCircleView.centerYAnchor.constraint(equalTo: image1View.centerYAnchor).isActive = true
            vsCircleView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            vsCircleView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.18).isActive = true
            vsCircleView.heightAnchor.constraint(equalTo: vsCircleView.widthAnchor).isActive = true
            
            
            postMessageLabel.topAnchor.constraint(equalTo: circleBackground.bottomAnchor, constant: 40).isActive = true
            postMessageLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
            postMessageLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
            
            postButton.topAnchor.constraint(equalTo: postMessageLabel.bottomAnchor, constant: 50).isActive = true
            postButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            postButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            postButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
        }
        
    }
    
    func configure(){
        
        if self.builder == .vote {
            guard let firebaseUserId = self.network.firUserId else { return }
            self.network.queryUser(userId: firebaseUserId) { (user: UserData?, error: Error?) in
                if error != nil {
                    print("error in querying user")
                    return
                }
                
                guard let user = user else { return }
                
                self.network.user = user
                self.network.getPublicComparison(userId: user.userId, completion: { (postsToBeVoted) in
                    
                    self.queue.enqueue(postsToBeVoted)
                    self.enableVoting()
                })
            }
        }
        
    }
    
    
    
    func showPostFailed(){
        // ask user to re-do the post and apologize
    }
    
    func showPostSuccess(){
        
    }
    
    func uploadImageComparison(comparison: ComparisonRecord){
        guard let user = self.network.user else { return }
        self.network.uploadImages(userId: user.userId, comparison: comparison) { (success, error) in
            if success {
                self.showPostSuccess()
            }else{
                self.uploadImageComparison(comparison: comparison)
            }
        }
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
    
    
}






extension HomeViewController {
    // Actions of HomeViewController when self.builder == .vote
    
    func hideAnswer(){
        self.image1PercentageLabel.alpha = 0.0
        self.image2PercentageLabel.alpha = 0.0
        
        self.image1View.layer.borderColor = self.getTextColor().cgColor
        self.image2View.layer.borderColor = self.getTextColor().cgColor
    }
    
    func showAnswer() -> UIImageView{
        
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
    
    
    func changeText(correctness: Bool){
        
        var currentStatus: GameStatus!
        
        if (pastGameStatus != nil) {
            if pastGameStatus == .win && correctness == true {
                currentStatus = .consecutiveWin
            }else if pastGameStatus == .lose && correctness == false {
                currentStatus = .consecutiveLose
            }else if pastGameStatus == .win && correctness == false {
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
        heartView.image = UIImage()
        heartView.backgroundColor = .white
        heartView.translatesAutoresizingMaskIntoConstraints = false
        imgView.addSubview(heartView)
        heartView.centerXAnchor.constraint(equalTo: imgView.centerXAnchor).isActive = true
        heartView.centerYAnchor.constraint(equalTo: imgView.centerYAnchor).isActive = true
        heartView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        heartView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func voteExecute(imgView: UIImageView){
        
        self.switchInteractionOfImageViews(enabled: false)
        self.placeHeartViewOnImageView(imgView: imgView)
        let correctAns = self.showAnswer()
        self.changeText(correctness: correctAns == imgView ? true : false)
        
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




extension HomeViewController {
    
    func uploadExecute(user: UserData, image1: UIImage, image2: UIImage){
        
        var type: VotingSelection!
        
        if self.builder == .postPublic {
            type = VotingSelection.publicSelection
        }else{
            type = VotingSelection.privateSelection
        }
        
        self.network.createComparisonRequest(user: user, voteType: type, image1: image1, image2: image2) { (comparisonRecord, error) in
            
            if comparisonRecord == nil {
                self.showPostFailed()
            }else{
                self.uploadImageComparison(comparison: comparisonRecord!)
            }
        }
    }
    
    @objc func showContacts(){
        let picker = CNContactPickerViewController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func chooseFriend(){
        
        let picker = CNContactPickerViewController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        
        //self.uploadExecute(user: user, image1: image1, image2: image2)
    }
    
    @objc func uploadButtonPressed(sender: UIButton){
//        if self.image1View.image == UIImage(named: "addImageBackground") || self.image2View.image == UIImage(named: "addImageBackground") {
//            //prompt to select both images
//            SCLAlertView().showWarning("Whoops...", subTitle: "Please select two images to submit!")
//        }else{
//            //upload image to storage, then get url
//            guard let user = self.network.user else { return }
//            guard let image1 = self.image1View.image else { return }
//            guard let image2 = self.image2View.image else { return }
//
//            if self.builder == .postPublic {
//                self.uploadExecute(user: user, image1: image1, image2: image2)
//            }else if self.builder == .postPrivate {
//                self.chooseFriend(user: user, image1: image1, image2: image2)
//            }
//
//        }
        self.chooseFriend()
    }
    
    @objc func resultsButtonPressed(sender: UIButton){
        if let navigator = self.navigationController {
            navigator.pushViewController(ResultsTableViewController(network: self.network), animated: true)
        }
    }
    
    @objc func firstImagePressed() {
        //image picker
        self.uploadOrderIsFirst = true
        self.changeProfileImage()
        
    }
    
    @objc func secondImagePressed() {
        self.uploadOrderIsFirst = false
        self.changeProfileImage()
    }
    
    @objc func closeView() {
        self.dismiss(animated: true, completion: nil)
    }
}



extension HomeViewController: CustomAlertViewDelegate {
    //override if needed
}

extension HomeViewController: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        contacts.forEach { (contact) in
            
            print(contact.givenName)
            print(contact.phoneNumbers)
            
            //guard let friendsPhoneNumber = contact.phoneNumbers.first?.value.stringValue else { return }
            
//            if (MFMessageComposeViewController.canSendText()) {
//                let controller = MFMessageComposeViewController()
//                controller.body = "Message Body"
//                controller.recipients = [friendsPhoneNumber]
//                controller.messageComposeDelegate = self
//                self.present(controller, animated: true, completion: nil)
//            }
            
        }
    }
}

extension HomeViewController : MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        print("done")
        print(result)
    }
    
    //message stuff
}


extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func changeProfileImage(){
        
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var chosenImage: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            chosenImage = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            chosenImage = originalImage
        }
        
        if let selectedImage = chosenImage {
            
            if self.uploadOrderIsFirst {
                self.image1View.image = selectedImage
            }else{
                self.image2View.image = selectedImage
            }
        }
        
        dismiss(animated:true, completion: nil)
    }
    
}



extension Stylable where Self: HomeViewController {
    func getTitleFont() -> UIFont {
        return UIFont(name: "RockoFLF-Bold", size: 45)!
    }
}
