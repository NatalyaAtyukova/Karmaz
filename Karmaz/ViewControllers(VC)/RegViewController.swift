//
//  RegViewController.swift
//  Karmaz
//
//  Created by Наталья Атюкова on 31.07.2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

//структура для окрашивания полей

struct TextFieldValidator {
    let textField: UITextField
    
    func changeBackgroundColor(hasError: Bool) {
        if hasError {
            textField.backgroundColor = UIColor.red
        } else{
            textField.backgroundColor = UIColor.white // Установите цвет фона по умолчанию
        }
    }
}


class RegViewController: UIViewController, UITextFieldDelegate {
    

    
    @IBOutlet weak var txtFName: UITextField!
    
    @IBOutlet weak var txtLName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    
    // Объекты TextFieldValidator для каждого текстового поля
    var firstNameValidator: TextFieldValidator!
    var lastNameValidator: TextFieldValidator!
    var emailValidator: TextFieldValidator!
    var passwordValidator: TextFieldValidator!
    var confirmPasswordValidator: TextFieldValidator!
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Валидация для цвета
        firstNameValidator = TextFieldValidator(textField: txtFName)
        lastNameValidator = TextFieldValidator(textField: txtLName)
        emailValidator = TextFieldValidator(textField: txtEmail)
        passwordValidator = TextFieldValidator(textField: txtPassword)
        confirmPasswordValidator = TextFieldValidator(textField: txtConfirmPassword)
        
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
        } else if (txtEmail.text?.count == 0){
            let alert = UIAlertController(title: "Ошибка!", message: "Please enter your Email.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        } else if !isValidEmail(txtEmail.text!) {
            let alert = UIAlertController(title: "Ошибка!", message: "Invalid Email. Only alphabetic characters are allowed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
            
            //password and re-pass
        } else if (txtPassword.text?.count == 0){
            let alert = UIAlertController(title: "Ошибка!", message: "Please enter your password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        } else if !isValidPassword(txtPassword.text!) {
            let alert = UIAlertController(title: "Ошибка!", message: "Ваш пароль должен содержать минимум 8 символов, одну заглавную букву, строчную букву и одну цифру", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        } else if (txtConfirmPassword.text?.count == 0){
            let alert = UIAlertController(title: "Ошибка!", message: "Confirmed password empty please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        } else if (txtConfirmPassword.text != txtPassword.text){
            let alert = UIAlertController(title: "Ошибка!", message: "Confirmed password not matched please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
            // Измените цвет фона полей с ошибками
            firstNameValidator.changeBackgroundColor(hasError: txtFName.text?.count == 0)
            lastNameValidator.changeBackgroundColor(hasError: txtLName.text?.count == 0)
            emailValidator.changeBackgroundColor(hasError: txtEmail.text?.count == 0)
            passwordValidator.changeBackgroundColor(hasError: txtPassword.text?.count == 0)
            confirmPasswordValidator.changeBackgroundColor(hasError: txtConfirmPassword.text?.count == 0 || txtConfirmPassword.text != txtPassword.text)
            
        } else {
            
            //Create User
            
            let firstName = txtFName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = txtLName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = txtPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            Auth.auth().createUser(withEmail: email, password: password) { result, err in
                //check errors
                if err != nil {
                    let alert = UIAlertController(title: "Ошика при обращении к БД", message: "Не корректные значения при обращении к FireBase!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstName": firstName, "lastName": lastName, "uid": result!.user.uid]) { (error) in
                        if error != nil {
                            let alert = UIAlertController(title: "Регистрация пользователя", message: "Ошибка при регистрации пользователя!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            let alert = UIAlertController(title: "Регистрация пользователя", message: "Ваша регистрация прошла успешно!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)

                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        
      
    }
        
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

    