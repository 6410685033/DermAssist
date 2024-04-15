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
    @Published var pharmacies: [String] = []  // Store pharmacy names
    
    /// Fetches nearby pharmacies given a latitude and longitude and updates the UI.
    /// - Parameters:
    ///   - latitude: The latitude of the location.
    ///   - longitude: The longitude of the location.
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
    /// - Throws: `PharmacyError` depending on the error encountered.
    /// - Returns: An array of pharmacy names.
    private func queryNearbyPharmacies(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> [String] {
        let urlString = "https://overpass-api.de/api/interpreter"
        guard var components = URLComponents(string: urlString) else {
            throw PharmacyError.invalidURL
        }
        
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
            throw PharmacyError.invalidURL
        }
        
        let (data, _) = try await session.data(from: url)
        let response = try JSONDecoder().decode(OverpassResponse.self, from: data)
        return response.elements.compactMap { $0.tags?["name"] }
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

// Define a custom error type to handle fetching errors more gracefully
enum PharmacyError: Error {
    case invalidURL
    case decodingError(Error)
    case networkError(Error)
}
