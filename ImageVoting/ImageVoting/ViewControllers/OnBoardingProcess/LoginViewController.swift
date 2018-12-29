//
//  LoginViewController.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/24/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit
import TransitionButton
import SCLAlertView

class LoginViewController: UIViewController, Stylable {
    
    var theme: ColorTheme
    var network: GlobalNetwork
    
    let welcomeLabel = UILabel()
    let continueButton = TransitionButton()
    
    var circleBackground: UIView!
    
    init(network: GlobalNetwork) {
        self.network = network
        self.theme = network.appTheme
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = self.getMainBackgroundColor()
        continueButton.addTarget(self, action: #selector(self.continuePressed), for: .touchUpInside)
        
        self.configure()
        self.constrain()
    }
    
    func configure() {
        
        let radiusOfLargeCircle = self.view.bounds.height * 0.75
        
        self.view.backgroundColor = self.getMainBackgroundColor()
        
        circleBackground = UIView()
        circleBackground.translatesAutoresizingMaskIntoConstraints = false
        circleBackground.backgroundColor = self.getSecondaryBackgroundColor()
        circleBackground.layer.cornerRadius = radiusOfLargeCircle
        
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.backgroundColor = self.getMainAccentColor()
        continueButton.layer.cornerRadius = self.getButtonCornerRadius()
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font = self.getTitleFont()
        continueButton.setTitleColor(self.getTextColor(), for: .normal)
        
        welcomeLabel.text = "Welcome to XXX"
        welcomeLabel.font = self.getNormalFont()
        welcomeLabel.textColor = self.getTextColor()
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.adjustsFontSizeToFitWidth = true
        welcomeLabel.textAlignment = .center
        
        self.view.addSubview(circleBackground)
        self.view.addSubview(continueButton)
        self.view.addSubview(welcomeLabel)
//        self.view.addSubview(passwrdField)
//        self.view.addSubview(emailField)
    }
    
    func constrain(){
        
        let diameter = self.view.bounds.height * 1.5
        
        
        continueButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80).isActive = true
        continueButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        continueButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        welcomeLabel.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -40).isActive = true
        welcomeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        welcomeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40).isActive = true
        
        circleBackground.topAnchor.constraint(equalTo: welcomeLabel.topAnchor, constant: -50).isActive = true
        circleBackground.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        circleBackground.heightAnchor.constraint(equalToConstant: diameter).isActive = true
        circleBackground.widthAnchor.constraint(equalTo: circleBackground.heightAnchor).isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        continueButton.layer.cornerRadius = self.getAnimatedButtonRadius()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    func loginSuccess(button: TransitionButton, user: UserData) {
        
        self.network.user = user
        
        button.stopAnimation(animationStyle: .expand, completion: {
            
            if let navigator = self.navigationController {
                navigator.pushViewController(HomeViewController(builder: HomeViewControllerBuilder.vote, network: self.network), animated: false)
            }
        })
    }
    
    
}


@objc
extension LoginViewController {
    
    
    func continuePressed(_ button: TransitionButton) {
        
        button.startAnimation()
        
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        
        backgroundQueue.async {
            DispatchQueue.main.async(execute: { () -> Void in
                
                self.network.signInAnonymously(completion: { (user) in
                    if user != nil {
                        self.loginSuccess(button: button, user: user!)
                    }else{
                        print("failed")
                    }
                })
            })
        }
    }
    
}



extension Stylable where Self: LoginViewController {
}
