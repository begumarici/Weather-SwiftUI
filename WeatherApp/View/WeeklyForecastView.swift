//
//  WeeklyForecastView.swift
//  WeatherApp
//
//  Created by Begüm Arıcı on 28.01.2025.
//

import SwiftUI

struct WeeklyForecastView: View {
    @Binding var dailyForecasts: [DailyForecast]

    var body: some View {
        ZStack {
            Color.clear.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(dailyForecasts, id: \.date) { forecast in
                        HStack {
                            Text(formattedDate(forecast.date))
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(Int(forecast.temp))°C")
                                .font(.subheadline)
                                .foregroundColor(.white)
                            Image(systemName: weatherIcon(for: forecast.icon))
                                .foregroundColor(iconColor(for: forecast.icon))
                        }
                        .frame(height: 25)
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(15)
                    }
                }
                .padding(.horizontal, 65)
                .padding(.vertical, 20)
            }
        }
    }

    private func formattedDate(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }

    private func weatherIcon(for icon: String) -> String {
        switch icon {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.stars.fill"
        case "02d", "02n": return "cloud.sun.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "smoke.fill"
        case "09d", "09n": return "cloud.drizzle.fill"
        case "10d", "10n": return "cloud.rain.fill"
        case "11d", "11n": return "cloud.bolt.fill"
        case "13d", "13n": return "snowflake"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "questionmark"
        }
    }

    private func iconColor(for icon: String) -> Color {
        switch icon {
        case "01d", "01n": return .yellow
        case "02d", "02n": return .orange
        case "03d", "03n": return .gray
        case "04d", "04n": return .gray
        case "09d", "09n": return .blue
        case "10d", "10n": return .cyan
        case "11d", "11n": return .purple
        case "13d", "13n": return .mint
        case "50d", "50n": return .teal
        default: return .white
        }
    }
}

#Preview {
    WeeklyForecastView(dailyForecasts: .constant([]))
}
