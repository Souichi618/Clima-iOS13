//
//  WeatherData.swift
//  Clima
//
//  Created by Souichi Tsujimoto on 22/6/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct  WeatherData: Codable{
    let sys: Sys
    let name: String
    let main: Main
    let weather: [data]
    let cod: Int
}

struct Main: Codable {
    let temp: Double
    let humidity:Double
}
struct Sys: Codable {
    let country : String
}
struct data: Codable {
    let description : String
    let id: Int
}
