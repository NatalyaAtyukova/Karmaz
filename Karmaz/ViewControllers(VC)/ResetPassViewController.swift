//
//  ResetPassViewController.swift
//  Karmaz
//
//  Created by Наталья Атюкова on 02.08.2023.
//

import UIKit
import FirebaseAuth

class ResetPassViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func backToLoginVC(_ sender: Any) {
        performSegue(withIdentifier: "resetpassBackToLoginVC", sender: self
        )
    }
    

        
    @IBAction func btnResetPassword(_ sender: Any) {
    
            let email = emailField.text!
            
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if error != nil {
                    let alert = UIAlertController(title: "Сброс пароля", message: "Ошибка. Не корректный Email", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Сброс пароля", message: "Ссылка для восстановления, отправлена на вашу электронную почту!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                }
            }
            }
        }
        
    
