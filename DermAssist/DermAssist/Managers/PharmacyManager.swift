//
//  PharmacyManager.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 15/4/2567 BE.
//

import Foundation
import CoreLocation

class PharmacyManager: NSObject, ObservableObject {
    private let session = URLSession(configuration: .default)
    private let radius = 5000 // Search radius in meters
    
    @Published var isLoading = false
    @Published var pharmacies: [Pharmacy] = []  // Store pharmacy details
    
    /// Fetches nearby pharmacies given a latitude and longitude.
    func fetchNearbyPharmacies(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        do {
            let pharmacies = try await queryNearbyPharmacies(latitude: latitude, longitude: longitude)
            DispatchQueue.main.async { [weak self] in
                self?.pharmacies = pharmacies
                self?.isLoading = false
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.pharmacies = []
                self?.isLoading = false
                print("Error fetching pharmacies: \(error)")
            }
        }
    }
    
    /// Queries nearby pharmacies from the Overpass API.
    private func queryNearbyPharmacies(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> [Pharmacy] {
        let urlString = "https://overpass-api.de/api/interpreter"
        guard let components = URLComponents(string: urlString) else {
            throw PharmacyError.invalidURL
        }
        
        let query = """
                [out:json];
                (
                  node["amenity"="pharmacy"](around:\(radius),\(latitude),\(longitude));
                  way["amenity"="pharmacy"](around:\(radius),\(latitude),\(longitude));
                  relation["amenity"="pharmacy"](around:\(radius),\(latitude),\(longitude));
                );
                out center;
                """
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: "\(urlString)?data=\(encodedQuery ?? "")") else {
            throw PharmacyError.invalidURL
        }
        
        let (data, _) = try await session.data(from: url)
        let response = try JSONDecoder().decode(OverpassResponse.self, from: data)
        
        // Create CLLocation instance for the current location
        let currentLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        // Map Overpass API elements to Pharmacy objects and calculate distance
        return response.elements.compactMap { element in
            guard let name = element.tags["name"], let lat = element.lat, let lon = element.lon else { return nil }
            let pharmacyLocation = CLLocation(latitude: lat, longitude: lon)
            let distance = currentLocation.distance(from: pharmacyLocation)
            return Pharmacy(name: name, latitude: lat, longitude: lon, distance: distance)
        }
    }
    
}

struct OverpassResponse: Codable {
    var elements: [Element]
}

struct Element: Codable, Identifiable {
    var type: String
    var id: Int
    var lat: Double?
    var lon: Double?
    var tags: [String: String]
}

struct Pharmacy: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let distance: CLLocationDistance
    
    // Generate a Google Maps URL with a label
    var googleMapsURL: URL? {
        let label = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let urlString = "https://www.google.com/maps?q=\(label)@\(latitude),\(longitude)"
        return URL(string: urlString)
    }
    
    var formattedDistance: String {
        let newDistance: Double
        let unit: String
        
        if distance.magnitude >= 1000 {
            newDistance = distance.magnitude / 1000.0
            unit = "km"
        } else {
            newDistance = distance.magnitude
            unit = "m"
        }
        
        return String(format: "%.1f %@", newDistance, unit)
    }
}



enum PharmacyError: Error {
    case invalidURL
    case decodingError(Error)
    case networkError(Error)
}
