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
                        viewController.performSegue(withIdentifier: "goToProfile", sender: self)
                    }
                }
            }
        }
    }
    
//    func checkAuthInApp(){
//    }
    
    
    func getUserInfo(completion: @escaping (String?, String?) -> Void) {
        if let user = Auth.auth().currentUser {
            let db = Firestore.firestore()
            let uid = user.uid

            // Получаем ссылку на документ пользователя в Firestore
            let userRef = db.collection("users").document("rUmL4wcykX1uKXoq0QNV") //uid конкретного пользователя "rUmL4wcykX1uKXoq0QNV"

            // Получаем данные пользователя из Firestore
            userRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    let firstName = data?["firstName"] as? String
                    let lastName = data?["lastName"] as? String
                    
                    completion(firstName, lastName)

                    // Выводим приветствие с именем пользователя
                    print("\(firstName ?? ""), \(lastName ?? "")")
                    
                } else {
                    // Ошибка при получении данных пользователя
                    print("Привет, Unknown!")
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
        
        
        
    
