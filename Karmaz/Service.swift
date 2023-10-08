//
//  Service.swift
//  Karmaz
//
//  Created by Наталья Атюкова on 16.08.2023.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth


class Service{
    static let shared = Service()
    init() {}
    
    var alert = AlertManager.shared
    
    func createUser(in viewController: RegViewController, firstName: String, lastName: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                //err code
                AlertManager.showErrorAlert(in: viewController, title: "Ошибка при обращении к БД", message: "Не корректные значения при обращении к FireBase!")
            } else {
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: ["firstName": firstName, "lastName": lastName, "uid": result!.user.uid]) { (error) in
                    if error != nil {
                        //err code
                        AlertManager.showErrorAlert(in: viewController, title: "Регистрация пользователя", message: "Ошибка при регистрации пользователя!")
                    } else {
                        //succes code
                        AlertManager.showErrorAlert(in: viewController, title: "Регистрация пользователя", message: "Ваша регистрация прошла успешно!")
                    }
                    
                }
            }
        }
    }
    

    
    func SignInApp(in viewController: LoginViewController, email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            // Проверка полей на пустое значение
            AlertManager.showErrorAlert(in: viewController, title: "Вход в пользователя", message: "Пожалуйста, заполните все поля!")
            return
        }
        Auth.auth().fetchSignInMethods(forEmail: email) { (methods, error) in //проверка есть ли пользователь в бд
            guard error == nil else {
                // Ошибка при проверке методов входа
                AlertManager.showErrorAlert(in: viewController, title: "Вход в пользователя", message: "Ошибка при проверке методов входа!")
                return
            }
            if let signInMethods = methods, signInMethods.isEmpty {
                // Пользователь с таким email не существует
                AlertManager.showErrorAlert(in: viewController, title: "Вход в пользователя", message: "Пользователь с таким email не существует!")
            } else {
                // Пользователь существует, выполнить вход
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    if error != nil {
                        // Ошибка при входе в систему
                        AlertManager.showErrorAlert(in: viewController, title: "Вход в пользователя", message: "Ошибка при входе в пользователя! Проверьте введенные данные!")
                    } else {
                        // Успешный вход в систему
                        viewController.performSegue(withIdentifier: "goToApp", sender: self)
                    }
                }
            }
        }
    }
    
//    func checkAuthInApp(){
//    }
    
    
    func getUserInfo(completion: @escaping (String?, String?, String?) -> Void) {
        // Проверяем, есть ли текущий пользователь
        if let currentUser = Auth.auth().currentUser {
            // Получаем UID пользователя
            let userID = currentUser.uid
            // Создаем ссылку на коллекцию "users" и фильтруем ее по полю "uid" равному UID пользователя
            let usersRef = Firestore.firestore().collection("users").whereField("uid", isEqualTo: userID)
            // Получаем документы, удовлетворяющие фильтру
            usersRef.getDocuments { (querySnapshot, error) in
                // Проверяем наличие ошибки
                if let error = error {
                    print("Error getting user data: \(error)")
                } else {
                    // Проверяем, есть ли документы
                    if let document = querySnapshot?.documents.first {
                        // Получаем данные из документа
                        let data = document.data()
                        let firstName = data["firstName"] as? String
                        let lastName = data["lastName"] as? String
                        let imageURL = data["imageURL"] as? String
                          completion(firstName, lastName, imageURL)
                          // Выводим приветствие с именем пользователя и ссылкой на изображение
                          print("\(firstName ?? ""), \(lastName ?? ""), \(imageURL ?? "")")
                        
                    } else {
                        // Ошибка при получении данных пользователя
                        print("Привет, Unknown!")
                    }
                }
            }
        }
    }
    
    func uploadImage(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        
        let storageRef = Storage.storage().reference().child("profileImages").child(UUID().uuidString)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("Ошибка при загрузке изображения: \(error.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Ошибка при получении URL загруженного изображения: \(error.localizedDescription)")
                    return
                }
                
                if let downloadURL = url {
                    let imageURLString = downloadURL.absoluteString
                    
                    // Сохраните imageURLString в профиле пользователя или базе данных
                    if let currentUser = Auth.auth().currentUser {
                        let db = Firestore.firestore()
                        let userID = currentUser.uid
                        let userRef = db.collection("users").whereField("uid", isEqualTo: userID).limit(to: 1)
                        
                        userRef.getDocuments { (querySnapshot, error) in
                            if let error = error {
                                print("Ошибка при получении документа пользователя: \(error.localizedDescription)")
                            } else {
                                if let document = querySnapshot?.documents.first {
                                    document.reference.setData(["imageURL": imageURLString], merge: true) { (error) in
                                        if let error = error {
                                            print("Ошибка при сохранении URL изображения: \(error.localizedDescription)")
                                        } else {
                                            print("URL изображения успешно сохранен")
                                            // Дополнительные операции после сохранения изображения
                                        }
                                    }
                                } else {
                                    print("Документ пользователя не найден")
                                    
                                    // Дополнительные операции после сохранения изображения
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getOrderInfo(completion: @escaping (String?, String?, String?, String?) -> Void) {
      
            // Создаем ссылку на коллекцию "orders" и фильтруем ее по полю "uid" равному UID пользователя
            let ordersRef = Firestore.firestore().collection("orders")
            // Получаем документы, удовлетворяющие фильтру
            ordersRef.getDocuments { (querySnapshot, error) in
                // Проверяем наличие ошибки
                if let error = error {
                    print("Error getting orders data: \(error)")
                } else {
                    // Проверяем, есть ли документы
                    if let document = querySnapshot?.documents.first {
                        // Получаем данные из документа
                        let data = document.data()
                        
                        let info = data["info"] as? String
                        let price = data["price"] as? String
                        let recipientCity = data["recipientCity"] as? String
                        let senderCity = data["senderCity"] as? String
                          completion(info, price, recipientCity, senderCity)
                          // Выводим приветствие с именем пользователя и ссылкой на изображение
                          print("\(info ?? ""), \(price ?? ""), \(recipientCity ?? ""), \(senderCity ?? "")")
                        
                    } else {
                        // Ошибка при получении данных пользователя
                        print("Order List is unknown!")
                    }
                }
            }
        }
 
//
            
            
//            
//                func checkAuthInApp(){
//                    Auth.auth().signIn(in viewController: ProfileViewController, withEmail: email, password: password) { result, error in
//                        if error != nil{
//                            //
//                        } else {
//                            if let result = result {
//                                if result.user.isEmailVerified { // проверка на подтверждение почты
//                                    //
//                                } else {
//                                    // self.confirmEmail()
//                                    //
//                                }
//                            }
//                        }
//                    }
//                }
//            
        }
        
        
        
    
