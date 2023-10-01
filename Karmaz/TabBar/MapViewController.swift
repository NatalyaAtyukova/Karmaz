//
//  MapViewController.swift
//  Karmaz
//
//  Created by Наталья Атюкова on 15.09.2023.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
  

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
             
         
    override func viewDidAppear(_ animated: Bool) {
        checkLocationEnabled()
        checkAuth()
    }
    
    func checkLocationEnabled() {
        locationManager.delegate = self
        
        DispatchQueue.main.async {
            self.locationManagerDidChangeAuthorization(self.locationManager)
        }
    }

 
    func setupManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func checkAuth(){
        switch locationManager.authorizationStatus {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            break
        case .denied:
            showAlertLocation(title: "Вы запретили использование геолокации", message: "Изменить?", url: URL(string: UIApplication.openSettingsURLString))
            break
        case .restricted:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
    func showAlertLocation(title:String, message: String?, url:URL?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let goToSettingsAction = UIAlertAction(title: "Настройки", style: .default) { (alert) in
            if let url = url{
                UIApplication.shared.open(url)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(goToSettingsAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 50, longitudinalMeters: 50)
        mapView.setRegion(region, animated: true)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuth()
    }

    
    
}

