//
//  ProfileViewController.swift
//  Travellers
//
//  Created by Nasch on 03/05/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import UIKit
import Firebase
//KINGFISHER


class ProfileViewController: UIViewController {
    var user: User?
    var db: Firestore!
    let storageRef = Storage.storage().reference()
    
    
    @IBOutlet weak var firstname: UILabel!
    @IBOutlet weak var lastname: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var bioText: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bioText.delegate = self as? UITextViewDelegate
        db = Firestore.firestore()
        profilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectProfileImage)))
        
        // checking user info
        Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if FirebaseHelper().connected() != nil {
            // user is connected get user
            let user = Auth.auth().currentUser
            // Get document in DB
            if let user = user {
                let docRef = db.collection("users").document("\(user.uid)")
                docRef.getDocument { (document, error) in
                    guard let document = document, document.exists else { return }
                    let dataDescription = document.data()
                    let firstname = dataDescription!["Firstname"] as? String ?? ""
                    let lastname = dataDescription!["Lastname"] as? String ?? ""
                    let bioText = dataDescription!["Bio"] as? String ?? ""
                    //let profile = dataDescription!["Profil"] as? String ?? ""
                    self.firstname.text = firstname.capitalized
                    self.lastname.text = lastname.capitalized
                    self.bioText.text = bioText
                    //self.profile = setImage
                    print("Document data: \(String(describing: dataDescription))")
                }
            }
        } else {
            // no user connected, send back to LoginViewController
            performSegue(withIdentifier: "Log", sender: nil)
        }
    }
    
    // modify bio text and save it to firebase
    func modifyBioText() {
        bioText.delegate?.textViewDidEndEditing?(bioText)
        let dataToSave: [String: Any] = ["Bio": bioText.text ?? "About me"]
        guard let user = user else { return }
        self.db.collection("users").document("\(user.uid)").setData(dataToSave, merge: true, completion: { (error) in
            if let error = error {
                print("noooooooo \(error.localizedDescription)")
            }
        })
    }
    
    // add profil picture
    @objc func selectProfileImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        let actionSheet = UIAlertController(title: "Photo source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Missing camera", message: "There is no camera available!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    func uploadImageProfile() {
        // Reference to folder of profile image
        guard let userId = user?.uid else { return }
        let profileImageRef = storageRef.child("profileImage/\(userId).jpg")
        
        // File located on disk
        guard let data = profilePicture.image?.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = profileImageRef.putData(data, metadata: nil) { (metadata, error) in
            //.putFile(from: localFile, metadata: nil) { metadata, error in
            guard let metadata = metadata else { return }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            profileImageRef.downloadURL { (url, error) in
                guard let downloadURL = url else { return }
                
                //        let dataToSave: [String: Any] = ["Profil": "downloadURL"]
                //        guard let user = user else { return }
                //        self.db.collection("users").document("\(user.uid)").setData(dataToSave, merge: true, completion: { (error) in
                //            if let error = error {
                //                print("noooooooo \(error.localizedDescription)")
                //            }
                //        })
            }
        }
        
        
    }
    
    
    
    // Disconnect user
    @IBAction func disconnectButton(_ sender: UIButton) {
        let user = Auth.auth()
        do {
            try user.signOut()
            self.dismiss(animated: true, completion: nil)
        } catch let error {
            print("sign out failed", error.localizedDescription)
        }
    }
    
    // dismiss keyboard when clic away have to make the view a TapgestureRecognizer
    @IBAction func DismissKeyboard(_ sender: UITapGestureRecognizer) {
        bioText.resignFirstResponder()
        modifyBioText()
    }
}


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imageChoose = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        
        
        profilePicture.image = imageChoose
        
        
        uploadImageProfile()
        
        
        picker.dismiss(animated: true, completion: nil)
    }
}
