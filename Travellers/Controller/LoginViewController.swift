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

class LoginViewController: KeyboardManagementViewController {

    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var rememberCheckBox: BEMCheckBox!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var LoginView: UIStackView!
    @IBOutlet weak var centerViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var rememberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTap()
    }
    override func showKeyboard(notification: Notification) {
        super.showKeyboard(notification: notification)
        checkHeight(LoginView, constraint: centerViewConstraint)
    }
    override func hideKeyboard(notification: Notification) {
        super.hideKeyboard(notification: notification)
        animation(0, centerViewConstraint)
    }
    
    // hide username if Sign in segmented selected
    @IBAction func didTapSegmented(_ sender: UISegmentedControl) {
        switch segmented.selectedSegmentIndex {
        // Sign in selected
        case 0:
            usernameTextField.isHidden = true
            rememberCheckBox.isHidden = false
            forgotButton.isHidden = false
            rememberLabel.isHidden = false
            connectButton.setTitle("Sign In", for: .normal)
        // Sign up selected
        case 1:
            usernameTextField.isHidden = false
            rememberCheckBox.isHidden = true
            forgotButton.isHidden = true
            rememberLabel.isHidden = true
            connectButton.setTitle("Sign Up", for: .normal)
        default:
            break
        }
    }
    @IBAction func emailChanged(_ sender: UITextField) {
        // veirfy is email exist
    }
    @IBAction func didTapConnectButton(_ sender: UIButton) {
        // create user or connect user
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
