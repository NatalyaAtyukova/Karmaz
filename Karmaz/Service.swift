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
            //        Auth.auth().signIn(withEmail: email, password: password) { result, err in
            //            if err != nil{
            //                //
            //            } else {
            //                if let result = result {
            //                    if result.user.isEmailVerified { // проверка на подтверждение почты
            //                        //
            //                    } else {
            //                        // self.confirmEmail()
            //                        //
            //                    }
            //                }
            //            }
            //        }
            //    }
            
        }
        
        
        
    
