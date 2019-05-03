//
//  LoginViewController.swift
//  Travellers
//
//  Created by Nasch on 02/05/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import UIKit
import BEMCheckBox
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var rememberCheckBox: BEMCheckBox!
    @IBOutlet weak var forgotButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // hide username if Sign in segmented selected
    @IBAction func didTapSegmented(_ sender: UISegmentedControl) {
        switch segmented.selectedSegmentIndex {
        // Sign in selected
        case 0:
            usernameTextField.isHidden = true
        // Sign up selected
        case 1:
            usernameTextField.isHidden = false
        default:
            break
        }
    }
    @IBAction func didTapConnectButton(_ sender: UIButton) {
    }
    @IBAction func didTapFacebookConnectButton(_ sender: UIButton) {
    }
    @IBAction func didTapRememberMeButton(_ sender: BEMCheckBox) {
        saveConnexion()
    }
    func saveConnexion() {
        if rememberCheckBox.on == true {
            print("enregister")
        } else {
            return
        }
    }
}
