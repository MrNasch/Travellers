//
//  KeyboardManagementViewController.swift
//  Travellers
//
//  Created by Nasch on 03/05/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import UIKit

// move view and add observer to Keyboard
class KeyboardManagementViewController: UIViewController {

    var height: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func showKeyboard(notification: Notification) {
        if let KeyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            height = KeyboardHeight
        }
    }
    @objc func hideKeyboard(notification: Notification) {
        
    }
    
    func addTap() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    }
    
    @objc func tap() {
        view.endEditing(true)
    }
    
    // animate
    func animation(_ constant: CGFloat, _ constraint: NSLayoutConstraint) {
        UIView.animate(withDuration: 0.5) {
            constraint.constant = constant
        }
    }
    
    // check heught of view
    func checkHeight(_ view:UIView, constraint: NSLayoutConstraint) {
        let bottom = view.frame.maxY
        let screenHeight = UIScreen.main.bounds.height
        let remain = screenHeight - bottom - 10
        if height > remain {
            let constant = remain - height
            animation(constant, constraint)
        }
    }
}
