//
//  LocationManager.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 14/4/2567 BE.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false
    private var continuation: CheckedContinuation<CLLocationCoordinate2D, Error>?

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }

    func requestLocation() async throws -> CLLocationCoordinate2D {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        manager.requestLocation()

        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let firstLocation = locations.first?.coordinate {
            DispatchQueue.main.async { // Ensure UI updates are on the main thread
                self.location = firstLocation
                self.isLoading = false
                self.continuation?.resume(returning: firstLocation)
                self.continuation = nil
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async { // Ensure error handling is on the main thread
            self.isLoading = false
            self.continuation?.resume(throwing: error)
            self.continuation = nil
        }
    }
}
