//
//  NetworkManager.swift
//  MyWeather
//
//  Created by ichiro on 25/09/24.
//

import Foundation
import Combine

class NetworkManager: ObservableObject {
    @Published var regions: [Region] = []
    @Published var cities: [City] = []
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchRegions() {
        let urlString = "https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Region].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { regions in
                self.regions = regions
                //                print("Regions fetched: \(regions.map { $0.name })")
            })
            .store(in: &cancellables)
    }
    
    func fetchCities(provinceId: String) {
        let urlString = "https://www.emsifa.com/api-wilayah-indonesia/api/regencies/\(provinceId).json"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
        //            .handleEvents(receiveOutput: { data in
        //                if let jsonString = String(data: data, encoding: .utf8) {
        //                    print("Raw JSON: \(jsonString)")
        //                }
        //            })
            .decode(type: [City].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                    print("Error fetching cities: \(error)")
                }
            }, receiveValue: { cities in
                self.cities = cities
                print("Cities fetched: \(cities.map { $0.name })")
            })
            .store(in: &cancellables)
    }
}

