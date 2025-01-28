//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by Begüm Arıcı on 28.01.2025.
//

import SwiftUI

struct CurrentWeatherView: View {
    @Binding var weather: WeatherResponse?

    var body: some View {
        VStack {
            if let weather = weather {
                Text(weather.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text(weather.weather.first?.description ?? "")
                    .font(.title2)
                    .foregroundColor(.black)
                
                Text("\(Int(weather.main.temp))°C")
                    .font(.system(size: 80))
                    .fontWeight(.light)
                    .foregroundColor(.black)
            } else {
                Text("Loading...")
            }
        }
        .padding()
    }
}

#Preview {
    CurrentWeatherView(weather: .constant(nil))
}
