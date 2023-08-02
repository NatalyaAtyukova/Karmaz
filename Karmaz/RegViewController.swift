//
//  RegViewController.swift
//  Karmaz
//
//  Created by Наталья Атюкова on 31.07.2023.
//

import UIKit
import PhoneNumberKit

class RegViewController: UIViewController, UITextFieldDelegate {
    
    
    
    //@IBOutlet weak var txtFName: UITextField!
    
    @IBOutlet weak var txtFName: UITextField!
    
    @IBOutlet weak var txtLName: UITextField!
    
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Установите делегата txtPhoneNumber в self
        txtPhoneNumber.delegate = self
        // Установка значения по умолчанию для поля txtPhoneNumber
        txtPhoneNumber.text = "+7"
        
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

    
    //@IBAction func btnRegistration(sender: AnyObject)
    
    @IBAction func btnRegistration(_ sender: Any) {
        if(txtFName.text?.count == 0){
            let alert = UIAlertController(title: "Oops!", message: "Please enter your first name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else if (txtLName.text?.count == 0){
            let alert = UIAlertController(title: "Oops!", message: "Please enter your last name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            //*
        } else if (txtPhoneNumber.text?.count == 0){
            let alert = UIAlertController(title: "Oops!", message: "Please enter your phone id.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else if !isValidPhoneNumber(testStr:txtPhoneNumber.text!){
            let alert = UIAlertController(title: "Oops!", message: "Please enter your correct phone id.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            //*
        } else if (txtPassword.text?.count == 0){
            let alert = UIAlertController(title: "Oops!", message: "Please enter your password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else if (txtConfirmPassword.text?.count != txtPassword.text?.count){
            let alert = UIAlertController(title: "Oops!", message: "Confirmed password not matched please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else{
            let alert = UIAlertController(title: "User Registration!", message: "Your Registration is successfully.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        }
        
    }
    
//    private func textFieldShouldReturn(textField: UITextField) -> Bool
//    {
//        if(textField.returnKeyType == UIReturnKeyType.done)
//        {
//            textField .resignFirstResponder()
//        }
//        else
//        {
//            let txtFld : UITextField? = self.view.viewWithTag(textField.tag + 1) as? UITextField;
//            txtFld?.becomeFirstResponder()
//        }
//        return true
//    }
    
    func isValidPhoneNumber(testStr:String) -> Bool {
        let phoneRegEx = "^\\+7\\d{10}$"
        
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        let result = phoneTest.evaluate(with: testStr)
        return result
    }
    
}
    
