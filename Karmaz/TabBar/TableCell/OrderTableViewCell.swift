//
//  OrderTableViewCell.swift
//  Karmaz
//
//  Created by Наталья Атюкова on 07.10.2023.
//

import UIKit

var service = Service.shared


class OrderTableViewCell: UITableViewCell {
    
    var orderID: String?

    @IBOutlet weak var orderCityLabel: UILabel!// senderCity&recipientCity
    @IBOutlet weak var orderInfoLabel: UILabel!
    @IBOutlet weak var orderPriceLabel: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
 
    
    @IBAction func getOrder(_ sender: Any) {
        if let orderID = orderID {
            service.setActiveStatus(for: orderID)
        }
    }
    
    
    func configure(info: String?, price: String?, recipientCity: String?, senderCity: String?, orderID: String?) {
        
        self.orderID = orderID
  
        // код для настройки отображения информации в ячейке
        orderInfoLabel.text = info
        orderPriceLabel.text = price
    
        
        if let recipientCity = recipientCity, let senderCity = senderCity {
                let combinedCity = "\(recipientCity), \(senderCity)"
                orderCityLabel.text = combinedCity
            } else {
                orderCityLabel.text = nil
            }
        
    }
    
}
