//
//  ProfileViewController.swift
//  Karmaz
//
//  Created by Наталья Атюкова on 20.08.2023.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
   
    var service = Service.shared
 

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service.getUserInfo { [weak self] firstName, lastName in
            // Передача данных в функцию displayUserData
            self?.displayUserData(firstName: firstName, lastName: lastName)
        }
        imagePicker.delegate = self
    }
    
    func displayUserData(firstName: String?, lastName: String?) {
        if let firstName = firstName, let lastName = lastName {
            DispatchQueue.main.async { [weak self] in
                self?.nameLabel.text = "Привет, \(firstName) \(lastName)!"
            }
        }
    }

    let imagePicker = UIImagePickerController()

    @IBAction func choosePhotoButtonTapped(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
        imagePicker.sourceType = .photoLibrary
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            profileImageView.image = image
            service.uploadImage(image: image)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startJob(_ sender: Any) {
    }
    
 
    }

    
