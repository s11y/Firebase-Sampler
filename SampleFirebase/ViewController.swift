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
    
    let firebase = Firebase(url: "https://samplecrud.firebaseio.com")
    @IBOutlet var label: UILabel!
    @IBOutlet var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        textField.layer.borderColor = ColorManager.mainColor.CGColor
        textField.delegate = self
//        firebase.setValue(" Fire CRUD")

        firebase.observeEventType(.Value, withBlock: { snapShot in
            if let object = snapShot {
                print("\(object)")
                self.label.text = String(object)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func post(sender: UIButton) {
        if let object = textField.text {
            let postData = Data(createdAt: getDate(), content: NSString(UTF8String: object)!)
            firebase.childByAutoId().setValue(["postData": self.getDate(), "content": NSString(UTF8String: object)!])
        }
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getDate() -> NSString {
        let now = NSDate()
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP")
        formatter.dateStyle = .FullStyle
        return NSString(string: formatter.stringFromDate(now))
    }


}

