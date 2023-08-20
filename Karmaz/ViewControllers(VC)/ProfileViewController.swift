//
//  ProfileViewController.swift
//  Karmaz
//
//  Created by Наталья Атюкова on 20.08.2023.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
 

    @IBOutlet weak var profilePhoto: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func loadPhotoButtonTapped(_ sender: UIButton) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                profilePhoto.image = selectedImage
            }
            dismiss(animated: true, completion: nil)
        }

    
    @IBAction func startJob(_ sender: Any) {
    }
    
}
