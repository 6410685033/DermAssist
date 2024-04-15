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
    @Published var showingPharmacy = false
    @Published var pharmacies: [String] = []  // Store pharmacy names
    
    // URL session configured for JSON decoding
    private let session: URLSession
    
    private var continuation: CheckedContinuation<CLLocationCoordinate2D, Error>?
    
    override init() {
        self.session = URLSession(configuration: .default)
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() async throws -> CLLocationCoordinate2D {
        // Ensure `isLoading` is updated on the main thread
        DispatchQueue.main.async {
            self.isLoading = true
        }
        manager.requestLocation()
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first?.coordinate else { return }
        DispatchQueue.main.async {  // Ensure all updates are on the main thread
            self.location = firstLocation
            self.isLoading = false
            self.continuation?.resume(returning: firstLocation)
            self.continuation = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {  // Ensure all updates are on the main thread
            self.isLoading = false
            self.continuation?.resume(throwing: error)
            self.continuation = nil
        }
    }
    
    func fetchNearbyPharmacies(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async {
        await toggleLoading(true)
        
        let radius = 10000 // 10 km for broader search
        let urlString = "https://overpass-api.de/api/interpreter"
        
        var components = URLComponents(string: urlString)!
        components.queryItems = [
            URLQueryItem(name: "data", value: """
                [out:json];
                (
                  node["amenity"="pharmacy"](around:\(radius),\(latitude),\(longitude));
                  way["amenity"="pharmacy"](around:\(radius),\(latitude),\(longitude));
                  relation["amenity"="pharmacy"](around:\(radius),\(latitude),\(longitude));
                );
                out center;
                """)
        ]
        
        guard let url = components.url else {
            print("Failed to create URL")
            await toggleLoading(false)
            return
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            let response = try JSONDecoder().decode(OverpassResponse.self, from: data)
            await updatePharmacyList(with: response)
        } catch {
            print("Failed to fetch or parse pharmacies: \(error)")
            await toggleLoading(false)
        }
    }
    
    private func updatePharmacyList(with response: OverpassResponse) async {
        await MainActor.run {
            self.pharmacies = response.elements.compactMap { $0.tags?["name"] }
            self.showingPharmacy = !self.pharmacies.isEmpty
            self.isLoading = false
        }
    }
    
    func toggleLoading(_ isLoading: Bool) async {
        await MainActor.run {
            self.isLoading = isLoading
        }
    }
    
}


struct OverpassResponse: Codable {
    var elements: [Element]
}

struct Element: Codable {
    var type: String
    var id: Int
    var tags: [String: String]?
}
