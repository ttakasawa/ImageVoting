//
//  BasicLabel.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/16/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class BasicLabel: UILabel {
    var labelText: String
    var labelFont: UIFont
    var labelColor: UIColor
    
    init(text: String, font: UIFont, color: UIColor){
        self.labelText = text
        self.labelFont = font
        self.labelColor = color
        
        super.init(frame: CGRect.zero)
        
        self.text = self.labelText
        self.font = self.labelFont
        self.textColor = self.labelColor
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateText(newText: String){
        self.labelText = newText
    }
}
