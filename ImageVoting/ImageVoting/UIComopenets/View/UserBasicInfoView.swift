//
//  UserBasicInfoView.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/30/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class UserBasicInfoView: UIView, Stylable {
    
    var theme: ColorTheme
    
    var profileImageView = UIImageView()
    var viewForLabels = UIView()
    var nameLabel = UILabel()
    var ageGenderLabel = UILabel()

    init(theme: ColorTheme, userDisplayable: UserDisplayable){
        self.theme = theme
        
        super.init(frame: CGRect.zero)
        
        self.layoutView()
        self.setValue(user: userDisplayable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutView(){
        
        let diameter = ScreenSize.SCREEN_WIDTH / 3
        let radius = diameter / 2
        
        self.layer.cornerRadius = 8
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = self.getMainBackgroundColor()
        
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.backgroundColor = self.getTextColor()
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = self.getThirdAccentColor().cgColor
        profileImageView.layer.borderWidth = 7
        profileImageView.layer.cornerRadius = radius
        
        viewForLabels.translatesAutoresizingMaskIntoConstraints = false
        viewForLabels.backgroundColor = .clear
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = self.getTitleFont()
        nameLabel.textColor = self.getTextColor()
        nameLabel.textAlignment = .center
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.numberOfLines = 1
        
        ageGenderLabel.translatesAutoresizingMaskIntoConstraints = false
        ageGenderLabel.font = self.getSmallText()
        ageGenderLabel.textColor = self.getTextColor()
        ageGenderLabel.textAlignment = .center
        ageGenderLabel.adjustsFontSizeToFitWidth = true
        ageGenderLabel.numberOfLines = 2
        
        
        self.addSubview(profileImageView)
        self.addSubview(viewForLabels)
        viewForLabels.addSubview(nameLabel)
        viewForLabels.addSubview(ageGenderLabel)
        
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: diameter).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        
        
        viewForLabels.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        viewForLabels.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 20).isActive = true
        viewForLabels.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: viewForLabels.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: viewForLabels.leftAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: viewForLabels.rightAnchor).isActive = true
        
        
        ageGenderLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        ageGenderLabel.leftAnchor.constraint(equalTo: viewForLabels.leftAnchor).isActive = true
        ageGenderLabel.rightAnchor.constraint(equalTo: viewForLabels.rightAnchor).isActive = true
        ageGenderLabel.bottomAnchor.constraint(equalTo: viewForLabels.bottomAnchor, constant: -10).isActive = true
        
        
        self.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10).isActive = true
    }
    
    func setValue(user: UserDisplayable){
        
        var nameString: String!
        var ageGenderString: String!
        var profileDefaultImage = UIImage()
        
        if (user.firstName != nil) {
            if (user.lastName != nil) {
                nameString = "\(user.firstName!) \(user.lastName!)"
            }else{
                nameString = "\(user.firstName!)"
            }
        }else{
            nameString = "Unknown"
        }
        
        if user.age != nil {
            if user.gender != nil {
                ageGenderString = "age: \(user.age!) \n gender: \(user.gender!.displayAs)"
            }else{
                ageGenderString = "age: \(user.age!)"
            }
        }else{
            if user.gender != nil {
                ageGenderString = "gender: \(user.gender!.displayAs)"
            }else{
                ageGenderString = ""
            }
        }
        
        //TODO: Figure out about the profile
        profileDefaultImage = UIImage(named: "sample1")!
        
        
        profileImageView.image = profileDefaultImage
        nameLabel.text = nameString
        ageGenderLabel.text = ageGenderString
        
    }
    
}


protocol UserDisplayable {
    var firstName: String? { get }
    var lastName: String? { get }
    var age: Int? { get }
    var gender: Gender? { get }
}

extension UserData: UserDisplayable { }
