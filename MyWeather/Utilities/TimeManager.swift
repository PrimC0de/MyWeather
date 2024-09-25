//
//  TimeManager.swift
//  MyWeather
//
//  Created by ichiro on 25/09/24.
//

import Foundation

func currentGreeting() -> String {
    let hour = Calendar.current.component(.hour, from: Date())
    let timeOfDay = getTimeOfDay(for: hour)
    
    switch timeOfDay {
    case .morning:
        return "Selamat Pagi,"
    case .afternoon:
        return "Selamat Siang,"
    case .evening:
        return "Selamat Sore,"
    case .night:
        return "Selamat Malam,"
    }
}

private func getTimeOfDay(for hour: Int) -> TimeOfDay {
    switch hour {
    case 0..<12:
        return .morning
    case 12..<17:
        return .afternoon
    case 17..<21:
        return .evening
    default:
        return .night
    }
}

func formattedDate(_ dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "EEE, MMM d"
    
    if let date = inputFormatter.date(from: dateString) {
        return outputFormatter.string(from: date)
    }
    return dateString
}
