//
//  User.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 10/4/2567 BE.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable, Identifiable {
    var id: String?
    var name: String
    let email: String
    var tel: String
    var gender: Gender
    let joined: TimeInterval
    var role: UserRole
}

enum Gender: String, Codable, CaseIterable {
    case male = "male"
    case female = "female"
    case lgbt = "lgbt"
    case undefined = "undefined"
    
    var displayName: String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        case .lgbt:
            return "LGBT"
        case .undefined:
            return "Undefined"
        }
    }
}

enum UserRole: String, Codable, CaseIterable {
    case doctor = "doctor"
    case patient = "patient"
    case admin = "admin"
    
    var displayName: String {
        switch self {
        case .doctor:
            return "Doctor"
        case .patient:
            return "Patient"
        case .admin:
            return "Admin"
        }
    }
    
    var isDoctor: Bool {
        self == .doctor
    }
    
    var isAdmin: Bool {
        self == .admin
    }
    
    var isPatient: Bool {
        self == .patient
    }
}
