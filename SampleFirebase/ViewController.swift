//
//  ViewController.swift
//  SampleFirebase
//
//  Created by ShinokiRyosei on 2016/02/22.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {
    
    let ref = FIRDatabase.database().reference()
    @IBOutlet var label: UILabel!
    @IBOutlet var textField: UITextField!

    var selectedSnap: FIRDataSnapshot!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.layer.borderColor = ColorManager.mainColor.CGColor
        textField.delegate = self

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        guard let snap = self.selectedSnap else { return }
        let item = snap.value as! Dictionary<String, AnyObject>
        textField.text = item["content"] as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func post(sender: UIButton) {
        create()
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    private func create() {
        guard let text = textField.text else { return }
        self.ref.child((FIRAuth.auth()?.currentUser?.uid)!).childByAutoId().setValue(["user": (FIRAuth.auth()?.currentUser?.uid)!,"content": text, "date": FIRServerValue.timestamp()])
    }
    
    @IBAction func didSelectLogout() {
        logout()
    }
    
    private func logout() {
        do {
            try FIRAuth.auth()?.signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Nav")
            self.presentViewController(storyboard, animated: true, completion: nil)
        }catch let error as NSError {
            print("\(error.localizedDescription)")
        }
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getDate() -> String {
        let now = NSDate()
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP")
        formatter.dateStyle = .FullStyle
        return formatter.stringFromDate(now)
    }
}

