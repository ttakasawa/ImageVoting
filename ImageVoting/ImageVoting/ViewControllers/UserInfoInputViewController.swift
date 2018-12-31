//
//  UserInfoInputViewController.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/30/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import fluid_slider

class UserInfoInputViewController: UIViewController, Stylable {
    
    var theme: ColorTheme
    var network: UserNetwork
    var user: UserData
    
    var scrollView = UIScrollView()
    
    var backViews = [UIView]()
    var buttons = [LargeButton]()
    var titleLabels = [UILabel]()
    
    let titleStrings = ["What's your name?", "How old are you?", "What's your gender?"]
    
    let firstNameTextField = UITextField()
    let lastNameTextField = UITextField()
    let ageSelectionSlider = Slider()
    
    var maleButton : LargeButton!
    var femaleButton : LargeButton!
    var othersButton : LargeButton!
    var preferNotToAnswer : LargeButton!
    
    var ageVal: Int?
    var firstNameVal: String?
    var lastNameVal: String?
    let maxAgeConst = 80
    
    init(theme: ColorTheme, network: GlobalNetwork, user: UserData) {
        self.theme = theme
        self.network = network
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = self.getSecondaryBackgroundColor()
        self.scrollView.isScrollEnabled = false
        
        for i in 0..<3 {
            
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .clear
            
            let button: LargeButton!
            if i == 2 {
                button = LargeButton(title: "Done", theme: self.theme)
                button.backgroundColor = self.getMainAccentColor()
                button.addTarget(self, action: #selector(self.editCompleted), for: .touchUpInside)
            }else{
                button = LargeButton(title: "Next", theme: self.theme)
                button.backgroundColor = self.getSecondaryAccentColor()
                
                if i == 0 {
                    button.addTarget(self, action: #selector(self.toAge), for: .touchUpInside)
                }else{
                    button.addTarget(self, action: #selector(self.toGender), for: .touchUpInside)
                }
                
            }
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = self.getTitleFont()
            label.textColor = self.getTextColor()
            label.textAlignment = .center
            label.numberOfLines = 1
            label.adjustsFontSizeToFitWidth = true
            label.text = titleStrings[i]
            
//            self.backViews[i] = view
            
            self.backViews.append(view)
            self.buttons.append(button)
            self.titleLabels.append(label)
            
            view.addSubview(label)
            view.addSubview(button)
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
            
            
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            button.widthAnchor.constraint(equalToConstant: 280).isActive = true
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            
            if i == 0{
                firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
                firstNameTextField.backgroundColor = self.getMainBackgroundColor()
                firstNameTextField.layer.cornerRadius = 8
                //firstNameTextField.placeholder = "First Name here"
                firstNameTextField.textColor = self.getTextColor()
                firstNameTextField.attributedPlaceholder = NSAttributedString(string: "First Name here", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                if user.firstName != "Anonymous" {
                    firstNameTextField.text = user.firstName
                }
                
                
                view.addSubview(firstNameTextField)
                
                firstNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                firstNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
                firstNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
                firstNameTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30).isActive = true
                
                
                lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
                lastNameTextField.backgroundColor = self.getMainBackgroundColor()
                lastNameTextField.layer.cornerRadius = 8
                lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Last Name here", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                lastNameTextField.textColor = self.getTextColor()
                if user.lastName != "User" {
                    lastNameTextField.text = user.lastName
                }
                
                
                view.addSubview(lastNameTextField)
                
                lastNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                lastNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
                lastNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
                lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 20).isActive = true
                
                button.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 30).isActive = true
                
                //lastNameTextField
            }else if i == 1{
                ageSelectionSlider.attributedTextForFraction = { fraction in
                    let formatter = NumberFormatter()
                    formatter.maximumIntegerDigits = 3
                    formatter.maximumFractionDigits = 0
                    let string = formatter.string(from: (fraction * 80) as NSNumber) ?? ""
                    return NSAttributedString(string: string)
                }
                ageSelectionSlider.setMinimumLabelAttributedText(NSAttributedString(string: "0"))
                ageSelectionSlider.setMaximumLabelAttributedText(NSAttributedString(string: "80"))
                
                if let age = user.age {
                    ageSelectionSlider.fraction = CGFloat(Double(age) / Double(80))
                    self.ageVal = age
                }else{
                    ageSelectionSlider.fraction = 0.5
                }
                
                ageSelectionSlider.shadowOffset = CGSize(width: 0, height: 10)
                ageSelectionSlider.shadowBlur = 5
                ageSelectionSlider.shadowColor = UIColor(white: 0, alpha: 0.1)
                ageSelectionSlider.contentViewColor = self.getThirdAccentColor()
                ageSelectionSlider.valueViewColor = .white
                ageSelectionSlider.layer.cornerRadius = 15
                ageSelectionSlider.translatesAutoresizingMaskIntoConstraints = false
                ageSelectionSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
                
                view.addSubview(ageSelectionSlider)
                
                ageSelectionSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                ageSelectionSlider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
                ageSelectionSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
                ageSelectionSlider.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30).isActive = true
                
                button.topAnchor.constraint(equalTo: ageSelectionSlider.bottomAnchor, constant: 30).isActive = true
            }else{
                maleButton = LargeButton(title: "Men", theme: self.theme)
                femaleButton = LargeButton(title: "Women", theme: self.theme)
                othersButton = LargeButton(title: "Other", theme: self.theme)
                preferNotToAnswer = LargeButton(title: "Skip this", theme: self.theme)
                
                maleButton.addTarget(self, action: #selector(self.changeButtonColor), for: .touchUpInside)
                femaleButton.addTarget(self, action: #selector(self.changeButtonColor), for: .touchUpInside)
                othersButton.addTarget(self, action: #selector(self.changeButtonColor), for: .touchUpInside)
                preferNotToAnswer.addTarget(self, action: #selector(self.changeButtonColor), for: .touchUpInside)
                
                
                maleButton.backgroundColor = .clear
                maleButton.layer.borderWidth = 3
                maleButton.layer.borderColor = self.getTextColor().cgColor
                
                femaleButton.backgroundColor = .clear
                femaleButton.layer.borderWidth = 3
                femaleButton.layer.borderColor = self.getTextColor().cgColor
                
                othersButton.backgroundColor = .clear
                othersButton.layer.borderWidth = 3
                othersButton.layer.borderColor = self.getTextColor().cgColor
                
                preferNotToAnswer.backgroundColor = .clear
                preferNotToAnswer.layer.borderWidth = 3
                preferNotToAnswer.layer.borderColor = self.getTextColor().cgColor
                
                
                view.addSubview(maleButton)
                view.addSubview(femaleButton)
                view.addSubview(othersButton)
                view.addSubview(preferNotToAnswer)
                
                maleButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30).isActive = true
                maleButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
                maleButton.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -10).isActive = true
                maleButton.heightAnchor.constraint(equalTo: maleButton.widthAnchor, multiplier: 0.6).isActive = true
                
                femaleButton.topAnchor.constraint(equalTo: maleButton.topAnchor).isActive = true
                femaleButton.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 10).isActive = true
                femaleButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
                femaleButton.heightAnchor.constraint(equalTo: femaleButton.widthAnchor, multiplier: 0.6).isActive = true
                
                
                othersButton.topAnchor.constraint(equalTo: maleButton.bottomAnchor, constant: 20).isActive = true
                othersButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
                othersButton.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -10).isActive = true
                othersButton.heightAnchor.constraint(equalTo: othersButton.widthAnchor, multiplier: 0.6).isActive = true
                
                preferNotToAnswer.topAnchor.constraint(equalTo: othersButton.topAnchor).isActive = true
                preferNotToAnswer.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 10).isActive = true
                preferNotToAnswer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
                preferNotToAnswer.heightAnchor.constraint(equalTo: femaleButton.widthAnchor, multiplier: 0.6).isActive = true
                
                button.topAnchor.constraint(equalTo: preferNotToAnswer.bottomAnchor, constant: 30).isActive = true
                
                
                if let gender = user.gender {
                    if gender == .male {
                        changeColorOfButtons(button: maleButton, enabled: true)
                    }else if gender == .female {
                        changeColorOfButtons(button: femaleButton, enabled: true)
                    }else if gender == .other {
                        changeColorOfButtons(button: othersButton, enabled: true)
                    }else if gender == .noAnswer {
                        changeColorOfButtons(button: preferNotToAnswer, enabled: true)
                    }
                }
            }
        }
        
        
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        
        for i in 0..<3 {
            let view = backViews[i]
            
            scrollView.addSubview(view)
            
            view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
            
            if i == 0 {
                view.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
            }else{
                view.leftAnchor.constraint(equalTo: backViews[i - 1].rightAnchor).isActive = true
            }
            
            if i == 2 {
                view.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func changeColorOfButtons (button: UIButton, enabled: Bool) {
        
        if enabled {
            button.backgroundColor = self.getTextColor()
            button.setTitleColor(self.getSecondaryAccentColor(), for: .normal)
            button.isSelected = true
        }else{
            button.backgroundColor = .clear
            button.setTitleColor(self.getTextColor(), for: .normal)
            button.isSelected = false
        }
        
    }
}

@objc
extension UserInfoInputViewController {
    
    func sliderValueChanged(slider: Slider){
        
        self.ageVal = Int(Double(slider.fraction) * Double(maxAgeConst))
    }
    
    func toGender(){
        
        //scroll
        
        UIView.animate(withDuration: 0.4) {
            self.scrollView.setContentOffset(CGPoint(x: ScreenSize.SCREEN_WIDTH * 2, y: 0), animated: false)
        }
    }
    
    
    func toAge(){
        
        self.firstNameVal = self.firstNameTextField.text
        self.lastNameVal = self.lastNameTextField.text
        
        UIView.animate(withDuration: 0.4) {
            self.scrollView.setContentOffset(CGPoint(x: ScreenSize.SCREEN_WIDTH, y: 0), animated: false)
        }
    }
    
    func editCompleted(){
        
        var gender: Gender?
        
        if maleButton.isSelected {
            gender = Gender.male
        }else if femaleButton.isSelected {
            gender = Gender.female
        }else if othersButton.isSelected {
            gender = Gender.other
        }else if preferNotToAnswer.isSelected{
            gender = Gender.noAnswer
        }
        
        self.user.firstName = firstNameVal
        self.user.lastName = lastNameVal
        self.user.age = ageVal
        self.user.gender = gender
        
        self.network.updateUser(user: self.user) { (error) in
            if error != nil {
                //TODO: faile pop up

            }else{
                //TODO: success pop up
            }

        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func changeButtonColor(button: UIButton) {
        
        self.changeColorOfButtons(button: maleButton, enabled: false)
        self.changeColorOfButtons(button: femaleButton, enabled: false)
        self.changeColorOfButtons(button: othersButton, enabled: false)
        self.changeColorOfButtons(button: preferNotToAnswer, enabled: false)
        
        self.changeColorOfButtons(button: button, enabled: true)
        
    }
    
}
