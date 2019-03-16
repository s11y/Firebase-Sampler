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
    
    let ref = Storage.storage().reference()
    
    var uploadImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateProfileImageView()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.read()
    }
    
    @IBAction func didSelectPlus() {
        self.presentActionSheet()
    }
    
    @IBAction func didSelectLogout() {
        self.logout()
    }
    
    func presentActionSheet() {
        let alert = UIAlertController(title: "写真を選択", message: "どちらから選択しますか?", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "ライブラリ", style: .default) { (action) in
            self.presentPhotoLibrary()
        }
        
        let camera = UIAlertAction(title: "カメラ", style: .default) { (action) in
            self.presentCamera()
        }
        
        alert.addAction(library)
        alert.addAction(camera)
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func presentCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func create(uploadImage image: UIImage) {
        let uploadData: Data = image.pngData()!
        ref.child((Auth.auth().currentUser?.uid)!).putData(uploadData, metadata: nil) { (data, error) in
            if error != nil {
                print("\(String(describing: error?.localizedDescription))")
            }else {
                
            }
        }
    }
    
    func read() {
        let gsReference = Storage.storage().reference(forURL: "gs://sampledrud.appspot.com")
        gsReference.child((Auth.auth().currentUser?.uid)!).getData(maxSize: 1 * 1028 * 1028) { (data, error) in
            if error != nil {
                print("\(String(describing: error?.localizedDescription))")
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
            try Auth.auth().signOut()
            
            //先頭のNavigationControllerに遷移
            let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Nav")
            self.present(storyboard, animated: true, completion: nil)
        } catch let error as NSError {
            print("\(error.localizedDescription)")
        }
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image: UIImage = info[.originalImage] as? UIImage {

            uploadImage = image
            profileImageView.image = uploadImage
            self.create(uploadImage: uploadImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func updateProfileImageView() {
        profileImageView.layer.cornerRadius = profileImageView.layer.bounds.width/2
        profileImageView.layer.masksToBounds = true
    }
}
