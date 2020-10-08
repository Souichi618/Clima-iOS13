//
//  WeatherManager.swift
//  Clima
//
//  Created by Souichi Tsujimoto on 19/6/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailedError(error: Int)
}
struct WeatherManager {
   // var saveCN = ""
    let weatherURL =  "https://api.openweathermap.org/data/2.5/weather?appid=d5dcfc18a425a16f43af3b9769bd6d97&units=Metric"
    var delegate: WeatherManagerDelegate?
    var countryKey = CountryKey()
    mutating func fetchWeather(cityName: String) {
        var urlString = "\(weatherURL)&q=\(cityName)"
        
        let cityCountry = cityName.components(separatedBy: "@")
       
        if cityCountry.count == 2 {
            let countryName = cityCountry[1]
            var townName: String = cityCountry[0]
            townName = townName.whiteSpaceReplacedbySpChar()
            let countryCN = countryKey.getCountryData(countryCode: countryName)
            let countryCC = countryCN.CC
            
            if countryCN.CN != "error" {
                urlString = "\(weatherURL)&q=\(townName),,\(countryCC)"
            } else {
                delegate?.didFailedError(error: 3)
            }
            
            
        } else {
            let cityNameN = cityName.whiteSpaceReplacedbySpChar()
            urlString = "\(weatherURL)&q=\(cityNameN)"
        }
  
      
        performRequest(with: urlString)
        
    }
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
       
       let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
       
        performRequest(with: urlString)
    }
    func performRequest(with urlString:String) {
       
        //1. Create URL
        if let url = URL(string: urlString) {
           
            //2.Create URL session
            let session = URLSession(configuration: .default)
           
            //3.Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    
                    self.delegate?.didFailedError(error: 0)
                    return
                }
                if let safeData = data {
                   
                    if  let weather = self.parseJSON(safeData){
                     //   let weatherVC = WeatherViewController()
                     //   weatherVC.didUpdateWeather(weather: weather)
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4.Start the task
            task.resume()
            
        }
        
    }
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
       
        let decoder = JSONDecoder()
        
        do {
        let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let cc = decodedData.sys.country
            let temp = decodedData.main.temp
            let name = decodedData.name
            let humid = decodedData.main.humidity
            
            let weather = WeatherModel(conditionId: id, country: cc, cityName: name, temprature: temp, humidity: humid )
            return weather
        //    print(weather.conditionName)
        //    print(weather.tempratureString)
            
        } catch {
            
            delegate?.didFailedError(error: 1)
            return nil
        }
    }
    func  getCountryDetail(CC: String) -> CountryProfile {
        let countryProfile = countryKey.getCountryData(countryCode: CC)
        return countryProfile
    }
}


extension String {
    func whiteSpaceReplacedbySpChar() -> String {
        return components(separatedBy: " ").joined(separator: "%20")
    }
    
}
