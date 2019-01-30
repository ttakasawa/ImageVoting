//
//  FontStylable.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/15/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

protocol FontStylable {
    func getTitleFont() -> UIFont
    func getSubTitleFont() -> UIFont
    func getNormalFont() -> UIFont
    func getSubNormalFont() -> UIFont
    func getSmallText() -> UIFont
    func getScoreFont() -> UIFont
}


extension FontStylable {
    func getTitleFont() -> UIFont {
        return UIFont(name: "RockoFLF-Bold", size: 25)!
    }
    
    func getSubTitleFont() -> UIFont {
        return UIFont(name: "RockoFLF-Bold", size: 25)!
    }
    
    func getNormalFont() -> UIFont {
        return UIFont(name: "RockoFLF", size: 25)!
    }
    
    func getSubNormalFont() -> UIFont {
        return UIFont(name: "RockoFLF", size: 25)!
    }
    
    func getSmallText() -> UIFont {
        return UIFont(name: "RockoFLF", size: 18)!
    }
    
    func getScoreFont() -> UIFont {
        return UIFont(name: "RockoFLF-Bold", size: 35)!
    }
}
