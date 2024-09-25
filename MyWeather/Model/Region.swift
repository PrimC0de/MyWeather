//
//  Region.swift
//  MyWeather
//
//  Created by ichiro on 25/09/24.
//

import Foundation

struct RegionResponse: Codable {
    let code: String
    let messages: String
    let value: [Region]
}

struct Region: Codable, Identifiable {
    let id: String
    let name: String
}
