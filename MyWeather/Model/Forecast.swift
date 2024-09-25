//
//  Forecast.swift
//  MyWeather
//
//  Created by ichiro on 25/09/24.
//

import Foundation
struct ForecastResponse: Codable {
    let list: [Forecast]
}

struct Forecast: Codable, Identifiable {
    let id = UUID()
    let dt: Int
    let main: MainWeather
    let weather: [Weather]
    let dt_txt: String
    
    struct MainWeather: Codable {
        let temp: Double
    }
    
    struct Weather: Codable {
        let description: String
        let icon: String
    }
}
