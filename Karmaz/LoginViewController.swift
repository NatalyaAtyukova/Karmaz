    //
    //  LoginViewController.swift
    //  Karmaz
    //
    //  Created by Наталья Атюкова on 31.07.2023.
    //

    import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //@IBOutlet weak var txtFName: UITextField!
    
    @IBOutlet weak var loginPhoneNumber: UITextField!
    
    @IBOutlet weak var loginPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Установите делегата loginPhoneNumber в self
        loginPhoneNumber.delegate = self
        // Установка значения по умолчанию для поля loginPhoneNumber
        loginPhoneNumber.text = "+7"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Get the current text in the text field
        guard let currentText = textField.text else {
            return true
        }
        
        // Check if the new text will exceed the character limit
        let newLength = currentText.count + string.count - range.length
        return newLength <= 12
    }
    
    
    @IBAction func btnForReg(_ sender: UIButton) {
        
        //Переход по кнопке
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let regViewController = storyboard.instantiateViewController(identifier: "RegViewController") as? RegViewController else { return }
        regViewController.modalPresentationStyle = .fullScreen
        present(regViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func btnLoginApp(_ sender: Any) {
    
    if (loginPhoneNumber.text?.count == 0){
        let alert = UIAlertController(title: "Oops!", message: "Please enter your phone id.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    } else if !isValidPhoneNumber(testStr:loginPhoneNumber.text!){
        let alert = UIAlertController(title: "Oops!", message: "Please enter your correct phone id.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
        //Валидация телефона
        func isValidPhoneNumber(testStr:String) -> Bool {
            let phoneRegEx = "^\\+7\\d{10}$"
            
            let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
            let result = phoneTest.evaluate(with: testStr)
            return result
        }
    }
}
    

