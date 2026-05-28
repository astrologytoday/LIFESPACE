// LocationManager.swift (FFC)

import Foundation
import CoreLocation
import Combine

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()

    @Published var city: String = ""
    @Published var region: String = ""
    @Published var userLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        // ❗️Do NOT request permission here. Call requestPermission() when Meetups is enabled.
    }

    // MARK: - Request Permission Manually
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // MARK: - Manual control (useful for Meetups)
    func startUpdating() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdating() {
        locationManager.stopUpdatingLocation()
    }

    // MARK: - Location Updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location

        // Reverse geocode to get city & region
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ in
            guard let placemark = placemarks?.first else { return }
            DispatchQueue.main.async {
                self.city = placemark.locality ?? ""
                self.region = placemark.administrativeArea ?? ""
            }
        }
    }

    // MARK: - Error Handling
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Location error: \(error.localizedDescription)")
    }

    // MARK: - Authorization Status Changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("❌ Location access denied by user.")
        case .notDetermined:
            print("ℹ️ Location permission not determined yet.")
        @unknown default:
            break
        }
    }
}
