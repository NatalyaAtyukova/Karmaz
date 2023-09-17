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


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    var service = Service.shared
 

//--------UIImageController
    
    @IBOutlet weak var nameLabel: UILabel!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service.getUserInfo { [weak self] firstName, lastName in
            // Передача данных в функцию displayUserData
            self?.displayUserData(firstName: firstName, lastName: lastName)
        }
    }
    
    func displayUserData(firstName: String?, lastName: String?) {
        if let firstName = firstName, let lastName = lastName {
            DispatchQueue.main.async { [weak self] in
                self?.nameLabel.text = "Привет, \(firstName) \(lastName)!"
            }
        }
    }


    @IBAction func choosePhoto(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
               imagePickerController.delegate = self
               
               let actionSheet = UIAlertController(title: "Выберите фото", message: nil, preferredStyle: .actionSheet)
               
               actionSheet.addAction(UIAlertAction(title: "Камера", style: .default, handler: { (action:UIAlertAction) in
                   if UIImagePickerController.isSourceTypeAvailable(.camera) {
                       imagePickerController.sourceType = .camera
                       self.present(imagePickerController, animated: true, completion: nil)
                   } else {
                       print("Камера не доступна")
                   }
               }))
               
               actionSheet.addAction(UIAlertAction(title: "Фотоальбом", style: .default, handler: { (action:UIAlertAction) in
                   imagePickerController.sourceType = .photoLibrary
                   self.present(imagePickerController, animated: true, completion: nil)
               }))
               
               actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
               
               self.present(actionSheet, animated: true, completion: nil)
           }
           
           func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
               picker.dismiss(animated: true, completion: nil)
               
               guard info[UIImagePickerController.InfoKey.originalImage] is UIImage else {
                   return
               }
               
             //  imageView.image = image
           }
           
           func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
               picker.dismiss(animated: true, completion: nil)
           }


    
    //fname lmane fb
   



    
    @IBAction func startJob(_ sender: Any) {
    }
    
}
