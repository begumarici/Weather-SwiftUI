//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Begüm Arıcı on 26.01.2025.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var city: String?
    private var previousCity: String? // Prevent unnecessary API calls by keeping previous city info

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.reverseGeocode(location: location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

    private func reverseGeocode(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, let newCity = placemark.locality else { return }

            // If the city has not changed, do not make the API call
            if newCity != self.previousCity {
                DispatchQueue.main.async {
                    self.city = newCity
                    self.previousCity = newCity
                }
            }
        }
    }
}
