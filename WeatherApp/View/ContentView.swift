//
//  ContentView.swift
//  WeatherApp
//
//  Created by Begüm Arıcı on 25.01.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var weather: WeatherResponse?
    @State private var dailyForecasts: [DailyForecast] = []
    @StateObject private var locationManager = LocationManager()
    @State private var isLoading = false
    @State private var userCity: String? // user's current location
    
    var body: some View {
        NavigationView {
            ZStack {
                if let icon = weather?.weather.first?.icon {
                    Image(backgroundImage(for: icon))
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Color.gray.edgesIgnoringSafeArea(.all)
                }

                VStack(spacing: 40) {
                    if isLoading {
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .font(.title2)
                    } else {
                        CurrentWeatherView(weather: $weather)
                        WeeklyForecastView(dailyForecasts: $dailyForecasts)
                            .padding(.horizontal, 20)
                    }
                }
                .padding(.top, 50)
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView(selectedCity: $userCity)) {
                        Image(systemName: "line.horizontal.3")
                            .foregroundColor(.black)
                            .font(.title)
                    }

                }
            }
            .onReceive(locationManager.$city) { city in
                if userCity == nil, let city = city {
                    userCity = city
                    fetchWeather(for: city)
                }
            }
        }
    }

    private func fetchWeather(for city: String) {
        isLoading = true
        WeatherService().fetchWeather(for: city) { response in
            DispatchQueue.main.async {
                self.weather = response
                self.isLoading = false
            }
        }

        WeatherService().fetchForecast(for: city) { forecasts in
            DispatchQueue.main.async {
                self.dailyForecasts = forecasts ?? []
            }
        }
    }

    private func backgroundImage(for icon: String) -> String {
        switch icon {
        case "01d", "01n": return "sunny"
        case "02d", "02n": return "cloudy"
        case "09d", "09n": return "rainy"
        case "10d", "10n": return "downpour"
        case "11d", "11n": return "thunder"
        case "13d", "13n": return "snowy"
        case "50d", "50n": return "foggy"
        default: return "cloudy"
        }
    }
}


#Preview {
    ContentView()
}
