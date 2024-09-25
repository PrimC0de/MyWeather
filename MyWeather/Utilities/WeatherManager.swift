//
//  WeatherManager.swift
//  MyWeather
//
//  Created by ichiro on 25/09/24.
//

import Foundation

class WeatherManager: ObservableObject {
    @Published var errorMessage: String?
    @Published var weatherDescription: String = ""
    @Published var temperature: Double = 0.0
    let apiKey = APIKEY
    
    func getWeather(for city: String, province: String, completion: @escaping (WeatherResponse?) -> Void) {
        print("Fetching weather for city:", city)
        let cityEscaped = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityEscaped)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            //            if let jsonString = String(data: data, encoding: .utf8) {
            //                print("Raw JSON Response: \(jsonString)")
            //            }
            
            do {
                let errorResponse = try JSONDecoder().decode(WeatherErrorResponse.self, from: data)
                if errorResponse.cod != "200" {
                    print("City not found, fetching for province:", province)
                    self.fetchWeather2(for: province, completion: completion)
                    return
                }
            } catch {
                do {
                    let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.weatherDescription = weatherResponse.weather.first?.description ?? ""
                        self.temperature = weatherResponse.main.temp
                    }
                    completion(weatherResponse)
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func fetchWeather2(for province: String, completion: @escaping (WeatherResponse?) -> Void) {
        print("Fetching weather for province:", province)
        let provinceEscaped = province.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(provinceEscaped)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL for province")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch data for province: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            //            if let jsonString = String(data: data, encoding: .utf8) {
            //                print("Raw JSON Response for province: \(jsonString)")
            //            }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    self.weatherDescription = weatherResponse.weather.first?.description ?? ""
                    self.temperature = weatherResponse.main.temp
                }
                completion(weatherResponse)
            } catch {
                print("Failed to decode JSON for province: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    func getForecast(for city: String, completion: @escaping (ForecastResponse?) -> Void) {
        let cityEscaped = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(cityEscaped)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            do {
                let forecastResponse = try JSONDecoder().decode(ForecastResponse.self, from: data)
                print("Forecast Response: \(forecastResponse)")
                completion(forecastResponse)
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}

