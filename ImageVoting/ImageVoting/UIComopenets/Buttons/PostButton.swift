//
//  VoteButton.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/16/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

class PostButton: LargeButton {
    
    override init(title: String, theme: ColorTheme) {
        super.init(title: title, theme: theme)
        self.setColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColor(){
        self.backgroundColor = self.getMainAccentColor()
    }
}


class ResultsButton: LargeButton {
    
    override init(title: String, theme: ColorTheme) {
        super.init(title: title, theme: theme)
        self.setColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColor(){
        self.backgroundColor = self.getThirdAccentColor()
    }
}

class AlertButtons: LargeButton {
    
    var color: UIColor
    
    init(title: String, theme: ColorTheme, color: UIColor) {
        self.color = color
        super.init(title: title, theme: theme)
        self.setColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColor(){
        self.backgroundColor = self.color
    }
    
}
