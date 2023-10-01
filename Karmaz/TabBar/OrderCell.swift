//
//  OrderCell.swift
//  Karmaz
//
//  Created by Наталья Атюкова on 01.10.2023.
//

import UIKit
import CoreLocation

class OrderCell: UITableViewCell {

    
    @IBOutlet weak var numberOfOrder: UITextField!
    
    @IBOutlet weak var OrderInfo: UILabel!
    
    @IBOutlet weak var TakeOrder: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
     
    }

    
}
