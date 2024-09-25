//
//  Province.swift
//  MyWeather
//
//  Created by ichiro on 24/09/24.
//

import Foundation

struct ProvinceResponse: Codable{
    let value: [Province]
}

struct Province: Identifiable, Codable {
    let id: String
    let name: String
}


