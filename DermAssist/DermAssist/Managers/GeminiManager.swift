//
//  geminiManager.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 14/4/2567 BE.
//

import Foundation
import GoogleGenerativeAI

class GeminiManager: ObservableObject {
    // Gemini and location for pharmacy
    @Published var pharmacy: String? = nil
    @Published var showingPharmacy = false
    @Published var loadingPharmacy = false
    
    let gemini = GenerativeModel(name: "gemini-pro", apiKey: ProcessInfo.processInfo.environment["gemini"]!)
    
    func fetchPharmacy() async {
        DispatchQueue.main.async {
            self.showingPharmacy = true // showing sheet
            
            if let pharmacyData = self.pharmacy, !pharmacyData.isEmpty {
                self.loadingPharmacy = false
            } else {
                self.loadingPharmacy = true
            }
        }
        
        if pharmacy == nil || pharmacy!.isEmpty {
            do {
                let response = try await gemini.generateContent("list of pharmacy")
                DispatchQueue.main.async {
                    self.pharmacy = response.text
                    self.loadingPharmacy = false
                    self.showingPharmacy = true
                }
            } catch {
                print("Error fetching pharmacy data: \(error)")
                DispatchQueue.main.async {
                    self.pharmacy = "Failed to fetch data: \(error.localizedDescription)"
                    self.loadingPharmacy = false
                    self.showingPharmacy = true
                }
            }
        }
    }
}
