//
//  CircleView.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/16/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

class CircleView: UIView, Stylable {
    var theme: ColorTheme
    var title: String
    var titleLabel: UILabel!
    
    init(title: String, theme: ColorTheme) {
        self.title = title
        self.theme = theme
        super.init(frame: CGRect.zero)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = self.getTitleFont()
        titleLabel.textColor = self.getSecondaryAccentColor()
        titleLabel.adjustsFontSizeToFitWidth = true
        
        titleLabel.text = self.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeCircle(radius: CGFloat){
        self.layer.cornerRadius = radius
    }
}
