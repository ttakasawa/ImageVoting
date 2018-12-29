//
//  ColorStylable.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/15/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
enum ColorTheme {
    case dark
    case light
}

protocol ColorStylable {
    
    var theme: ColorTheme { get set }
    
    func getMainBackgroundColor() -> UIColor
    func getSecondaryBackgroundColor() -> UIColor
    func getMainAccentColor() -> UIColor
    func getSecondaryAccentColor() -> UIColor
    func getThirdAccentColor() -> UIColor
    func getTextColor() -> UIColor
    func getSecondaryTextColor() -> UIColor
    
}

extension ColorStylable {
    
    func getMainBackgroundColor() -> UIColor {
        //R: 20 G: 32 B: 92
        if self.theme == .dark {
            return UIColor(red: 20.0/255.0, green: 32.0/255.0, blue: 92.0/255.0, alpha: 1)
        }else{
            return UIColor(red: 20.0/255.0, green: 32.0/255.0, blue: 92.0/255.0, alpha: 1)
        }
    }
    func getSecondaryBackgroundColor() -> UIColor {
        //R: 29 G: 48 B: 118
        if self.theme == .dark {
            return UIColor(red: 29.0/255.0, green: 48.0/255.0, blue: 118.0/255.0, alpha: 1)
        }else{
            return UIColor(red: 20.0/255.0, green: 32.0/255.0, blue: 92.0/255.0, alpha: 1)
        }
    }
    func getMainAccentColor() -> UIColor {
        //R: 255 G: 63 B: 134
        if self.theme == .dark {
            return UIColor(red: 255.0/255.0, green: 63.0/255.0, blue: 134.0/255.0, alpha: 1)
        }else{
            return UIColor(red: 20.0/255.0, green: 32.0/255.0, blue: 92.0/255.0, alpha: 1)
        }
    }
    
    func getSecondaryAccentColor() -> UIColor {
        //R: 57 G: 243 B: 184   -> green   : 75 G: 218 B: 100
        if self.theme == .dark {
            return UIColor(red:14.0/255.0, green:211.0/255.0, blue:140.0/255.0, alpha:255.0/255.0)
        }else{
            return UIColor(red: 20.0/255.0, green: 32.0/255.0, blue: 92.0/255.0, alpha: 1)
        }
    }
    
    func getThirdAccentColor() -> UIColor {
        //R: 252 G: 168 B: 98   -> orange
        if self.theme == .dark {
            return UIColor(red: 252.0/255.0, green: 168.0/255.0, blue: 98.0/255.0, alpha: 1)
        }else{
            return UIColor(red: 20.0/255.0, green: 32.0/255.0, blue: 92.0/255.0, alpha: 1)
        }
    }
    
    func getTextColor() -> UIColor {
        //    R: 245 G: 253 B: 255 or white
        if self.theme == .dark {
            return UIColor(red: 245.0/255.0, green: 253.0/255.0, blue: 255.0/255.0, alpha: 1)
        }else{
            return UIColor(red: 20.0/255.0, green: 32.0/255.0, blue: 92.0/255.0, alpha: 1)
        }
    }
    
    func getSecondaryTextColor() -> UIColor {
        //R: 29 G: 48 B: 118
        return self.getSecondaryBackgroundColor()
    }
    
}
