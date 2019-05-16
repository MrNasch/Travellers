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
    
    @IBAction func disconnectButton(_ sender: UIButton) {
        let user = Auth.auth().currentUser!
        let onlineRef = Database.database().reference(withPath: "online/\(user.uid)")
        
        onlineRef.removeValue() { (error, _) in
            
            if let error = error {
                print("removing failed")
                return
            }
            
            do {
                try Auth.auth().signOut()
                self.dismiss(animated: true, completion: nil)
            } catch (let error) {
                print("sign out failed")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let id = FirebaseHelper().connected() {
            // user is connected get user
        } else {
            // no user connected, send back to LoginViewController
            performSegue(withIdentifier: "Log", sender: nil)
        }
    }
}
