//
//  WeatherView.swift
//  MyWeather
//
//  Created by ichiro on 24/09/24.
//

import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    let province: String
    let city: String
    let userName: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            Text("\(currentGreeting()) \(userName)!")
                .font(.title)
                .padding()
            
            Text("Current Weather in \(city), \(province)")
                .font(.headline)
            
            HStack {
                AsyncImage(url: URL(string: viewModel.iconURL)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                
                VStack(alignment: .leading) {
                    Text(viewModel.temperature)
                        .font(.title)
                    Text(viewModel.description)
                }
            }
            
            Text("5-Day Forecast")
                .font(.headline)
                .padding(.top)
            ScrollView{
                ForEach(viewModel.forecasts) { forecast in
                    HStack {
                        Text(formattedDate(forecast.dt_txt))
                        Spacer()
                        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(forecast.weather.first?.icon ?? "01d")@2x.png")) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 30, height: 30)
                        Text(String(format: "%.1f°C", forecast.main.temp))
                        Text(forecast.weather.first?.description.capitalized ?? "")
                    }
                    .padding(.vertical, 5)
                }
            }.onAppear {
                viewModel.fetchWeather(for: city, province: province)
            }
        }
        .padding()
        
        
    }
}

#Preview {
    WeatherView(province: "Province", city: "City", userName: "UserName")
}

