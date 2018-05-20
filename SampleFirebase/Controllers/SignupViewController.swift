//
//  SignupViewController.swift
//  SampleFirebase
//
//  Created by ShinokiRyosei on 2016/05/19.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import Firebase //Firebaseをインポート
import FirebaseAuth
import FBSDKLoginKit
import TwitterKit
import FontAwesome_swift

class SignupViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField! // Emailを打つためのTextField
    
    @IBOutlet var passwordTextField: UITextField! //Passwordを打つためのTextField
    
    @IBOutlet var facebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self //デリゲートをセット
        passwordTextField.delegate = self //デリゲートをセット
        passwordTextField.isSecureTextEntry = true // 文字を非表示に
        
        self.layoutFacebookButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //ログインしていれば、遷移
        //FIRAuthがユーザー認証のためのフレーム
        //checkUserVerifyでチェックして、ログイン済みなら画面遷移
        if self.checkUserVerify() {
            self.transitionToView()
        }
    }

    //サインアップボタン
    @IBAction func willSignup() {
        //サインアップのための関数
        signup()
    }
    //ログイン画面への遷移ボタン
    @IBAction func willTransitionToLogin() {
        transitionToLogin()
    }
    
    @IBAction func willLoginWithFacebook() {
        self.loginWithFacebook()
    }
    //Signupのためのメソッド
    func signup() {
        //emailTextFieldとpasswordTextFieldに文字がなければ、その後の処理をしない
        guard let email = emailTextField.text else  { return }
        guard let password = passwordTextField.text else { return }
        //FIRAuth.auth()?.createUserWithEmailでサインアップ
        //第一引数にEmail、第二引数にパスワード
        Auth.auth().createUser(withEmail: email, password: password, completion: { (authResult, error) in
            //エラーなしなら、認証完了
            if error == nil{
                // メールのバリデーションを行う
                authResult?.user.sendEmailVerification(completion: { (error) in
                    if error == nil {
                        // エラーがない場合にはそのままログイン画面に飛び、ログインしてもらう
                        self.transitionToLogin()
                    }else {
                        print("\(String(describing: error?.localizedDescription))")
                    }
                })
            }else {
                
                print("\(String(describing: error?.localizedDescription))")
            }
        })
    }
    // Facebookでユーザー認証するためのメソッド
    func loginWithFacebook() {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email", "public_profile"], from: self) { (facebookResult, facebookError) in
            if facebookError != nil {
                print("\(String(describing: facebookError?.localizedDescription))")
            }else if (facebookResult?.isCancelled)! {
                print("facebook login was cancelled")
            }else {
                print("else is processed")
                let credial: AuthCredential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                print(FBSDKAccessToken.current().tokenString)
                print("credial...\(credial)")
                self.firebaseLoginWithCredial(credial)
            }
        }
    }
    
    @IBAction func loginWithTwitter(_ sender: TWTRLogInButton) {
        sender.logInCompletion = { (session: TWTRSession?, err: NSError?) in
            if let session = session {
                let credential = TwitterAuthProvider.credential(withToken: session.authToken, secret: session.authTokenSecret)
                Auth.auth().signInAndRetrieveData(with: credential, completion: { dataResult, error in
                    if let err = error {
                        print(err)
                        return
                    }
                })
            }
        } as! TWTRLogInCompletion
    }
    
    func firebaseLoginWithCredial(_ credial: AuthCredential) {
        if Auth.auth().currentUser != nil {
            print("current user is not nil")
            Auth.auth().currentUser?.linkAndRetrieveData(with: credial, completion: { dataResult, error in
                if error != nil {
                    print("error happens")
                    print("error reason...\(String(describing: error))")
                }else {
                    print("sign in with credential")
                    Auth.auth().signInAndRetrieveData(with: credial, completion: { dataResult, error in
                        if error != nil {
                            print("\(String(describing: error?.localizedDescription))")
                        }else {
                            print("Logged in")
                        }
                    })
                }
            })
        }else {
            print("current user is nil")
            Auth.auth().signInAndRetrieveData(with: credial) { dataResult, error in
                if error != nil {
                    print("\(String(describing: error))")
                }else {
                    print("Logged in")
                }
            }
        }
    }
    // ログイン済みかどうかと、メールのバリデーションが完了しているか確認
    func checkUserVerify()  -> Bool {
        guard let user = Auth.auth().currentUser else { return false }
        return user.isEmailVerified
    }
    
    //ログイン画面への遷移
    func transitionToLogin() {
        self.performSegue(withIdentifier: "toLogin", sender: self)
    }
    //ListViewControllerへの遷移
    func transitionToView() {
        self.performSegue(withIdentifier: "toView", sender: self)
    }
    
    func layoutFacebookButton() {
        facebookButton.setTitle(String.fontAwesomeIcon(name: .facebookSquare), for: .normal)
        facebookButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 24)
    }
}


extension SignupViewController: UITextFieldDelegate {
    
    //Returnキーを押すと、キーボードを隠す
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
