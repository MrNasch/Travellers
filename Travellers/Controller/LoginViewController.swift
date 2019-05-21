//
//  LoginViewController.swift
//  Travellers
//
//  Created by Nasch on 02/05/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: KeyboardManagementViewController {


    var user: User?
    var db: Firestore!

    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var LoginView: UIStackView!
    @IBOutlet weak var centerViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var rememberLabel: UILabel!
    @IBOutlet weak var facebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        addTap()
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.performSegue(withIdentifier: "segueToProfil", sender: nil)
            }
        }
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
            forgotButton.isHidden = false
            connectButton.setTitle("Sign In", for: .normal)
            facebookButton.setTitle("Sign In with Facebook", for: .normal)
        // Sign up selected
        case 1:
            usernameTextField.isHidden = false
            forgotButton.isHidden = true
            connectButton.setTitle("Sign Up", for: .normal)
            facebookButton.setTitle("Sign Up with Facebook", for: .normal)
        default:
            break
        }
    }
    // Segue to profil
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToProfil" {
            let tabCtrl = segue.destination as! UITabBarController
            let profilVC = tabCtrl.viewControllers![0] as! ProfileViewController
            profilVC.user = self.user
        }
    }
    @IBAction func emailChanged(_ sender: UITextField) {
        // veirfy is email exist
    }
    @IBAction func didTapConnectButton(_ sender: UIButton) {
        if emailTextField.text!.isEmpty  {
            self.alerts(title: "Connection Failed", message: "Please enter your email adress")
        } else if passwordTextField.text!.isEmpty {
            self.alerts(title: "Connection Failed", message: "Please enter your password")
        } else {
            connectUsers()
        }
    }
    @IBAction func didTapFacebookConnectButton(_ sender: UIButton) {
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
                if let error = error, user == nil {
                    self.alerts(title: "Sing In failed", message: error.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "segueToProfil", sender: nil)
                }
            }
            // if Sign Up selected
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { user, error in
                if error == nil {
                    Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!)
                    guard let emailText = self.emailTextField.text, !emailText.isEmpty else { return }
                    guard let passwordText = self.passwordTextField.text, !passwordText.isEmpty else { return }
                    guard let nameText = self.usernameTextField.text, !nameText.isEmpty else { return }
                    let dataToSave: [String: Any] = ["Email": emailText, "Paswword": passwordText, "Username": nameText]
                    self.db.collection("users").document("\(String(describing: Auth.auth().currentUser?.uid))").setData(dataToSave, completion: { (error) in
                        if let error = error {
                            print("noooooooo \(error.localizedDescription)")
                        } else {
                            print("OK")
                        }
                    })
                    
                    self.performSegue(withIdentifier: "segueToProfil", sender: nil)
                    
                // Throw error if email already exist
                } else {
                    self.alerts(title: "Sign Up Failed", message: error!.localizedDescription)
                } 
            }
        }
    }
    // alerts
    func alerts(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
