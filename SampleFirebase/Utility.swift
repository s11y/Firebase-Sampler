//
//  Utility.swift
//  SampleFirebase
//
//  Created by ShinokiRyosei on 2016/07/23.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit

class Utility: NSObject {
    func showAlert(title: String, message: String, onViewController viewcontroller: UIViewController, buttonTitle button: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: button, style: .Default, handler: nil)
        alert.addAction(defaultAction)
        viewcontroller.presentViewController(alert, animated: true, completion: nil)
    }
}
