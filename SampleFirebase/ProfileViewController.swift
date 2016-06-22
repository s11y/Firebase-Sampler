//
//  ProfileViewController.swift
//  SampleFirebase
//
//  Created by ShinokiRyosei on 2016/06/22.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var emailLabel: UILabel!
    
    var imagePicker: UIImagePickerController!
    
    let ref = FIRStorage.storage().reference()
    
    var uploadImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateProfileImageView()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.read()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didSelectPlus() {
        self.presentActionSheet()
    }
    
    @IBAction func didSelectLogout() {
        self.logout()
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
    
    func create(uploadImage image: UIImage) {
        let uploadData: NSData = UIImagePNGRepresentation(image)!
        ref.child((FIRAuth.auth()?.currentUser?.uid)!).putData(uploadData, metadata: nil) { (data, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
            }else {
                
            }
        }
    }
    
    func read() {
        let gsReference = FIRStorage.storage().referenceForURL("gs://sampledrud.appspot.com")
        gsReference.child((FIRAuth.auth()?.currentUser?.uid)!).dataWithMaxSize(1 * 1028 * 1028) { (data, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
            }else {
                self.uploadImage = UIImage(data: data!)
                self.profileImageView.image = self.uploadImage
            }
        }
    }
    
    func changeEmail() {
        
    }
    
    func changePassword() {
        
    }
    
    func exitFromService() {
        
    }
    
    func logout() {
        do {
            //do-try-catchの中で、FIRAuth.auth()?.signOut()を呼ぶだけで、ログアウトが完了
            try FIRAuth.auth()?.signOut()
            
            //先頭のNavigationControllerに遷移
            let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Nav")
            self.presentViewController(storyboard, animated: true, completion: nil)
        }catch let error as NSError {
            print("\(error.localizedDescription)")
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            uploadImage = image
            profileImageView.image = uploadImage
            self.create(uploadImage: uploadImage)
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func updateProfileImageView() {
        profileImageView.layer.cornerRadius = profileImageView.layer.bounds.width/2
        profileImageView.layer.masksToBounds = true
    }
}
