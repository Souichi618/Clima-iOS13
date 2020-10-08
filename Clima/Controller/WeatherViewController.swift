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
    var isoShort = ""
    var infoCount = 0
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
   
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var humidLabel: UILabel!
    
   override func viewDidLoad() {
             super.viewDidLoad()
         locationManager.delegate = self
  locationManager.requestWhenInUseAuthorization()
  locationManager.requestLocation()
             searchTextField.delegate = self
             weatherManager.delegate = self
    
         }
    
    @IBAction func countryButton(_ sender: UIButton) {
        
       let countryP = weatherManager.getCountryDetail(CC: isoShort)
        if countryP.CN != "error" {
            
        
        switch infoCount {
        case 0 :
            cityLabel.text = countryP.CN
        case 1 :
            cityLabel.text = countryP.ISO
        case 2 :
            cityLabel.text = countryP.Telc
        default:
            cityLabel.text = countryP.CN
            infoCount = 0
        }
        infoCount += 1
        
        } else {
            didFailedError(error: 3)
        }
    }
    @IBAction func homeButtonPrssed(_ sender: UIButton) {
         locationManager.requestLocation()
    }
}
   


//MARK: - UITextDelegate
extension WeatherViewController: UITextFieldDelegate {
        

       @IBAction func searchPressed(_ sender: UIButton) {
           searchTextField.endEditing(true)
         
       }
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       searchTextField.endEditing(true)
           
           return true
       }
       func textFieldDidEndEditing(_ textField: UITextField) {
           if let city = searchTextField.text {
           weatherManager.fetchWeather(cityName: city)
           searchTextField.text = ""
           textField.placeholder = ""
            
           }
       }
       func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
           if textField.text != "" {
               return true
           } else {
               textField.placeholder = "type something"
               return false
           }
       }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        searchTextField.text = ""
        
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
     func didUpdateWeather(_ weatherManager: WeatherManager ,weather: WeatherModel){
            DispatchQueue.main.async {
                self.temperatureLabel.text = weather.tempratureString
                self.conditionImageView.image = UIImage(systemName: weather.conditionName)
                self.isoShort = weather.country
                self.cityLabel.text = ("\(weather.cityName)@\(weather.country)")
                self.infoCount = 0  // reset country information count 
                    
                
               
        
                self.humidLabel.text = weather.humidString
            }
           // print(weather.temprature)
            }
        func didFailedError(error: Int) {
            DispatchQueue.main.async {
            switch error {
            case 0 :
                self.searchTextField.text = "Session Error"
            case 1 :
                self.searchTextField.text = "city name not found"
            case 2 :
                self.searchTextField.text = "location Error"
            case 3 :
                self.searchTextField.text = "country code error"
            default:
                self.searchTextField.text = "unknown Error"
            }
            }
        }
    }

//MARK: - CLLocationManagerDelegate

extension  WeatherViewController: CLLocationManagerDelegate {
    
    func  locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
                
            
        }
       }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           didFailedError(error: 2)
       }
    
}
