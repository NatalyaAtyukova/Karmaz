    //
    //  LoginViewController.swift
    //  Karmaz
    //
    //  Created by Наталья Атюкова on 31.07.2023.
    //

import UIKit


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var service = Service.shared
    
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
    }
    
    
    @IBAction func btnLoginApp(_ sender: Any) {
        
        //login FB
        
        let email = loginEmailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = loginPasswordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Login(SignIn) User
        service.SignInApp(in: self, email: email, password: password)

    }
 


        
        @IBAction func forgotPassword(_ sender: Any) {
            performSegue(withIdentifier: "goToResetPassword", sender: self)
        }
    }
    

    

