//
//  SignupViewController.swift
//  SampleFirebase
//
//  Created by ShinokiRyosei on 2016/05/19.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var usernameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func willSignup() {
        signup()
    }
    
    @IBAction func willTransitionToLogin() {
        
    }
    
    private func signup() {
        guard let email = emailTextField.text else  { return }
        guard let password = passwordTextField.text else { return }
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            if error != nil {
                self.transitionToView()
            }else {
                print("\(error?.localizedDescription)")
            }
        })
    }
    
    func transitionToView() {
        self.performSegueWithIdentifier("toView", sender: self)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}