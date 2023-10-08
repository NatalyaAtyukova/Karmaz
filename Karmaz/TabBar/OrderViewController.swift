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
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Возвращайте количество ячеек, которые вы хотите отобразить
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell) as! OrderTableViewCell
        
        return cell
    }
    
    var citiesArray: [String] = []

       // Метод, вызываемый при вводе текста в поле поиска
       func searchForCity(with keyword: String) {
           // Выполнение поиска на основе ключевого слова и обновление таблицы с результатами
           
           let filteredCities = citiesArray.filter { $0.range(of: keyword, options: .caseInsensitive) != nil }
           //
       }
       
       func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           // Вызывайте ваш метод searchForCity при изменении текста в поле поиска
           searchForCity(with: searchText)
       }
       
       func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           // Вызывайте метод searchForCity при нажатии на кнопку "Search" на клавиатуре
           searchForCity(with: searchBar.text ?? "")
       }
       
       func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
           // Выполните нужные действия по отмене поиска
       }
       
       func processCities(cities: [[String: Any]]) {
           // Очищаем массив городов перед обновлением
           citiesArray.removeAll()
           
           // Добавляем названия городов в массив
           for city in cities {
               if let cityName = city["CityName"] as? String {
                   citiesArray.append(cityName)
               }
           }
           
           // Выполняем дополнительные действия, если необходимо
       }
       
       
       
       
       
       func fetchCities() {
           // Токен для доступа к API
           let token = "eEGr3r6e2H3Q3ZRHBfnsrYBY3SEYF2Ka"
           
           // URL для получения списка городов с API kladr.ru
           let apiUrl = URL(string: "https://kladr-api.ru/api.php?action=getCities&token=&#40;token)")!
           
           let task = URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
               if let error = error {
                   // Обработка ошибки при выполнении запроса к API
                   print("Ошибка при получении списка городов:", error)
               }
               
               if let data = data {
                   do {
                       // Парсинг полученных данных в формате JSON
                       let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                       
                       // Обработка успешного ответа от API
                       if let cities = json?["Items"] as? [[String: Any]] {
                           // Дальнейшая обработка полученного списка городов
                           self.processCities(cities: cities)
                       }
                   } catch {
                       // Обработка ошибок при парсинге данных
                       print("Ошибка при разборе данных:", error)
                   }
               }
           }
           
           task.resume()
       }
    
           
       
   }

