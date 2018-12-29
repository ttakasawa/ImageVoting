//
//  InputTextfield.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/24/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//


import Foundation
import UIKit

enum InputFieldType {
    case email
    case password
}

class InputTextField: UIView, Stylable {
    
    var theme: ColorTheme
    var fieldType: InputFieldType
    
    var icon: UIImageView!
    var textfield: UITextField!
    var underlineView: UIView!
    
    init(fieldType: InputFieldType, theme: ColorTheme){
        self.fieldType = fieldType
        self.theme = theme
        
        super.init(frame: CGRect.zero)
        
        self.configure()
        self.constrain()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        
        icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.font = self.getSmallText()
        textfield.textColor = self.getTextColor()
        textfield.placeholder = self.fieldType == .email ? "Email" : "Password"
        textfield.attributedPlaceholder = NSAttributedString(string: self.fieldType == .email ? "Email" : "Password", attributes: [NSAttributedString.Key.foregroundColor: self.getSecondaryAccentColor()])
        textfield.adjustsFontSizeToFitWidth = true
        
        underlineView = UIView()
        underlineView.backgroundColor = self.getSecondaryAccentColor()
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(icon)
        self.addSubview(textfield)
        self.addSubview(underlineView)
    }
    
    func constrain(){
        
        icon.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        icon.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        icon.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        icon.widthAnchor.constraint(equalTo: icon.heightAnchor).isActive = true
        
        underlineView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        underlineView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        underlineView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        underlineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        textfield.leftAnchor.constraint(equalTo: icon.rightAnchor).isActive = true
        textfield.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textfield.bottomAnchor.constraint(equalTo: underlineView.topAnchor).isActive = true
        textfield.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
    }
    
}

extension Stylable where Self: InputTextField {
    func getSecondaryAccentColor() -> UIColor {
        return UIColor.lightGray
    }
}

extension Stylable where Self: ProfileViewController {
}
