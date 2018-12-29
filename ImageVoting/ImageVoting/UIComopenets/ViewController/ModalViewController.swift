//
//  ModalViewController.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/20/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

protocol ModalController : class {
    var navigationController:UINavigationController? { get }
    func configureCloseButton(selector: Selector)
    var closeButton: UIButton! { get set }
}


extension ModalController where Self: UIViewController {
    
    func configureCloseButton(selector: Selector) {
        closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named: "XoutModal"), for: .normal)
        //button.backgroundColor = UIColor.purple
        closeButton.addTarget(self, action: selector, for: .touchUpInside)
        let bounds = self.view.bounds
        closeButton.frame = CGRect(x: bounds.width - 60, y: 60
            , width: 30, height: 30)
        self.view.addSubview(closeButton)
        self.view.bringSubviewToFront(closeButton)
    }
    
}




