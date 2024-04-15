//
//  Allergen.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 15/4/2567 BE.
//

import Foundation

struct Allergen: Codable, Equatable {
    let createDate: TimeInterval
    let id: String
    let allergen_name: String
    let details: String
    let creator: String
    
    // Implement the Equatable protocol
    static func == (lhs: Allergen, rhs: Allergen) -> Bool {
        // Check if all properties of the two instances are equal
        return lhs.createDate == rhs.createDate &&
               lhs.id == rhs.id &&
               lhs.allergen_name == rhs.allergen_name &&
               lhs.details == rhs.details
    }
}
