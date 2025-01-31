//
//  CityWeatherView.swift
//  WeatherApp
//
//  Created by Begüm Arıcı on 30.01.2025.
//

import SwiftUI

struct CityWeatherView: View {
    let city: String
    @State private var weather: WeatherResponse?
    @State private var dailyForecasts: [DailyForecast] = []
    @State private var isLoading = true
    @State private var hasError = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            // background: show if data is received, otherwise keep it gray
            if let icon = weather?.weather.first?.icon {
                Image(backgroundImage(for: icon))
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            } else {
                Color.gray.edgesIgnoringSafeArea(.all) // temp background instead of blank screen
            }

            VStack(spacing: 40) {
                if isLoading {
                    ProgressView("Loading \(city)...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .font(.title2)
                        .padding()
                } else if hasError {
                    VStack {
                        Text("Failed to load weather data.")
                            .font(.headline)
                            .foregroundColor(.white)
                        Button("Retry") {
                            fetchWeather(for: city)
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                } else {
                    CurrentWeatherView(weather: $weather)
                    WeeklyForecastView(dailyForecasts: $dailyForecasts)
                        .padding(.horizontal, 20)
                }
            }
            .padding(.top, 50)
        }
        .presentationDetents([.fraction(1), .large])
        .presentationDragIndicator(.visible) // user can close by swiping up or down
        .onAppear {
            fetchWeather(for: city)
        }
    }

    private func fetchWeather(for city: String) {
        isLoading = true
        hasError = false

        WeatherService().fetchWeather(for: city) { response in
            DispatchQueue.main.async {
                if let response = response {
                    self.weather = response
                    self.isLoading = false
                } else {
                    self.hasError = true
                    self.isLoading = false
                }
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
        case "03d", "03n": return "cloudy"
        case "04d", "04n": return "cloudy"
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
    CityWeatherView(city: "Istanbul")
}
