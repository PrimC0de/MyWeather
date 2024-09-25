//
//  City.swift
//  MyWeather
//
//  Created by ichiro on 25/09/24.
//

import Foundation

struct CityResponse: Codable {
    let code: String
    let messages: String
    let value: [City]
}

struct City: Identifiable, Codable {
    let id: String
    let province_id: String
    let name: String
}


