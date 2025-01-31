//
//  SettingsView.swift
//  WeatherApp
//
//  Created by Begüm Arıcı on 30.01.2025.
//

import SwiftUI

struct SettingsView: View {
    @Binding var selectedCity: String?
    @State private var searchText = ""
    @State private var searchResults: [String] = []
    @State private var showCityWeather = false
    @State private var isLoadingWeather = false
    private let weatherService = WeatherService()

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                List(searchResults, id: \.self) { city in
                    Button(action: {
                        selectCity(city)
                    }) {
                        Text(city)
                            .font(.headline)
                    }
                }
                .listStyle(PlainListStyle())
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Weather")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }
            .searchable(text: $searchText, prompt: "Search for a city")
            .onChange(of: searchText) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    fetchCities()
                }
            }
            .sheet(isPresented: $showCityWeather) {
                if let city = selectedCity, !isLoadingWeather {
                    CityWeatherView(city: city)
                }
            }
        }
    }

    private func fetchCities() {
        guard !searchText.isEmpty else {
            searchResults = []
            return
        }

        weatherService.searchCity(searchText) { cities in
            DispatchQueue.main.async {
                self.searchResults = cities.map { "\($0.name), \($0.country)" } 
            }
        }
    }

    private func selectCity(_ city: String) {
        selectedCity = city
        isLoadingWeather = true
        showCityWeather = false

        weatherService.fetchWeather(for: city) { response in
            DispatchQueue.main.async {
                if response != nil {
                    isLoadingWeather = false
                    showCityWeather = true
                }
            }
        }
    }
}
