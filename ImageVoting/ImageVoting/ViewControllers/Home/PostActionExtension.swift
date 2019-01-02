//
//  PostActionExtension.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 1/3/19.
//  Copyright © 2019 Tomoki Takasawa. All rights reserved.
//


import UIKit
import ContactsUI
import MessageUI
import SCLAlertView


extension HomeViewController {
    //for post
    
    func showPostFailed(){
        // ask user to re-do the post and apologize
        SCLAlertView().showWarning("Whoops", subTitle: "Something went wrong... Please check your connection and try again!")
    }
    
    func showPostSuccess(){
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("Ok", action: {
            self.dismiss(animated: true, completion: nil)
        })
        
        alert.showSuccess("Done", subTitle: "We will let you know once we get the result!")
    }
    
    func uploadImageComparison(user: UserData, comparison: ComparisonRecord){
        
        self.network.uploadImages(userId: user.userId, comparison: comparison) { (success, error) in
            
            self.loadAlert.hideView()
            
            if success {
                self.showPostSuccess()
            }else{
                self.showPostFailed()
            }
        }
    }
    
    func uploadExecute(user: UserData, image1: UIImage, image2: UIImage){
        
        var type: VotingSelection!
        
        self.loadAlert.showWait("Processing...", subTitle: "This may take a few seconds.")
        
        if self.builder == .postPublic {
            type = VotingSelection.publicSelection
        }else{
            type = VotingSelection.privateSelection
        }
        
        self.network.createComparisonRequest(user: user, voteType: type, image1: image1, image2: image2) { (comparisonRecord, error) in
            
            guard let comparisonRecord = comparisonRecord else {
                self.showPostFailed()
                return
            }
            
            self.uploadImageComparison(user: user, comparison: comparisonRecord)
        }
    }
    
    @objc func showContacts(){
        let picker = CNContactPickerViewController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func chooseFriend(){
        
        let picker = CNContactPickerViewController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        
        //self.uploadExecute(user: user, image1: image1, image2: image2)
    }
    
    @objc func uploadButtonPressed(sender: UIButton){
        if self.image1View.image == UIImage(named: "addImageBackground") || self.image2View.image == UIImage(named: "addImageBackground") {
            //prompt to select both images
            SCLAlertView().showWarning("Whoops...", subTitle: "Please select two images to submit!")
        }else{
            //upload image to storage, then get url
            if self.builder == .postPublic {
                guard let user = self.network.user else { return }
                guard let image1 = self.image1View.image else { return }
                guard let image2 = self.image2View.image else { return }
                
                self.uploadExecute(user: user, image1: image1, image2: image2)
            }else{
                
                self.chooseFriend()
            }
            
            
        }
        //self.chooseFriend()
    }
    
    @objc func resultsButtonPressed(sender: UIButton){
        if let navigator = self.navigationController {
            navigator.pushViewController(ResultsTableViewController(network: self.network), animated: true)
        }
    }
    
    @objc func firstImagePressed() {
        //image picker
        self.uploadOrderIsFirst = true
        self.changeProfileImage()
        
    }
    
    @objc func secondImagePressed() {
        self.uploadOrderIsFirst = false
        self.changeProfileImage()
    }
    
    @objc func closeView() {
        self.dismiss(animated: true, completion: nil)
    }
}





extension HomeViewController: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        contacts.forEach { (contact) in
            
            print(contact.givenName)
            print(contact.phoneNumbers)
            
            //guard let friendsPhoneNumber = contact.phoneNumbers.first?.value.stringValue else { return }
            
            //            if (MFMessageComposeViewController.canSendText()) {
            //                let controller = MFMessageComposeViewController()
            //                controller.body = "Message Body"
            //                controller.recipients = [friendsPhoneNumber]
            //                controller.messageComposeDelegate = self
            //                self.present(controller, animated: true, completion: nil)
            //            }
            
        }
    }
}

extension HomeViewController : MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        print("done")
        print(result)
    }
    
    //message stuff
}


extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func changeProfileImage(){
        
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var chosenImage: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            chosenImage = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            chosenImage = originalImage
        }
        
        if let selectedImage = chosenImage {
            
            if self.uploadOrderIsFirst {
                self.image1View.image = selectedImage
            }else{
                self.image2View.image = selectedImage
            }
        }
        
        dismiss(animated:true, completion: nil)
    }
    
}
