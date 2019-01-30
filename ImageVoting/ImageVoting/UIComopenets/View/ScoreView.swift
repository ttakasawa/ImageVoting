//
//  ScoreView.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 1/18/19.
//  Copyright © 2019 Tomoki Takasawa. All rights reserved.
//

import UIKit

class ScoreView: UIView, Stylable {
    var theme: ColorTheme
    
    var bestScore = UILabel()
    var bestScoreTitle = UILabel()
    
    var currentScore = UILabel()
    var currentScoreTitle = UILabel()
    
    var separator = UILabel()
    
    init(theme: ColorTheme) {
        self.theme = theme
        
        super.init(frame: CGRect.zero)
        
        bestScore.translatesAutoresizingMaskIntoConstraints = false
        bestScore.textColor = self.getThirdAccentColor()
        bestScore.font = self.getScoreFont()
        bestScore.textAlignment = .center
        bestScore.numberOfLines = 1
        
        bestScoreTitle.translatesAutoresizingMaskIntoConstraints = false
        bestScoreTitle.textColor = self.getThirdAccentColor()
        bestScoreTitle.font = self.getSmallText()
        bestScoreTitle.textAlignment = .center
        bestScoreTitle.numberOfLines = 1
        
        currentScore.translatesAutoresizingMaskIntoConstraints = false
        currentScore.textColor = self.getTextColor()
        currentScore.font = self.getScoreFont()
        currentScore.textAlignment = .center
        currentScore.numberOfLines = 1
        
        currentScoreTitle.translatesAutoresizingMaskIntoConstraints = false
        currentScoreTitle.textColor = self.getTextColor()
        currentScoreTitle.font = self.getSmallText()
        currentScoreTitle.textAlignment = .center
        currentScoreTitle.numberOfLines = 1
        
        separator.backgroundColor = self.getThirdAccentColor()
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(separator)
        self.addSubview(bestScore)
        self.addSubview(bestScoreTitle)
        self.addSubview(currentScore)
        self.addSubview(currentScoreTitle)
        
        self.constrain()
        
        bestScore.text = "0"
        bestScoreTitle.text = "Best"
        currentScore.text = "0"
        currentScoreTitle.text = "Current"
    }
    
    func constrain(){
        separator.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        separator.widthAnchor.constraint(equalToConstant: 8).isActive = true
        
        bestScore.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        bestScore.rightAnchor.constraint(equalTo: separator.leftAnchor, constant: -15).isActive = true
        bestScore.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bestScoreTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        bestScoreTitle.rightAnchor.constraint(equalTo: separator.leftAnchor, constant: -15).isActive = true
        bestScoreTitle.topAnchor.constraint(equalTo: bestScore.bottomAnchor,  constant: 5).isActive = true
        bestScoreTitle.bottomAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        
        currentScore.leftAnchor.constraint(equalTo: separator.rightAnchor, constant: 15).isActive = true
        currentScore.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        currentScore.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        currentScoreTitle.leftAnchor.constraint(equalTo: separator.rightAnchor, constant: 15).isActive = true
        currentScoreTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        currentScoreTitle.topAnchor.constraint(equalTo: currentScore.bottomAnchor,  constant: 5).isActive = true
        currentScoreTitle.bottomAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        
        bestScore.topAnchor.constraint(equalTo: currentScore.topAnchor).isActive = true
        bestScore.bottomAnchor.constraint(equalTo: currentScore.bottomAnchor).isActive = true
        bestScoreTitle.topAnchor.constraint(equalTo: currentScoreTitle.topAnchor).isActive = true
        bestScoreTitle.bottomAnchor.constraint(equalTo: currentScoreTitle.bottomAnchor).isActive = true
        
        self.bottomAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateScore(bestScore: Int, currentScore: Int){
        self.bestScore.text = String(bestScore)
        self.currentScore.text = String(currentScore)
    }
    
}

extension Stylable where Self: ScoreView {
    
    func getScoreFont() -> UIFont {
        return UIFont(name: "RockoFLF-Bold", size: 35)!
    }
}
