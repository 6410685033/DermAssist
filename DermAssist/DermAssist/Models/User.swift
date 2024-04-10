//
//  User.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 10/4/2567 BE.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let email: String
    let tel: String
    let gender: String
    let joined: TimeInterval
    let role: UserRole
}

enum UserRole: String, Codable {
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
