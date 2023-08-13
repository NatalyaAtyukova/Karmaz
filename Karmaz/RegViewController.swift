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
        
        if txtFName.text?.count == 0 {
            let alert = UIAlertController(title: "Oops!", message: "Please enter your first name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else if !isValidName(testStr: txtFName.text!) {
            let alert = UIAlertController(title: "Oops!", message: "Invalid first name. Only alphabetic characters are allowed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else if txtLName.text?.count == 0 {
            let alert = UIAlertController(title: "Oops!", message: "Please enter your last name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else if !isValidName(testStr: txtLName.text!) {
            let alert = UIAlertController(title: "Oops!", message: "Invalid last name. Only alphabetic characters are allowed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        } else if (txtEmail.text?.count == 0){
            let alert = UIAlertController(title: "Oops!", message: "Please enter your Email.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        } else if (txtPassword.text?.count == 0){
            let alert = UIAlertController(title: "Oops!", message: "Please enter your password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        } else if (txtConfirmPassword.text?.count == 0){
            let alert = UIAlertController(title: "Oops!", message: "Confirmed password empty please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        } else if (txtConfirmPassword.text != txtPassword.text){
            let alert = UIAlertController(title: "Oops!", message: "Confirmed password not matched please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        } else {
            
            //Create User
            
            let firstName = txtFName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = txtLName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = txtPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            Auth.auth().createUser(withEmail: email, password: password) { result, err in
                //check errors
                if err != nil {
                    print("Не удалось создать пользователя")
                }
                else {
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstName": firstName, "lastName": lastName, "uid": result!.user.uid]) { (error) in
                        if error != nil {
                            print("Ошибка при создании пользователя")
                        } else {
                            // В случае успешного создания пользователя выполнить нужный код
                            print("Пользователь успешно создан!")
                        }
                        
                    }
                    
                }
                
            }
            let alert = UIAlertController(title: "User Registration!", message: "Your Registration is successfully.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        }
        
        
        // Измените цвет фона полей с ошибками
        firstNameValidator.changeBackgroundColor(hasError: txtFName.text?.count == 0)
        lastNameValidator.changeBackgroundColor(hasError: txtLName.text?.count == 0)
        emailValidator.changeBackgroundColor(hasError: txtEmail.text?.count == 0)
        passwordValidator.changeBackgroundColor(hasError: txtPassword.text?.count == 0)
        confirmPasswordValidator.changeBackgroundColor(hasError: txtConfirmPassword.text?.count == 0 || txtConfirmPassword.text != txtPassword.text)
     
    }
        
        func isValidName(testStr: String) -> Bool {
            let nameRegex = "^[a-zA-Z]+$"
            let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
            let result = nameTest.evaluate(with: testStr)
            return result
        }
        
    //pass valid
    //email valid
    
    
    //FBCreateURLForIdentificateNewUser
    
//Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { authResult, error in
    
        
    }

    
