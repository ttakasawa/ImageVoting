//
//  ButtonStylable.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/24/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

protocol ButtonStylable {
    func getButtonCornerRadius() -> CGFloat
    func getAnimatedButtonRadius() -> CGFloat
}

extension ButtonStylable {
    func getButtonCornerRadius() -> CGFloat {
        return 15
    }
    
    func getAnimatedButtonRadius() -> CGFloat {
        return 25
    }
}
