//
//  ProfileViewController.swift
//  SampleFirebase
//
//  Created by ShinokiRyosei on 2016/06/22.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var emailLabel: UILabel!
    
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateProfileImageView()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didSelectPlus() {
        self.presentActionSheet()
    }
    
    func presentActionSheet() {
        let alert = UIAlertController(title: "写真を選択", message: "どちらから選択しますか?", preferredStyle: .ActionSheet)
        let library = UIAlertAction(title: "ライブラリ", style: .Default) { (action) in
            self.presentPhotoLibrary()
        }
        
        let camera = UIAlertAction(title: "カメラ", style: .Default) { (action) in
            self.presentCamera()
        }
        
        alert.addAction(library)
        alert.addAction(camera)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func presentPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func presentCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func updateProfileImageView() {
        profileImageView.layer.cornerRadius = profileImageView.layer.bounds.width/2
        profileImageView.layer.masksToBounds = true
    }
}
