//
//  NewOrderViewController.swift
//  Karmaz
//
//  Created by Наталья Атюкова on 05.11.2023.
//

import UIKit

class NewOrderViewController: UIViewController {
    
    var service = Service.shared
    
    @IBOutlet weak var newSenderCityField: UITextField!
    
    @IBOutlet weak var newRecipientCityField: UITextField!
   
    
    @IBOutlet weak var newOrderInfoField: UITextField!
    
   
    @IBOutlet weak var newOrderPriceField: UITextField!
    
   

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   
    @IBAction func createNewOrderBtn(_ sender: UIButton) {
        
        let senderCity = newSenderCityField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let recipientCity = newRecipientCityField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let orderPrice = newOrderPriceField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let orderInfo = newOrderInfoField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        service.createNewOrder(in: self, orderInfo: orderInfo, orderPrice: orderPrice, recipientCity: recipientCity, senderCity: senderCity)
    }
    
}

