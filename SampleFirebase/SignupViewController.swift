//
//  SignupViewController.swift
//  SampleFirebase
//
//  Created by ShinokiRyosei on 2016/05/19.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import Firebase //Firebaseをインポート
import FBSDKLoginKit
import TwitterKit
import FontAwesome_swift

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailTextField: UITextField! // Emailを打つためのTextField
    
    @IBOutlet var passwordTextField: UITextField! //Passwordを打つためのTextField
    
    @IBOutlet var facebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self //デリゲートをセット
        passwordTextField.delegate = self //デリゲートをセット
        passwordTextField.secureTextEntry = true // 文字を非表示に
        
        self.layoutFacebookButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //ログインしていれば、遷移
        //FIRAuthがユーザー認証のためのフレーム
        //checkUserVerifyでチェックして、ログイン済みなら画面遷移
        if self.checkUserVerify() {
            self.transitionToView()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            //エラーなしなら、認証完了
            if error == nil{
                // メールのバリデーションを行う
                user?.sendEmailVerificationWithCompletion({ (error) in
                    if error == nil {
                        // エラーがない場合にはそのままログイン画面に飛び、ログインしてもらう
                        self.transitionToLogin()
                    }else {
                        print("\(error?.localizedDescription)")
                    }
                })
            }else {
                
                print("\(error?.localizedDescription)")
            }
        })
    }
    // Facebookでユーザー認証するためのメソッド
    func loginWithFacebook() {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logInWithReadPermissions(["email", "public_profile"], fromViewController: self) { (facebookResult, facebookError) in
            if facebookError != nil {
                print(facebookError.localizedDescription)
            }else if facebookResult.isCancelled {
                print("facebook login was cancelled")
            }else {
                print("else is processed")
                let credial: FIRAuthCredential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                print(FBSDKAccessToken.currentAccessToken().tokenString)
                print("credial...\(credial)")
                self.firebaseLoginWithCredial(credial)
            }
        }
    }
    
    @IBAction func loginWithTwitter(sender: TWTRLogInButton) {
        sender.logInCompletion = { (session: TWTRSession?, err: NSError?) in
            if let session = session {
                let credential = FIRTwitterAuthProvider.credentialWithToken(session.authToken, secret: session.authTokenSecret)
                
                FIRAuth.auth()?.signInWithCredential(credential, completion: { (user, error) in
                    if let err = error {
                        print(err)
                        return
                    }
                })
            }
        }
    }
    
    func firebaseLoginWithCredial(credial: FIRAuthCredential) {
        if FIRAuth.auth()?.currentUser != nil {
            print("current user is not nil")
            FIRAuth.auth()?.currentUser?.linkWithCredential(credial, completion: { (user, error) in
                if error != nil {
                    print("error happens")
                    print("error reason...\(error!.localizedFailureReason)")
                }else {
                    print("sign in with credential")
                    FIRAuth.auth()?.signInWithCredential(credial, completion: { (user, error) in
                        if error != nil {
                            print(error?.localizedDescription)
                        }else {
                            print("Logged in")
                        }
                    })
                }
            })
        }else {
            print("current user is nil")
            FIRAuth.auth()?.signInWithCredential(credial, completion: { (user, error) in
                if error != nil {
                    print(error!.localizedFailureReason)
                }else {
                    print("Logged in")
                }
            })
        }
    }
    // ログイン済みかどうかと、メールのバリデーションが完了しているか確認
    func checkUserVerify()  -> Bool {
        guard let user = FIRAuth.auth()?.currentUser else { return false }
        return user.emailVerified
    }
    
    //ログイン画面への遷移
    func transitionToLogin() {
        self.performSegueWithIdentifier("toLogin", sender: self)
    }
    //ListViewControllerへの遷移
    func transitionToView() {
        self.performSegueWithIdentifier("toView", sender: self)
    }
    //Returnキーを押すと、キーボードを隠す
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func layoutFacebookButton() {
        facebookButton.setTitle(String.fontAwesomeIconWithName(.FacebookSquare), forState: .Normal)
        facebookButton.titleLabel?.font = UIFont.fontAwesomeOfSize(24)
    }
}
