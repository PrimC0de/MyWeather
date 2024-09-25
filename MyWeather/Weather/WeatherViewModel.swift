//
//  WeatherViewModel.swift
//  MyWeather
//
//  Created by ichiro on 25/09/24.
//

import Combine
import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var temperature: String = "--"
    @Published var description: String = ""
    @Published var cityName: String = ""
    @Published var iconURL: String = ""
    @Published var forecasts: [Forecast] = []
    
    private let weatherService = WeatherManager()
    
    func fetchWeather(for city: String, province: String) {
        weatherService.getWeather(for: city, province: province) { weather in
            DispatchQueue.main.async {
                if let weather = weather {
                    self.temperature = String(format: "%.1f", weather.main.temp) + "°C"
                    self.description = weather.weather.first?.description.capitalized ?? "No description"
                    self.cityName = weather.name
                    self.iconURL = "https://openweathermap.org/img/wn/\(weather.weather.first?.icon ?? "01d")@2x.png"
                } else {
                    self.temperature = "--"
                    self.description = "Unable to load data"
                }
            }
        }
        
        weatherService.getForecast(for: city) { forecastResponse in
            DispatchQueue.main.async {
                if let forecastResponse = forecastResponse {
                    let groupedForecasts = Dictionary(grouping: forecastResponse.list) { forecast in
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        return dateFormatter.string(from: self.dateFromString(forecast.dt_txt))
                    }
                    
                    self.forecasts = groupedForecasts.values.compactMap { $0.first }
                        .sorted { self.dateFromString($0.dt_txt) < self.dateFromString($1.dt_txt) }
                    
                    //                    for forecast in self.forecasts {
                    //                        print("Date and Time: \(forecast.dt_txt), Temperature: \(forecast.main.temp)°C, Description: \(forecast.weather.first?.description ?? "No description"), Icon: \(forecast.weather.first?.icon ?? "No icon")")
                    //                    }
                }
            }
        }
    }
    
    private func dateFromString(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: dateString) ?? Date()
    }
}
