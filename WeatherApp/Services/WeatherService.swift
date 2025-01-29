//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Begüm Arıcı on 25.01.2025.
//

import Foundation

class WeatherService {
    private let apiKey = Config.apiKey

    // get current weather
    func fetchWeather(for city: String, completion: @escaping (WeatherResponse?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        fetchData(urlString: urlString, completion: completion)
    }

    // get 5-day weather forecast
    func fetchForecast(for city: String, completion: @escaping ([DailyForecast]?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(apiKey)&units=metric"
        
        fetchData(urlString: urlString) { (forecastResponse: ForecastResponse?) in
            guard let forecastResponse = forecastResponse else {
                completion(nil)
                return
            }

            let groupedForecasts = Dictionary(grouping: forecastResponse.list) { forecast in
                let date = Date(timeIntervalSince1970: TimeInterval(forecast.dt))
                return Calendar.current.startOfDay(for: date)
            }

            let dailyForecasts = groupedForecasts.compactMap { (_, forecasts) -> DailyForecast? in
                guard let firstForecast = forecasts.first else { return nil }
                return DailyForecast(
                    date: firstForecast.dt,
                    temp: firstForecast.main.temp,
                    weatherDescription: firstForecast.weather.first?.description ?? "",
                    icon: firstForecast.weather.first?.icon ?? ""
                )
            }

            DispatchQueue.main.async {
                completion(dailyForecasts)
            }
        }
    }


    private func fetchData<T: Decodable>(urlString: String, completion: @escaping (T?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Network error: \(error?.localizedDescription ?? "Unknown error")")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }

                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(decodedData)
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }.resume()
        }
    }
}
