//
//  ProfileViewController.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/16/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//


import UIKit
import SafariServices
import FirebaseAuth
import SCLAlertView

enum SettingsType {
    case setting
    case dogManagement
}


enum editableDogInfo {
    case name
    case age
    case breed
}

struct Setting {
    static let sectionTitleArray = ["About YOU", "About US", "Other"]
    static let titleArray = [
        [
            "Your Basic Info",
            "Audience",
            "Past Result"
        ],
        [
            "Terms and Conditions",
            "Privacy Policy",
        ],
        [
            "Share"
        ]
    ]
}


class ProfileViewController: UITableViewController, Stylable {
    
    //var tableView = UITableView()
    var network: GlobalNetwork
    var theme: ColorTheme
    
    init(theme: ColorTheme, network: GlobalNetwork){
        self.network = network
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = self.getMainBackgroundColor()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Profile"
    }
    
    // MARK: UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return Setting.sectionTitleArray.count
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Setting.titleArray[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42.0
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return Setting.sectionTitleArray[section]
        
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = self.getMainBackgroundColor()
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = self.getSecondaryAccentColor()
        header.textLabel?.font = self.getSubTitleFont()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") ?? UITableViewCell.init(style: .subtitle, reuseIdentifier: "UITableViewCell")
        cell.backgroundColor = self.getSecondaryBackgroundColor()
        
        cell.textLabel?.textColor = self.getTextColor()
        cell.textLabel?.font = self.getSmallText()
        cell.textLabel?.lineBreakMode = .byCharWrapping
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = "\(Setting.titleArray[indexPath.section][indexPath.row])"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                print("hi")
            case 1:
                print("dfv")
            case 2:
                if let navigator = self.navigationController {
                    navigator.pushViewController(ResultsTableViewController(network: self.network), animated: true)
                }
                
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                print("hi")
            case 1:
                print("hi")
                
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                self.network.logout()
                
            default:
                break
            }
        default:
            break
        }
    }
    
    
    func showSuccess(){
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("Okay", action: {
            if let navigator = self.navigationController {
                navigator.popViewController(animated: true)
            }
        })
        
        alert.showSuccess("", subTitle: "Success!")
    }
    
}


extension Stylable where Self: ProfileViewController {
    func getSubTitleFont() -> UIFont {
        return UIFont(name: "RockoFLF-Bold", size: 16)!
    }
}
