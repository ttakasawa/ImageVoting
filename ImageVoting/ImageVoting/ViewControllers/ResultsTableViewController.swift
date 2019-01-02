//
//  ResultsTableViewController.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/25/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ResultsTableViewController: UITableViewController, Stylable {
    
    var theme: ColorTheme
    var network: GlobalNetwork
    
    var comparisonData = [ComparisonRecord]()
    
    var image1ShouldPrefilled: UIImage?
    var image2ShouldPrefilled: UIImage?
    var postButton: PostButton!
    var postCommentary: UILabel!
    
    init (network: GlobalNetwork){
        self.network = network
        self.theme = network.appTheme
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = self.getSecondaryBackgroundColor()
        self.tableView.register(ResultsTableViewCell.self, forCellReuseIdentifier: "resultCell")
        self.tableView.separatorStyle = .none
        
        self.configure()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Results"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func configure(){
        
        guard let user = self.network.user else { return }
        self.network.queryPastResults(user: user) { (records) in
            self.comparisonData = records
            self.reloadTableView()
        }
        
//        let result = ComparisonRecord(image1Url: "https://firebasestorage.googleapis.com/v0/b/imagevoting-e0ac5.appspot.com/o/PublicImagePost%2Fsn1ER4dPDjRr9rvtl0BzVuVgiZi1%2F685B02BF-EE3B-46A5-8307-1EC201776900?alt=media&token=54d384a6-1c02-4db9-a292-4b93a65ba642", image2Url: "https://firebasestorage.googleapis.com/v0/b/imagevoting-e0ac5.appspot.com/o/PublicImagePost%2Fsn1ER4dPDjRr9rvtl0BzVuVgiZi1%2FA4140FBB-B094-4BC0-8516-C82AD95044B6?alt=media&token=a9a8035e-381b-47f1-a8b5-279f9e5cf810", maxVotes: 10, voteType: .publicSelection)
//
//        result.image1VoteCount = 4
//        result.image2VoteCount = 6
//
//        comparisonData.append(result)
//        comparisonData.append(result)
//
//        if comparisonData.count == 0 {
//            self.placePostButton()
//        }else{
//            self.removePostButton()
//            self.tableView.reloadData()
//        }
        
    }

    
    func reloadTableView() {
        if comparisonData.count == 0 {
            self.placePostButton()
        }else{
            self.removePostButton()
            self.tableView.reloadData()
        }
    }
    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comparisonData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! ResultsTableViewCell
        cell.result = self.comparisonData[indexPath.row]
        cell.selectionStyle = .none
        cell.backgroundColor = indexPath.row % 2 == 1 ? self.getMainBackgroundColor() : self.getSecondaryBackgroundColor()
        cell.delegate = self
        cell.layoutSubviews()
        
        Alamofire.request(self.comparisonData[indexPath.row].image1Url).responseImage { response in
            
            if let image = response.result.value {
                cell.setImage1(downloadedImage: image)
            }
        }
        
        Alamofire.request(self.comparisonData[indexPath.row].image2Url).responseImage { response in
            
            if let image = response.result.value {
                cell.setImage2(downloadedImage: image)
            }
        }
        // Configure the cell...

        return cell
    }

    
    func removePostButton(){
        guard let postButton = self.postButton else { return }
        guard let postCommentary = self.postCommentary else { return }
        
        postButton.removeFromSuperview()
        postCommentary.removeFromSuperview()
    }

    func placePostButton(){
        
        postButton = PostButton(title: "POST", theme: self.theme)
        postCommentary = UILabel()
        
        postButton.addTarget(self, action: #selector(self.postPressed), for: .touchUpInside)
        
        let commentaryMessages = ["Post your images to fond out the best image for you!", "They say how others see you is different from how you see yourself. Let's find out!", "Let's figure out which picture looks better!"]
        
        postCommentary.translatesAutoresizingMaskIntoConstraints = false
        postCommentary.text = commentaryMessages[Int.random(in: 0..<commentaryMessages.count)]
        postCommentary.textColor = self.getTextColor()
        postCommentary.font = self.getSmallText()
        postCommentary.numberOfLines = 0
        postCommentary.textAlignment = .center
        
        self.view.addSubview(postButton)
        self.view.addSubview(postCommentary)
        
        postButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        postButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
        
        postCommentary.bottomAnchor.constraint(equalTo: postButton.topAnchor, constant: -50).isActive = true
        postCommentary.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        postCommentary.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
    }
    
    @objc func postPressed(){
        let customAlert = VoteAlertViewController(type: .post, theme: self.theme, color: self.getMainAccentColor())
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self
        self.present(customAlert, animated: true, completion: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}




extension ResultsTableViewController : RePostAction {
    
    func rePostActionPressed(image1: UIImage, image2: UIImage) {
        
        image1ShouldPrefilled = image1
        image2ShouldPrefilled = image2
        
        let customAlert = VoteAlertViewController(type: .post, theme: self.theme, color: self.getMainAccentColor())
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self
        self.present(customAlert, animated: true, completion: nil)
        
    }
}


extension ResultsTableViewController: CustomAlertViewDelegate {
    
    func privateButtonPressed(actionType: ActionEnumurator) {
        self.present(HomeViewController(builder: .postPrivate, network: self.network, preFilledImage1: image1ShouldPrefilled, preFilledImage2: image2ShouldPrefilled), animated: true, completion: nil)
    }
    
    func publicButtonPressed(actionType: ActionEnumurator) {
        self.present(HomeViewController(builder: .postPrivate, network: self.network, preFilledImage1: image1ShouldPrefilled, preFilledImage2: image2ShouldPrefilled), animated: true, completion: nil)
    }
    
    
}
