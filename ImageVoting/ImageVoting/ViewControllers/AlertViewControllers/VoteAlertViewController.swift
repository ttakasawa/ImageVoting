//
//  VoteAlertViewController.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/16/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

protocol CustomAlertViewDelegate: class {
    var network: GlobalNetwork { get }
    func privateButtonPressed(actionType: ActionEnumurator)
    func publicButtonPressed(actionType: ActionEnumurator)
    func cancelButtonTapped()
}

extension CustomAlertViewDelegate where Self: UIViewController {
    
    func privateButtonPressed(actionType: ActionEnumurator) {
        self.present(HomeViewController(builder: HomeViewControllerBuilder.postPrivate, network: self.network), animated: true, completion: nil)
    }
    
    func publicButtonPressed(actionType: ActionEnumurator) {
        self.present(HomeViewController(builder: HomeViewControllerBuilder.postPublic, network: self.network), animated: true, completion: nil)
    }
    
    func cancelButtonTapped() {
        print("cancel")
    }
}



enum ActionEnumurator {
    case post
    case vote
}

class VoteAlertViewController: UIViewController, Stylable {
    var theme: ColorTheme
    var primaryColor: UIColor
    var actionType: ActionEnumurator
    
    var alertView: UIView!
    var descriptionLabel: UILabel!
    var publicButton: AlertButtons!
    var privateButton: AlertButtons!
    var cancelButton: AlertButtons!
    
    let buttonTitles = [
        [
            "Get Voted",
            "Ask Friends",
            "Cancel"
        ],
        [
            "Vote on other's",
            "Vote on Friend's",
            "Cancel"
        ]
    ]
    
    var titleArray: [String]!
    
    var delegate: CustomAlertViewDelegate?
    let alertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    
    init(type: ActionEnumurator, theme: ColorTheme, color: UIColor) {
        self.theme = theme
        self.primaryColor = color
        self.actionType = type
        super.init(nibName: nil, bundle: nil)
        
        if self.actionType == .vote {
            titleArray = buttonTitles[1]
        }else{
            titleArray = buttonTitles[0]
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertView = UIView()
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.backgroundColor = self.getMainBackgroundColor()
        
        descriptionLabel = UILabel()
        descriptionLabel.text = "Would you like your friends to choose the best photo for you or get voted?"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = self.getNormalFont()
        descriptionLabel.textColor = self.getTextColor()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.textAlignment = .center
        
        publicButton = AlertButtons(title: titleArray[0], theme: self.theme, color: self.primaryColor)
        publicButton.addTarget(self, action: #selector(self.onTapPublicButton), for: .touchUpInside)
        
        privateButton = AlertButtons(title: titleArray[1], theme: self.theme, color: self.primaryColor)
        privateButton.addTarget(self, action: #selector(self.onTapPrivateButton), for: .touchUpInside)
        
        cancelButton = AlertButtons(title: titleArray[2], theme: self.theme, color: self.primaryColor)
        cancelButton.addTarget(self, action: #selector(self.onTapCancelButton), for: .touchUpInside)
        
        self.view.addSubview(alertView)
        alertView.addSubview(descriptionLabel)
        alertView.addSubview(publicButton)
        alertView.addSubview(privateButton)
        alertView.addSubview(cancelButton)
        
        self.constrain()
    }
    
    func constrain(){
        alertView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        alertView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 50).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 30).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor).isActive = true
        
        publicButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30).isActive = true
        publicButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
        publicButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        publicButton.centerXAnchor.constraint(equalTo: self.alertView.centerXAnchor).isActive = true
        
        privateButton.topAnchor.constraint(equalTo: publicButton.bottomAnchor, constant: 10).isActive = true
        privateButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
        privateButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        privateButton.centerXAnchor.constraint(equalTo: self.alertView.centerXAnchor).isActive = true
        
        cancelButton.topAnchor.constraint(equalTo: privateButton.bottomAnchor, constant: 10).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: self.alertView.centerXAnchor).isActive = true
        
        alertView.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 30).isActive = true
        alertView.leftAnchor.constraint(equalTo: publicButton.leftAnchor, constant: -30).isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
        
    }
    
    func setupView() {
        alertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func animateView() {
        alertView.alpha = 0
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    
    @objc func onTapPublicButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.publicButtonPressed(actionType: self.actionType)
        
    }
    
    @objc func onTapPrivateButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.privateButtonPressed(actionType: self.actionType)
        
    }
    
    @objc func onTapCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.cancelButtonTapped()
        
    }
}


extension Stylable where Self: VoteAlertViewController {
    func getMainBackgroundColor() -> UIColor {
        return UIColor.white
    }
    
    
    func getTextColor() -> UIColor {
        return UIColor.darkGray
    }
}
