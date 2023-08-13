    //
    //  LoginViewController.swift
    //  Karmaz
    //
    //  Created by Наталья Атюкова on 31.07.2023.
    //

    import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //@IBOutlet weak var txtFName: UITextField!
    

    
    @IBOutlet weak var loginPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    
    
    @IBAction func btnForReg(_ sender: UIButton) {
        
        //Переход по кнопке
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let regViewController = storyboard.instantiateViewController(identifier: "RegViewController") as? RegViewController else { return }
        regViewController.modalPresentationStyle = .fullScreen
        present(regViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func btnLoginApp(_ sender: Any) {
        if (loginPasswordField.text?.count == 0){
            let alert = UIAlertController(title: "Oops!", message: "Please enter your password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
        
     
    
    @IBAction func forgotPassword(_ sender: Any) {
    
    //Переход по кнопке
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    guard let resetPassViewController = storyboard.instantiateViewController(identifier: "ResetPassViewController") as? ResetPassViewController else { return }
        resetPassViewController.modalPresentationStyle = .fullScreen
    present(resetPassViewController, animated: true, completion: nil)
    
    }
}


    

