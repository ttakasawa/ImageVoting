//
//  LargeButton.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/16/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

class LargeButton: AnimatedButton, Stylable {
    var theme: ColorTheme
    var titleLable: String
    
    init(title: String, theme: ColorTheme) {
        self.theme = theme
        self.titleLable = title
        super.init(frame: CGRect.zero)
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        
        self.setTitle(self.titleLable, for: .normal)
        //self.backgroundColor = self.getMainAccentColor()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 20
        self.setTitleColor(self.getTextColor(), for: .normal)
        self.titleLabel?.font = self.getTitleFont()
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
}
