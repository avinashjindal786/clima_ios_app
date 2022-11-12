//
//  weatherModel.swift
//  Clima
//
//  Created by Avinash jindal on 08/11/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation


protocol weatherManagerDelegate{
    func didUpdate(_ weatherManager : weatherManager,weather : WeatherModel)
    func didFailWithError(error : Error)
}

struct weatherManager{
    
    var delegate : weatherManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=0ba015aa681fa6dd7af50d2e540897a3"
    
    func fetchWeather(cityName:String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        performRequest(urlString)
    }
    
    func fetchWeatherForAttitude(lat:CLLocationDegrees,lng:CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lng)"
        print(urlString)
        performRequest(urlString)
    }
    
    func performRequest(_ urlString: String){
        
        if  let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            
            let task =  session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let weather =  self.parseJson(safeData){
                        self.delegate?.didUpdate(self,weather : weather)
                    }
                }
            }
            
            task.resume()
        }
        
    }
    
    func parseJson(_ wetherdata: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
           let decodedData =  try decoder.decode(WeatherData.self, from: wetherdata)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
   
}
