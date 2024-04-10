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

extension Post {
    func asDictionary() -> [String: Any] {
        return [
            "id": id,
            "title": title,
            "createDate": createDate,
            "content": content,
            "creator": creator,
            "comments": comments.map { $0.asDictionary() },  // Assuming comments are also Codable
            "likes": likes,
        ]
    }
}

extension User {
    var asDictionary: [String: Any] {
        return [
            "id": id,
            "name": name,
            "email": email,
            "tel": tel,
            "gender": gender,
            "joined": joined,
            "role": role.rawValue,
        ]
    }
}

extension Comment {
    var dictionary: [String: Any] {
        return [
            "id": id,
            "authorId": authorId,
            "content": content,
            "timestamp": timestamp
        ]
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
