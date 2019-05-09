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
    @IBOutlet weak var facebookButton: UIButton!
    
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
            facebookButton.setTitle("Sign In with Facebook", for: .normal)
        // Sign up selected
        case 1:
            usernameTextField.isHidden = false
            rememberCheckBox.isHidden = true
            forgotButton.isHidden = true
            rememberLabel.isHidden = true
            connectButton.setTitle("Sign Up", for: .normal)
            facebookButton.setTitle("Sign Up with Facebook", for: .normal)
        default:
            break
        }
    }
    @IBAction func emailChanged(_ sender: UITextField) {
        // veirfy is email exist
    }
    @IBAction func didTapConnectButton(_ sender: UIButton) {
        connectUsers()
    }
    @IBAction func didTapFacebookConnectButton(_ sender: UIButton) {
    }
    @IBAction func didTapRememberMeButton(_ sender: BEMCheckBox) {
        saveConnexion()
    }
    // Users creation or connexion
    func connectUsers() {
        // create user or connect user
        // if Sign in selected
        if segmented.selectedSegmentIndex == 0 {
            guard let email = emailTextField.text, let password = passwordTextField.text, email.count > 0, password.count > 0 else {
                return
            }
            Auth.auth().signIn(withEmail: email, password: password) { user, error in
                if let _ = error, user == nil {
                    self.alerts(title: "Sing In failed", message: "This email Or/And password doesn't exist")
                }
            }
            // if Sign Up selected
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {
                user, error in
                if error == nil {
                    Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!)
                }
            }
        }
    }
    func saveConnexion() {
        if rememberCheckBox.on == true {
            print("enregister")
        } else {
            return
        }
    }
    
    // alerts
    func alerts(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
