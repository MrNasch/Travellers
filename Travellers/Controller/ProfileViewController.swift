//
//  ProfileViewController.swift
//  Travellers
//
//  Created by Nasch on 03/05/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var user: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUser()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let id = FirebaseHelper().connected() {
            // user is connected get user
        } else {
            // no user connected, send back to LoginViewController
            performSegue(withIdentifier: "Log", sender: nil)
        }
    }
    
    // checking if user
    func checkUser() {
        if user != nil {
            // stay
            performSegue(withIdentifier: "SignIn", sender: user!)
        } else {
            //go to login
            performSegue(withIdentifier: "Log", sender: nil)
        }
    }
}
