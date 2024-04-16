//
//  Allergen.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 15/4/2567 BE.
//

import Foundation

struct Allergen: Codable, Equatable, Hashable {
    let createDate: TimeInterval
    let id: String
    let allergen_name: String
    let details: String
    let creator: String
    
    // Implement the Equatable protocol to consider all properties
    static func == (lhs: Allergen, rhs: Allergen) -> Bool {
        return lhs.id == rhs.id &&
               lhs.allergen_name == rhs.allergen_name &&
               lhs.details == rhs.details &&
               lhs.creator == rhs.creator &&
               lhs.createDate == rhs.createDate
    }
    
    // Use multiple properties for hashing
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(allergen_name)
        hasher.combine(details)
        hasher.combine(creator)
        hasher.combine(createDate)
    }
}
