//
//  WeatherModel.swift
//  Clima
//
//  Created by Souichi Tsujimoto on 23/6/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let country: String
    let cityName : String
    let temprature : Double
    let humidity : Double
    
    var tempratureString: String {
        return String(format:"%.1f", temprature)
    }
    var humidString: String{
        return String(format: "%.1f", humidity)
    }
    var conditionName : String {
        
        switch conditionId {
        case 200...232 :
            return "cloud.bolt"
        case 300...321 :
            return "cloud.drizzle"
        case  500...531 :
            return  "cloud.rain"
        case  600...622 :
            return  "cloud.snow"
        case   700...781 :
            return "cloud.fog"
        case   800 :
            return "sun.max"
        case  801...804 :
            return  "cloud"
            
        default:
            return  "cloud"
    }
    
   
    }
}

