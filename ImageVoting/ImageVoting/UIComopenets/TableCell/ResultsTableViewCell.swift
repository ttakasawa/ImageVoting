//
//  ResultsTableViewCell.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/25/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class ResultsTableViewCell: UITableViewCell, Stylable {
    
    var theme: ColorTheme
    
    let datePostedLabel = UILabel()
    let statusLabel = UILabel()
    
    let image1View = CircleImageView()
    let image2View = CircleImageView()
    
    let image1PercentageLabel = UILabel()
    let image2PercentageLabel = UILabel()
    
    var redoButton: LargeButton!
    
    var result: ComparisonRecord?
    
    weak var delegate: RePostAction!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.theme = Global.network.appTheme
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let radiusOfMediumCircle = ScreenSize.SCREEN_WIDTH * 0.04
        
        datePostedLabel.translatesAutoresizingMaskIntoConstraints = false
        datePostedLabel.textColor = self.getTextColor()
        datePostedLabel.font = self.getSmallText()
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.textColor = self.getTextColor()
        statusLabel.font = self.getSmallText()
        
        
        
        image1View.makeCircle(radius: radiusOfMediumCircle)
        image1View.clipsToBounds = true
        image1View.contentMode = .scaleAspectFill
        image1View.translatesAutoresizingMaskIntoConstraints = false
        image1View.layer.borderWidth = 3
        image1View.layer.borderColor = self.getTextColor().cgColor
        
        image2View.makeCircle(radius: radiusOfMediumCircle)
        image2View.clipsToBounds = true
        image2View.contentMode = .scaleAspectFill
        image2View.translatesAutoresizingMaskIntoConstraints = false
        image2View.layer.borderWidth = 3
        image2View.layer.borderColor = self.getTextColor().cgColor
        
        image1PercentageLabel.translatesAutoresizingMaskIntoConstraints = false
        image1PercentageLabel.textColor = self.getTextColor()
        image1PercentageLabel.font = self.getSmallText()
        
        image2PercentageLabel.translatesAutoresizingMaskIntoConstraints = false
        image2PercentageLabel.textColor = self.getTextColor()
        image2PercentageLabel.font = self.getSmallText()
        
        redoButton = LargeButton(title: "Post Again", theme: self.theme)
        redoButton.backgroundColor = self.getMainAccentColor()
        redoButton.addTarget(self, action: #selector(self.rePostPressed), for: .touchUpInside)
        
        self.addSubview(datePostedLabel)
        self.addSubview(statusLabel)
        self.addSubview(image1View)
        self.addSubview(image2View)
        self.addSubview(image1PercentageLabel)
        self.addSubview(image2PercentageLabel)
        self.addSubview(redoButton)
        
        self.constrain()
    }
    
    func constrain(){
        datePostedLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        datePostedLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        
        statusLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        statusLabel.topAnchor.constraint(equalTo: datePostedLabel.bottomAnchor, constant: 10).isActive = true
        
        image1View.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 30).isActive = true
        image1View.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        image1View.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: -20).isActive = true
        image1View.heightAnchor.constraint(equalTo: image1View.widthAnchor).isActive = true
        
        image2View.topAnchor.constraint(equalTo: image1View.topAnchor).isActive = true
        image2View.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: 20).isActive = true
        image2View.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        image2View.heightAnchor.constraint(equalTo: image1View.widthAnchor).isActive = true
        
        
        image1PercentageLabel.centerXAnchor.constraint(equalTo: image1View.centerXAnchor).isActive = true
        image1PercentageLabel.topAnchor.constraint(equalTo: image1View.bottomAnchor, constant: 10).isActive = true
        
        image2PercentageLabel.centerXAnchor.constraint(equalTo: image2View.centerXAnchor).isActive = true
        image2PercentageLabel.topAnchor.constraint(equalTo: image2View.bottomAnchor, constant: 10).isActive = true
        
        redoButton.topAnchor.constraint(equalTo: image1PercentageLabel.bottomAnchor, constant: 30).isActive = true
        redoButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        redoButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
        redoButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.bottomAnchor.constraint(equalTo: redoButton.bottomAnchor, constant: 50).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let record = self.result {
            
            let cal = Calendar.current
            let year = cal.component(.year, from: record.timestamp)
            let month = cal.component(.month, from: record.timestamp)
            let day = cal.component(.day, from: record.timestamp)
            let dateString = String(describing: year) + "/" + String(describing: month) + "/" + String(describing: day)
            
            self.datePostedLabel.text = "posted: " + dateString
            self.statusLabel.text = record.totalVotes >= record.totalVotesNeeded ? "Status: Completed" : "Status: In process"
            
            
            let image1Percent = record.image1Percentage ?? 50
            let image2Percent = 100 - image1Percent
            
            self.image1PercentageLabel.text = record.totalVotes >= record.totalVotesNeeded ? String(image1Percent) + " %" : "?? %"
            self.image2PercentageLabel.text = record.totalVotes >= record.totalVotesNeeded ? String(image2Percent) + " %" : "?? %"
            
            
            if record.totalVotes >= record.totalVotesNeeded {
                if record.image1VoteCount >= record.image2VoteCount {
                    self.image1View.layer.borderColor = self.getThirdAccentColor().cgColor
                }else{
                    self.image2View.layer.borderColor = self.getThirdAccentColor().cgColor
                }
            }
            
        }
        
    }
    
    func setImage1(downloadedImage: UIImage){
        self.image1View.image = downloadedImage
    }
    
    func setImage2(downloadedImage: UIImage){
        self.image2View.image = downloadedImage
    }

    @objc func rePostPressed(){
        self.delegate.rePostActionPressed(image1: image1View.image ?? UIImage(), image2: image2View.image ?? UIImage())
    }
}



protocol RePostAction: class {
    func rePostActionPressed(image1: UIImage, image2: UIImage)
}
