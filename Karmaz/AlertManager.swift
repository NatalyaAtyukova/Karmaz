//
//  AlertManager.swift
//  Karmaz
//
//  Created by Наталья Атюкова on 16.08.2023.
//

import UIKit
   
class AlertManager { //окна с ошибками
    static let shared = AlertManager()
    init() {}
    
        static func showErrorAlert(in viewController: UIViewController, title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
