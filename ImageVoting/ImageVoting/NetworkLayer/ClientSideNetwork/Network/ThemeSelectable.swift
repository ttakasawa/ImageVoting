//
//  ThemeSelectable.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/16/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

struct defaultsKeys {
    static let colorThemeKey = "colorTheme"
}

protocol ThemeSelectable {
    var appTheme: ColorTheme { get set }
}
