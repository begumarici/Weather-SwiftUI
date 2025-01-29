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
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .onReceive(locationManager.$city) { city in
                if let city = city {
                    isLoading = true
                    WeatherService().fetchWeather(for: city) { response in
                        self.weather = response
                        isLoading = false
                    }
                    WeatherService().fetchForecast(for: city) { forecasts in
                        self.dailyForecasts = forecasts ?? []
                        isLoading = false
                    }
                }
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
    ContentView()
}
