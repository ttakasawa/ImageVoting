//
//  NoPostsAvailableView.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 1/22/19.
//  Copyright © 2019 Tomoki Takasawa. All rights reserved.
//

import UIKit

class NoPostsAvailableView: UIView, Stylable {
    var theme: ColorTheme
    let noAvaiableLabel = UILabel()

    init(theme: ColorTheme) {
        self.theme = theme
        super.init(frame: CGRect.zero)
        
        noAvaiableLabel.text = "There's no posts to be voted around your area at the moment"
        noAvaiableLabel.translatesAutoresizingMaskIntoConstraints = false
        noAvaiableLabel.font = self.getSmallText()
        noAvaiableLabel.textColor = self.getTextColor()
        noAvaiableLabel.adjustsFontSizeToFitWidth = true
        noAvaiableLabel.numberOfLines = 2
        noAvaiableLabel.textAlignment = .center
        
        self.addSubview(noAvaiableLabel)
        
        noAvaiableLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        noAvaiableLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        noAvaiableLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
