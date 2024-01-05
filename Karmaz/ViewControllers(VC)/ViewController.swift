//
//  ViewController.swift
//  Karmaz
//
//  Created by Наталья Атюкова on 31.07.2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ViewController: UIViewController {
    
    var listenAuth = FirebaseAuth.Auth.auth().addStateDidChangeListener { auth, user in
        if let user = user {
            // Пользователь вошел в систему
            print("User is signed in with uid:", user.uid)
            
            // Загружаем UITabBarController из storyboard (должен включать ProfileViewController)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController {
                
                // Рассмотрим возможность настройки ProfileViewController, если это необходимо
                
                // Устанавливаем tabBarController в качестве корневого контроллера окна
                if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                    window.rootViewController = tabBarController
                }
                
            }
        } else {
            // Пользователь не вошел в систему
            print("No user is signed in.")
            
            // Отображаем экран аутентификации
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let loginController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                    window.rootViewController = loginController
                }
            }
        }

    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func startButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let loginViewController = storyboard.instantiateViewController(identifier: "LoginViewController") as? LoginViewController else { return }
        loginViewController.modalPresentationStyle = .fullScreen
        present(loginViewController, animated: true, completion: nil)
    }
    
    func endListenAuth() {
        Auth.auth().removeStateDidChangeListener(listenAuth)
    }
}
