//
//  ResetPassViewController.swift
//  Karmaz
//
//  Created by Наталья Атюкова on 02.08.2023.
//

import UIKit

class ResetPassViewController: UIViewController, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var resetNewPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    

        
        func btnResetPassword(_ sender: Any) {
            if (resetNewPassword.text?.count == 0){
                let alert = UIAlertController(title: "Oops!", message: "Please enter your password.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
        
    }
