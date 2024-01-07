//
//  ProfileViewController.swift
//  Karmaz
//
//  Created by Наталья Атюкова on 20.08.2023.
//

import UIKit
import FirebaseAuth


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
    var service = Service.shared
    var alert = AlertManager.shared
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service.getUserInfo { (firstName, lastName, imageURL, error) in
            if let error = error {
                // Обрабатываем ошибку: показываем ее в пользовательском интерфейсе
                print(error) // или используйте другой способ сообщения об ошибке пользователю
            } else {
                // Обрабатываем правильные данные
                self.displayUserData(firstName: firstName, lastName: lastName, imageURL: imageURL)
            }
        }

        
        imagePicker.delegate = self
    }
    
    func displayUserData(firstName: String?, lastName: String?, imageURL: String?) {
        if let firstName = firstName, let lastName = lastName, let imageURL = imageURL, let url = URL(string: imageURL) {
            // Асинхронно загружаем изображение по URL
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    // Обновляем изображение в главном потоке
                    DispatchQueue.main.async {
                        self?.profileImageView.image = image
                    }
                }
            }
            
            // Обновляем имя пользователя
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
    
    
    
    @IBAction func goToNewOrder(_ sender: UIButton) {
        performSegue(withIdentifier: "goToCreateNewOrder", sender: self)
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            
            // Создайте экземпляр LoginViewController из сториборда
            if let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                
                // Получите экземпляр навигационного контроллера, если у вас используется
                if let navigationController = self.navigationController {
                    // Выполните переход на экран LoginViewController
                    navigationController.setViewControllers([loginViewController], animated: true)
                } else {
                    // Если у вас не используется навигационный контроллер, то выполните простой модальный переход
                    self.present(loginViewController, animated: true, completion: nil)
                }
            }
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }


        


    
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            profileImageView.image = image
            service.uploadImage(image: image) { imageURLString, error in
               if let error = error {
                   AlertManager.showErrorAlert(in: self, title: "Ошибка", message: "Не удалось загрузить изображение. Пожалуйста, попробуйте еще раз. Ошибка: \(error.localizedDescription)")
               } else if let imageURLString = imageURLString {
                   AlertManager.showErrorAlert(in: self, title: "Загружено", message: "Изображение успешно загружено. URL: \(imageURLString)")
               }
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
   
    
 
    
    
    
    
    
    
    
    }

    
