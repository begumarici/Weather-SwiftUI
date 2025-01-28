//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Begüm Arıcı on 25.01.2025.
//

import Foundation

struct WeatherResponse: Codable {
    let main: Main
    let weather: [Weather]
    let name: String
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
}

struct ForecastResponse: Codable {
    let list: [Forecast]
}

struct Forecast: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
}

struct DailyForecast {
    let date: Int
    let temp: Double
    let weatherDescription: String
    let icon: String
}
