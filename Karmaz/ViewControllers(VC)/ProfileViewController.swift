//
//  ProfileViewController.swift
//  Karmaz
//
//  Created by Наталья Атюкова on 16.08.2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Добавьте обработчик нажатия на изображение профиля
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectProfileImage))
            profileImageView.addGestureRecognizer(tapGestureRecognizer)
            profileImageView.isUserInteractionEnabled = true
    }

    
    // Обработка загрузки фото профиля через селфи
    
    @objc func selectProfileImage() {
          let imagePickerController = UIImagePickerController()
          imagePickerController.delegate = self
          imagePickerController.allowsEditing = true
          imagePickerController.sourceType = .camera
          present(imagePickerController, animated: true, completion: nil)
      }

      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
              profileImageView.image = image
          } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
              profileImageView.image = image
          }
          dismiss(animated: true, completion: nil)
      }

      func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
          dismiss(animated: true, completion: nil)
      }
    
    @IBAction func uploadAvatar(_ sender: Any) {
        selectProfileImage()
    }
    
    
    @IBAction func btnGoToOrder(_ sender: Any) {
        performSegue(withIdentifier: "goToOrder", sender: self
        )
    }
    
    
    
}
