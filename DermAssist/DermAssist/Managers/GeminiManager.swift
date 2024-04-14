//
//  geminiManager.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 14/4/2567 BE.
//

import Foundation
import GoogleGenerativeAI
import CoreLocation

class GeminiManager: ObservableObject {
    // Gemini and location for pharmacy
    @Published var pharmacy: String? = nil
    @Published var showingPharmacy = false
    @Published var loadingPharmacy = false
    
    let gemini = GenerativeModel(name: "gemini-pro", apiKey: ProcessInfo.processInfo.environment["gemini"]!)
    
    func fetchPharmacy(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async {
        let prompt = "list of pharmacy near latitude: \(latitude), longitude: \(longitude)"
        
        DispatchQueue.main.async {
            self.showingPharmacy = true
            self.loadingPharmacy = true
        }
        
        if pharmacy == nil || pharmacy!.isEmpty {
            do {
                let response = try await gemini.generateContent(prompt)
                DispatchQueue.main.async {
                    self.pharmacy = response.text
                    self.loadingPharmacy = false
                }
            } catch {
                print("Error fetching pharmacy data: \(error)")
                DispatchQueue.main.async {
                    self.pharmacy = "Failed to fetch data: \(error.localizedDescription)"
                    self.loadingPharmacy = false
                }
            }
        } else {
            // If there is already data, just update the loading state
            DispatchQueue.main.async {
                self.loadingPharmacy = false
            }
        }
    }
    
}
