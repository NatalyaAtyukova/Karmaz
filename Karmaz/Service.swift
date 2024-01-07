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
    
    var orders: [(orderID: String, info: String?, price: String?, recipientCity: String?, senderCity: String?)] = []
    
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
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController // Изменить идентификатор вашего контроллера в файле storyboard
                        DispatchQueue.main.async { viewController.present(tabBarController, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    
    func getUserInfo(completion: @escaping (String?, String?, String?, String?) -> Void) {
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
                    // Передаем описание ошибки через completion handler
                    completion(nil, nil, nil, error.localizedDescription)
                } else {
                    // Проверяем, есть ли документы
                    if let document = querySnapshot?.documents.first {
                        // Получаем данные из документа
                        let data = document.data()
                        let firstName = data["firstName"] as? String
                        let lastName = data["lastName"] as? String
                        let imageURL = data["imageURL"] as? String
                        // Мы передаем nil в параметр ошибки, потому что ошибки нет
                        completion(firstName, lastName, imageURL, nil)
                    } else {
                        // Ошибка при получении данных пользователя
                        // Мы передаем ошибку через completion handler
                        completion(nil, nil, nil, "Ошибка при получении данных пользователя")
                    }
                }
            }
        } else {
            // Передаем ошибку, если не удается идентифицировать пользователя
            completion(nil, nil, nil, "Пользователь не идентифицирован")
        }
    }
    
    func uploadImage(image: UIImage, completion: @escaping (String?, Error?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            completion(nil, NSError(domain: "app", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось получить данные JPEG из изображения"]))
            return
        }
        
        let storageRef = Storage.storage().reference().child("profileImages").child(UUID().uuidString)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                guard let downloadURL = url else {
                    completion(nil, NSError(domain: "app", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось получить URL изображения"]))
                    return
                }
                
                let imageURLString = downloadURL.absoluteString
                // Сохранить imageURLString в профиль пользователя или базе данных
                if let currentUser = Auth.auth().currentUser {
                    let db = Firestore.firestore()
                    let userRef = db.collection("users").document(currentUser.uid)
                    
                    userRef.setData(["profileImageURL": imageURLString], merge: true) { error in
                        if let error = error {
                            completion(nil, error)
                        } else {
                            // При успешном сохранении URL вызываем completion с URL и без ошибки
                            completion(imageURLString, nil)
                        }
                    }
                } else {
                    completion(nil, NSError(domain: "app", code: -1, userInfo: [NSLocalizedDescriptionKey: "Пользователь не авторизован"]))
                }
            }
        }
    }

    
    func getOrderInfo(completion: @escaping ([(info: String?, price: String?, recipientCity: String?, senderCity: String?)]) -> Void) {
        let ordersRef = Firestore.firestore().collection("orders")
        ordersRef.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error getting orders data: \(error)")
                completion([]) // вызываем completion с пустым массивом при ошибке
            } else {
                if let documents = querySnapshot?.documents {
                    // Очищаем массив перед добавлением новых данных
                    self.orders.removeAll()
                    // Получаем данные из каждого документа и добавляем их в массив
                    for document in documents {
                        let orderID = document.documentID // получение идентификатора документа как orderID
                        let data = document.data()
                        let info = data["info"] as? String
                        let price = data["price"] as? String
                        let recipientCity = data["recipientCity"] as? String
                        let senderCity = data["senderCity"] as? String
                        self.orders.append((orderID: orderID, info: info, price: price, recipientCity: recipientCity, senderCity: senderCity))
                    }
                    // Создаем новый массив с игнорированием orderID и передаем его в completion
                    var result: [(info: String?, price: String?, recipientCity: String?, senderCity: String?)] = []
                    for order in self.orders {
                        let item = (info: order.info, price: order.price, recipientCity: order.recipientCity, senderCity: order.senderCity)
                        result.append(item)
                    }
                    completion(result) // вызываем completion с актуальными данными
                } else {
                    print("Order List is unknown!")
                    completion([]) // вызываем completion с пустым массивом если нет документов
                }
            }
        }
    }

    
    
    func createNewOrder(in viewController: NewOrderViewController, orderInfo: String, orderPrice: String, recipientCity: String, senderCity: String) {
        let orderRef = Firestore.firestore().collection("orders").document()
        let orderData: [String: Any] = [
            "info": orderInfo,
            "price": orderPrice,
            "recipientCity": recipientCity,
            "senderCity": senderCity,
            "uid": Auth.auth().currentUser!.uid,
            "isActive": false
        ]
        
        orderRef.setData(orderData, merge: true) { error in
            if error != nil {
                AlertManager.showErrorAlert(in: viewController, title: "Создание заказа", message: "Не удалось создать заказ")
            } else {
                AlertManager.showErrorAlert(in: viewController, title: "Создание заказа", message: "Заказ успешно создан!")
            }
        }
    }
    
    
    func setActiveStatus(for orderID: String) {
        let orderRef = Firestore.firestore().collection("orders").document(orderID)
        orderRef.updateData(["isActive": true]) { error in
            if let error = error {
                // Обработка ошибки
                print("Не удалось обновить статус заказа: \(error.localizedDescription)")
            } else {
                // Успешное обновление статуса заказа
                print("Статус заказа успешно обновлен")
            }
        }
    }
    
    
}
    




    


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
//        
//        
        
        
    
