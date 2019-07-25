//
//  ProfileViewController.swift
//  Travellers
//
//  Created by Nasch on 03/05/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    var user: User?
    var db: Firestore!
    let storageRef = Storage.storage().reference()
    
    
    @IBOutlet weak var firstname: UILabel!
    @IBOutlet weak var lastname: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        let imageRef = storageRef.child("image")
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
                    self.firstname.text = firstname.capitalized
                    self.lastname.text = lastname.capitalized
                    print("Document data: \(String(describing: dataDescription))")
                }
            }
        } else {
            // no user connected, send back to LoginViewController
            performSegue(withIdentifier: "Log", sender: nil)
        }
    }
    
    // add profil picture
//    func addProfilPicture() {
//        let dataToSave: [String: Any] = ["Profil": "PHOTO"]
//        self.db.collection("users").document("\(user.uid)").setData(dataToSave, merge: true, completion: { (error) in
//            if let error = error {
//                print("noooooooo \(error.localizedDescription)")
//            }
//        })
//    }
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
}
