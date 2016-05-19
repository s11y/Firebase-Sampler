//
//  LoginViewController.swift
//  SampleFirebase
//
//  Created by ShinokiRyosei on 2016/05/15.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didRegisterUser() {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
