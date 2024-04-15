//
//  LocationManager.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 14/4/2567 BE.
//

import Foundation
import CoreLocation

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
    
    // Using async throws to handle location request asynchronously
    func requestLocation() async throws -> CLLocationCoordinate2D {
        DispatchQueue.main.async{
            self.isLoading = true
        }
        
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.continuation = continuation
            self?.manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first?.coordinate else { return }
        DispatchQueue.main.async { [weak self] in  // Ensure all updates are on the main thread
            self?.location = firstLocation
            self?.isLoading = false
            self?.continuation?.resume(returning: firstLocation)
            self?.continuation = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in  // Ensure all updates are on the main thread
            self?.isLoading = false
            self?.continuation?.resume(throwing: error)
            self?.continuation = nil
        }
    }
}
