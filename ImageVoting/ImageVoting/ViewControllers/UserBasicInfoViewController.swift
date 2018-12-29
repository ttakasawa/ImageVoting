//
//  UserBasicInfoViewController.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/30/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class UserBasicInfoViewController: UIViewController, Stylable {
    
    var network: GlobalNetwork
    var theme: ColorTheme
    
    var userView: UserBasicInfoView!
    var editButton: LargeButton!
    
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
        
        self.view.backgroundColor = self.getSecondaryBackgroundColor()

        guard let user = self.network.user else { return}
        userView = UserBasicInfoView(theme: self.theme, userDisplayable: user)
        
        editButton = LargeButton(title: "Edit Profile", theme: self.theme)
        editButton.backgroundColor = self.getMainAccentColor()
        editButton.addTarget(self, action: #selector(self.editPressed), for: .touchUpInside)
        
        self.view.addSubview(userView)
        self.view.addSubview(editButton)
        
        userView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        userView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        userView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        
        editButton.topAnchor.constraint(equalTo: userView.bottomAnchor, constant: 30).isActive = true
        editButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Your Profile"
    }
    
    @objc func editPressed() {
        print("should edit")
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
