//
//  RegViewController.swift
//  Karmaz
//
//  Created by Наталья Атюкова on 31.07.2023.
//

import UIKit


class RegViewController: UIViewController, UITextFieldDelegate {
    
    var service = Service.shared
    
    @IBOutlet weak var txtFName: UITextField!
    
    @IBOutlet weak var txtLName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //code
    }
    
    
    @IBAction func backToLoginVC(_ sender: Any) {
        performSegue(withIdentifier: "regBackToLoginVC", sender: self
        )
    }
    
    @IBAction func btnRegistration(_ sender: Any) {
        //fname and lname
        if txtFName.text?.count == 0 {
            let alert = UIAlertController(title: "Ошибка!", message: "Please enter your first name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        } else if !isValidName(testStr: txtFName.text!) {
            let alert = UIAlertController(title: "Ошибка!", message: "Invalid first name. Only alphabetic characters are allowed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else if txtLName.text?.count == 0 {
            let alert = UIAlertController(title: "Ошибка!", message: "Please enter your last name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else if !isValidName(testStr: txtLName.text!) {
            let alert = UIAlertController(title: "Ошибка!", message: "Invalid last name. Only alphabetic characters are allowed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
            //email
        } else if txtEmail.text?.count == 0 {
            let alert = UIAlertController(title: "Ошибка!", message: "Please enter your Email.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        } else if !isValidEmail(txtEmail.text!) {
            let alert = UIAlertController(title: "Ошибка!", message: "Invalid Email. Only alphabetic characters are allowed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
            
            //password and re-pass
        } else if txtPassword.text?.count == 0 {
            let alert = UIAlertController(title: "Ошибка!", message: "Please enter your password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        } else if !isValidPassword(txtPassword.text!) {
            let alert = UIAlertController(title: "Ошибка!", message: "Ваш пароль должен содержать минимум 8 символов, одну заглавную букву, строчную букву и одну цифру", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        } else if txtConfirmPassword.text?.count == 0 {
            let alert = UIAlertController(title: "Ошибка!", message: "Confirmed password empty please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
   
            
        } else if txtConfirmPassword.text != txtPassword.text {
            let alert = UIAlertController(title: "Ошибка!", message: "Confirmed password not matched please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)

            
           
            
        } else {
            //Create User
            
            let firstName = txtFName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = txtLName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = txtPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            service.createUser(in: self, firstName: firstName, lastName: lastName, email: email, password: password) //Вызывает func create user из service с окном алерта - уведомлением
            
            
        }
        
        
      
    }
    
    //Valid func
        
    func isValidName(testStr: String) -> Bool {
            let nameRegex = "^[a-zA-Z]+$"
            let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
            let result = nameTest.evaluate(with: testStr)
            return result
        }
    
    func isValidEmail(_ email: String) -> Bool {
        // Паттерн для проверки email адреса
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    func isValidPassword(_ password: String) -> Bool {
        // Длина пароля должна быть не менее 8 символов
        if password.count < 8 {
            return false
        }
        
        // Проверяем, содержит ли пароль хотя бы одну заглавную букву
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let capitalLetterPred = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let containsCapitalLetter = capitalLetterPred.evaluate(with: password)
        
        // Проверяем, содержит ли пароль хотя бы одну строчную букву
        let smallLetterRegEx  = ".*[a-z]+.*"
        let smallLetterPred = NSPredicate(format:"SELF MATCHES %@", smallLetterRegEx)
        let containsSmallLetter = smallLetterPred.evaluate(with: password)
        
        // Проверяем, содержит ли пароль хотя бы одну цифру
        let numberRegEx  = ".*[0-9]+.*"
        let numberPred = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let containsNumber = numberPred.evaluate(with: password)
        
        return containsCapitalLetter && containsSmallLetter && containsNumber
    }

  
    
        
    }

    
