//
//  Extension.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 10/4/2567 BE.
//

import Foundation
import UIKit
import FirebaseAuth

extension Encodable {
    func asDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return json ?? [:]
        } catch {
            return [:]
        }
        
        
    }
}

extension PostViewModel {
    // Check if the current user has liked the post
    var isLiked: Bool {
        guard let userId = Auth.auth().currentUser?.uid else { return false }
        return post?.likes.contains { $0.id == userId } ?? false
    }
    
    // Count of likes
    var likeCount: Int {
        return post?.likes.count ?? 0
    }
}

protocol Pinnable {
    var createDate: TimeInterval { get }
    var is_pin: Bool { get set }
    mutating func toggle_pin()
}

extension Pinnable {
    mutating func toggle_pin() {
        self.is_pin = !self.is_pin
    }
}
