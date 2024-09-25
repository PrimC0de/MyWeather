//
//  HomeViewController.swift
//  MyWeather
//
//  Created by ichiro on 25/09/24.
//

import SwiftUI

struct HomeViewController: View {
    @StateObject private var locationManager = LocationManager()
    @State private var searchText: String = ""
    @State private var userName: String = ""
    @State private var selectedProvince: String = ""
    @State private var selectedProvinceId: String = ""
    @State private var selectedCity: String = ""
    @State private var showingCities: Bool = false
    @State private var navigateToResultView: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var filteredRegions: [Region] {
        if searchText.isEmpty {
            return []
        } else {
            return locationManager.regions.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Input Username", text: $userName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                if userName.isEmpty {
                    Text("Username is required")
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                TextField("Search for a province", text: $searchText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                TextField("Selected Province", text: $selectedProvince)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .disabled(true)
                
                if !searchText.isEmpty {
                    List(filteredRegions) { region in
                        Button(action: {
                            selectedProvince = region.name
                            selectedProvinceId = region.id
                            searchText = ""
                            showingCities = true
                            locationManager.fetchCities(provinceId: selectedProvinceId)
                        }) {
                            Text(region.name)
                                .foregroundColor(.primary)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .frame(height: 100)
                }
                
                if showingCities {
                    Text("Cities in \(selectedProvince)")
                        .font(.headline)
                        .padding()
                    
                    List(locationManager.cities) { city in
                        Button(action: {
                            selectedCity = city.name
                            showingCities = false
                        }) {
                            Text(city.name)
                                .foregroundColor(.primary)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .frame(height: 100)
                }
                
                TextField("Selected City", text: $selectedCity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .disabled(true)
                
                if let errorMessage = locationManager.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    if userName.isEmpty || selectedProvince.isEmpty || selectedCity.isEmpty {
                        alertMessage = "Please fill in all required fields: Username, Province, and City."
                        showAlert = true
                    } else {
                        navigateToResultView = true
                    }
                }) {
                    Text("Confirm")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Missing Information"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                NavigationLink(
                    destination: WeatherView(province: selectedProvince, city: selectedCity, userName: userName),
                    isActive: $navigateToResultView,
                    label: { EmptyView() }
                )
            }
            .navigationTitle("Weather")
            .onAppear {
                locationManager.fetchRegions()
            }
        }
    }
}

#Preview {
    HomeViewController()
}

