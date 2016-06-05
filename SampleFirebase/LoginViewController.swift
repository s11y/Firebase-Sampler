//
//  LoginViewController.swift
//  SampleFirebase
//
//  Created by ShinokiRyosei on 2016/05/15.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import Firebase //Firebaseをインポート

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailTextField: UITextField! // Emailを打つためのTextField
    
    @IBOutlet var passwordTextField: UITextField! //Passwordを打つためのTextField


    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self //デリゲートをセット
        passwordTextField.delegate = self //デリゲートをセット
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //ログインボタン
    @IBAction func didRegisterUser() {
        //ログインのためのメソッド
        login()
    }
    //Returnキーを押すと、キーボードを隠す
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //ログインのためのメソッド
    func login() {
        //EmailとPasswordのTextFieldに文字がなければ、その後の処理をしない
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        //signInWithEmailでログイン
        //第一引数にEmail、第二引数にパスワードを取ります
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            //エラーなしなら、ログイン完了
            if error == nil{
                print(FIRAuth.auth()?.currentUser)
                self.transitionToView()
            }else {
                print("error...\(error?.localizedDescription)")
            }
        })
    }
    //ログイン完了後に、ListViewControllerへの遷移のためのメソッド
    func transitionToView()  {
        self.performSegueWithIdentifier("toVC", sender: self)
    }
}
