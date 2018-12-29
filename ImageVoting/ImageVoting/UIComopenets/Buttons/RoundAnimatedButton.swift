//
//  RoundAnimatedButton.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/16/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class AnimatedButton: UIButton {
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureAnimation()
    }
    
    func configureAnimation() {
        self.addTarget(self, action: #selector(self.animatePress), for: .touchDown)
    }
    
    @objc func animatePress() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (completed) in
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = .identity
            })
        }
    }
}

