//
//  OrderViewController.swift
//  Karmaz
//
//  Created by Наталья Атюкова on 07.10.2023.
//

import UIKit

class OrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var service = Service.shared
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    let idCell = "orderCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: idCell)
        
        searchBar.delegate = self
        
        // Вызываем функцию для получения данных о заказах
        service.getOrderInfo { (orders) in
               // Обновляем таблицу с полученными данными
               DispatchQueue.main.async {
                   self.tableView.reloadData()
               }
           }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return service.orders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath) as! OrderTableViewCell

        let order = service.orders[indexPath.row]
        cell.configure(info: order.info, price: order.price, recipientCity: order.recipientCity, senderCity: order.senderCity)

        return cell
    }
    
    
    

 
       
   }

