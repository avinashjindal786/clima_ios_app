//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController{

   
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchtextField: UITextField!
    var weatherMan = weatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        weatherMan.delegate = self
        searchtextField.delegate = self
    }

    
    @IBAction func locationButton(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    
}

//MARK: - UITextFieldDelegate

extension WeatherViewController : UISearchTextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchtextField.endEditing(true)
        print(searchtextField.text!)
        
        return true
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        searchtextField.endEditing(true)
        print(searchtextField.text!)
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchtextField.text != ""{
            return true
        }else{
            textField.placeholder = "type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchtextField.text{
            weatherMan.fetchWeather(cityName: city)
        }
        
        searchtextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate


extension WeatherViewController : weatherManagerDelegate{
    func didUpdate(_ weatherManager : weatherManager,weather : WeatherModel)
    {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


//MARK: - ClLocationManager

extension WeatherViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lng = location.coordinate.longitude
            DispatchQueue.main.async{
                self.weatherMan.fetchWeatherForAttitude(lat: lat, lng: lng)
                
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}




