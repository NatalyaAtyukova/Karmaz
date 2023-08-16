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
        // ...
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
