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
    
    var scoreLabel: UILabel!
    var closeButton: UIButton!
    var profileButton: UIButton!
    var messageLabel: UILabel!
    var image1View: CircleImageView!
    var image2View: CircleImageView!
    var heartView: UIImageView?
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
        
        var pointsEarned: Int {
            switch self {
            case .win:
                return 1
            case .lose, .consecutiveLose:
                return 0
            case .consecutiveWin:
                return 2
            }
        }
        
    }
    
    var preFilledImage1: UIImage?
    var preFilledImage2: UIImage?
    
    let loadAlert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(
        showCloseButton: false
    ))
    
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
            scoreLabel.text = "0 pts"
            
            
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
        
        scoreLabel = UILabel()
        scoreLabel.font = self.getNormalFont()
        scoreLabel.textColor = self.getTextColor()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.adjustsFontSizeToFitWidth = true
        scoreLabel.textAlignment = .center
        
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
            self.view.addSubview(scoreLabel)
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
            
            scoreLabel.centerYAnchor.constraint(equalTo: profileButton.centerYAnchor).isActive = true
            scoreLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
            
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
                    print(error.debugDescription)
                    return
                }
                
                guard let user = user else { return }
                
                self.network.user = user
                self.scoreLabel.text = String(user.points) + " pts"
                
                self.network.getPublicComparison(userId: user.userId, completion: { (postsToBeVoted) in
                    
                    self.queue.enqueue(postsToBeVoted)
                    self.enableVoting()
                })
            }
        }
        
    }
    
    
}



extension HomeViewController: CustomAlertViewDelegate {
    //override if needed
}





extension Stylable where Self: HomeViewController {
    func getTitleFont() -> UIFont {
        return UIFont(name: "RockoFLF-Bold", size: 45)!
    }
}

