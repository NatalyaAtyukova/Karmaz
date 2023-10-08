//
//  OrderTableViewCell.swift
//  Karmaz
//
//  Created by Наталья Атюкова on 07.10.2023.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderCityLabel: UILabel!// senderCity&recipientCity
    
    @IBOutlet weak var orderInfoLabel: UILabel!
    
    @IBOutlet weak var orderPriceLabel: UILabel!
    
    @IBOutlet weak var getOrderBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
