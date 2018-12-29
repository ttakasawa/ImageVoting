//
//  ViewController.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/15/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, Stylable {
    var theme: ColorTheme
    var network: GlobalNetwork
    
    var circleBackground: UIView!
    
    var profileButton: UIButton!
    var messageLabel: UILabel!
    var image1View: CircleImageView!
    var image2View: CircleImageView!
    var vsCircleView: CircleView!
    var statusMessage: UILabel!
    var postButton: PostButton!
    var voteMessageLabel: UILabel!
    var voteButton: VoteButton!
    
    
    init(network: GlobalNetwork){
        
        self.network = network
        self.theme = network.appTheme
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.createView()
        self.constrain()
        
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func createView(){
        
        let radiusOfLargeCircle = self.view.bounds.height * 0.75
        let radiusOfMediumCircle = self.view.bounds.width * 0.18
        let radiusOfSmallCircle = radiusOfMediumCircle * 0.5
        
        self.view.backgroundColor = self.getMainBackgroundColor()
        
        profileButton = UIButton()
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        profileButton.setImage(UIImage(named: "profileImage")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        profileButton.backgroundColor = .clear
        profileButton.imageView?.tintColor = self.getTextColor()
        
        circleBackground = UIView()
        circleBackground.translatesAutoresizingMaskIntoConstraints = false
        circleBackground.backgroundColor = self.getSecondaryBackgroundColor()
        circleBackground.layer.cornerRadius = radiusOfLargeCircle
        
        messageLabel = UILabel()
        messageLabel.text = "Let's see which image is the best!"
        messageLabel.font = self.getNormalFont()
        messageLabel.textColor = self.getTextColor()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.textAlignment = .center
        
        image1View = CircleImageView()
        image1View.makeCircle(radius: radiusOfMediumCircle)
        image1View.image = UIImage(named: "sample1")
        image1View.clipsToBounds = true
        image1View.contentMode = .scaleAspectFill
        image1View.translatesAutoresizingMaskIntoConstraints = false
        image1View.layer.borderWidth = 3
        image1View.layer.borderColor = self.getTextColor().cgColor
        
        
        image2View = CircleImageView()
        image2View.makeCircle(radius: radiusOfMediumCircle)
        image2View.image = UIImage(named: "sample2")
        image2View.clipsToBounds = true
        image2View.contentMode = .scaleAspectFill
        image2View.translatesAutoresizingMaskIntoConstraints = false
        image2View.layer.borderWidth = 3
        image2View.layer.borderColor = self.getTextColor().cgColor
        
        vsCircleView = CircleView(title: "VS", theme: self.theme)
        vsCircleView.makeCircle(radius: radiusOfSmallCircle)
        vsCircleView.backgroundColor = self.getMainBackgroundColor()
        vsCircleView.translatesAutoresizingMaskIntoConstraints = false
        vsCircleView.layer.borderColor = self.getSecondaryAccentColor().cgColor
        vsCircleView.layer.borderWidth = 3
        
        
        statusMessage = UILabel()
        statusMessage.text = "Voting in process ..."
        statusMessage.font = self.getSmallText()
        statusMessage.textColor = self.getTextColor()
        statusMessage.translatesAutoresizingMaskIntoConstraints = false
        statusMessage.adjustsFontSizeToFitWidth = true
        statusMessage.textAlignment = .center
        
        postButton = PostButton(title: "+ Post New Image", theme: self.theme)
        
        voteMessageLabel = UILabel()
        voteMessageLabel.text = "Vote for others to earn points!"
        voteMessageLabel.font = self.getNormalFont()
        voteMessageLabel.textColor = self.getTextColor()
        voteMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        voteMessageLabel.adjustsFontSizeToFitWidth = true
        voteMessageLabel.textAlignment = .center
        
        voteButton = VoteButton(title: "Vote", theme: self.theme)
        
        
        self.view.addSubview(circleBackground)
        self.view.addSubview(profileButton)
        self.view.addSubview(messageLabel)
        self.view.addSubview(image1View)
        self.view.addSubview(image2View)
        self.view.addSubview(vsCircleView)
        self.view.addSubview(statusMessage)
        self.view.addSubview(postButton)
        self.view.addSubview(voteMessageLabel)
        self.view.addSubview(voteButton)
        
    }
    
    func constrain(){
        
        circleBackground.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        circleBackground.centerYAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        circleBackground.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1.5).isActive = true
        circleBackground.widthAnchor.constraint(equalTo: circleBackground.heightAnchor).isActive = true
        
        profileButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        profileButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        profileButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        image1View.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -30).isActive = true
        image1View.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40).isActive = true
        image1View.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.36).isActive = true
        image1View.heightAnchor.constraint(equalTo: image1View.widthAnchor).isActive = true
        
        image2View.bottomAnchor.constraint(equalTo: image1View.bottomAnchor).isActive = true
        image2View.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40).isActive = true
        image2View.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.36).isActive = true
        image2View.heightAnchor.constraint(equalTo: image2View.widthAnchor).isActive = true
        
        messageLabel.bottomAnchor.constraint(equalTo: image1View.topAnchor, constant: -50).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        vsCircleView.centerYAnchor.constraint(equalTo: image1View.centerYAnchor).isActive = true
        vsCircleView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        vsCircleView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.18).isActive = true
        vsCircleView.heightAnchor.constraint(equalTo: vsCircleView.widthAnchor).isActive = true
        
        statusMessage.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        statusMessage.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        statusMessage.topAnchor.constraint(equalTo: image1View.bottomAnchor, constant: 28).isActive = true
        
        postButton.bottomAnchor.constraint(equalTo: circleBackground.bottomAnchor, constant: -80).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        postButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        voteMessageLabel.topAnchor.constraint(equalTo: circleBackground.bottomAnchor, constant: 40).isActive = true
        voteMessageLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        voteMessageLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        
        voteButton.topAnchor.constraint(equalTo: voteMessageLabel.bottomAnchor, constant: 50).isActive = true
        voteButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        voteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        voteButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
        
        
    }
    
    func update() {
        
    }
    
    func configure(){
        guard let firebaseUserId = self.network.firUserId else { return }
        self.network.queryUser(userId: firebaseUserId) { (user: UserData?, error: Error?) in
            if error != nil {
                print("error in querying user")
                return
            }
            
            //do somthing
            
        }
    }
}

