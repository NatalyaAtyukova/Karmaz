    //
    //  LoginViewController.swift
    //  Karmaz
    //
    //  Created by Наталья Атюкова on 31.07.2023.
    //

import UIKit

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //@IBOutlet weak var txtFName: UITextField!
    
    
    
    @IBOutlet weak var loginEmailField: UITextField!
    
    @IBOutlet weak var loginPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    
    @IBAction func btnForReg(_ sender: UIButton) {
        performSegue(withIdentifier: "goToRegister", sender: self
        )
        performSegue(withIdentifier: "goToResetPassword", sender: self
        )
//        //Переход по кнопке
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let regViewController = storyboard.instantiateViewController(identifier: "RegViewController") as? RegViewController else { return }
//        regViewController.modalPresentationStyle = .fullScreen
//        present(regViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func btnLoginApp(_ sender: Any) {
        if (loginEmailField.text?.count == 0){
            let alert = UIAlertController(title: "Oops!", message: "Please enter your Email.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else if (loginPasswordField.text?.count == 0){
            let alert = UIAlertController(title: "Oops!", message: "Please enter your password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            
            //login FB
            
            let email = loginEmailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = loginPasswordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Login(SignIn) User
            
            Auth.auth().signIn(withEmail: email, password: password) {
                (result, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Вход в пользователя", message: "Ошибка при входе в  пользователя!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    print("Login Succes") // Сделать переход в приложение
                }
            }
        }
            
            
        }
        
        
        
        @IBAction func forgotPassword(_ sender: Any) {
            performSegue(withIdentifier: "goToResetPassword", sender: self)
//            //Переход по кнопке
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            guard let resetPassViewController = storyboard.instantiateViewController(identifier: "ResetPassViewController") as? ResetPassViewController else { return }
//            resetPassViewController.modalPresentationStyle = .fullScreen
//            present(resetPassViewController, animated: true, completion: nil)
            
        }
    }
    

    

