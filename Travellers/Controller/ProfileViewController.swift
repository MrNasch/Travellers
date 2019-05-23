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
    
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if FirebaseHelper().connected() != nil {
            // user is connected get user
            
            let user = Auth.auth().currentUser
            if let user = user {
                print("\(String(describing: user.uid))")
                
                let docRef = db.collection("users").document("\(user.uid)")
                docRef.getDocument { (document, error) in
                    guard let document = document, document.exists else { return }
                    let dataDescription = document.data()
                    let username = dataDescription!["Username"] as? String ?? ""
                    self.firstName.text = username
                    print("Document data: \(String(describing: dataDescription))")
                }
            }
        } else {
            // no user connected, send back to LoginViewController
            performSegue(withIdentifier: "Log", sender: nil)
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
}
