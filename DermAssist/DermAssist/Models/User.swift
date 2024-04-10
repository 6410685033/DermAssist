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
    var gender: String
    let joined: TimeInterval
    var role: UserRole
}

enum UserRole: String, Codable, CaseIterable {
    case docter = "doctor"
    case patient = "patient"
    case admin = "admin"
    
    var displayName: String {
        switch self {
        case .docter:
            return "Doctor"
        case .patient:
            return "Patient"
        case .admin:
            return "Admin"
        }
    }
    
    var isDoctor: Bool {
        self == .docter
    }
    
    var isAdmin: Bool {
        self == .admin
    }
    
    var isPatient: Bool {
        self == .patient
    }
}
