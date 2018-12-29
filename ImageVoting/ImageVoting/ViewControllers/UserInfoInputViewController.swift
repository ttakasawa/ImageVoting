//
//  UserInfoInputViewController.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/30/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import fluid_slider

class UserInfoInputViewController: UIViewController, Stylable {
    
    var theme: ColorTheme
    var network: UserNetwork
    
    var scrollView = UIScrollView()
    
    var backViews: [UIView]!
    var buttons: [LargeButton]!
    var titleLabels: [UILabel]!
    
    let titleStrings = ["What's your name?", "How old are you?", "What's your gender?"]
    
    init(theme: ColorTheme, network: GlobalNetwork) {
        self.theme = theme
        self.network = network
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<3 {
            
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .clear
            
            let button: LargeButton!
            if i == 2 {
                button = LargeButton(title: "Done", theme: self.theme)
                button.backgroundColor = self.getMainAccentColor()
                button.addTarget(self, action: #selector(self.editCompleted), for: .touchUpInside)
            }else{
                button = LargeButton(title: "Next", theme: self.theme)
                button.backgroundColor = self.getSecondaryAccentColor()
                button.addTarget(self, action: #selector(self.nextPressed), for: .touchUpInside)
            }
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = self.getTitleFont()
            label.textColor = self.getTextColor()
            label.textAlignment = .center
            label.numberOfLines = 1
            label.adjustsFontSizeToFitWidth = true
            
            self.backViews.append(view)
            self.buttons.append(button)
            self.titleLabels.append(label)
            
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func nextPressed(){
        
    }
    
    @objc func editCompleted(){
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
