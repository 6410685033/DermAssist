//
//  locationManager.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 14/4/2567 BE.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D? //published => update UI
    @Published var isLoading = false
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestLocation() {
        print("request location")
        DispatchQueue.main.async {
            self.isLoading = true  // Should be inside DispatchQueue.main.async if not on main thread
        }
            manager.requestWhenInUseAuthorization()
            manager.requestLocation()
        }
        
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            location = locations.first?.coordinate
            isLoading = false
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error getting location", error)
            isLoading = false
        }
    }
