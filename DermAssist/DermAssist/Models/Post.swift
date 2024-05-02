//
//  Post.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//

import Foundation

struct Post: Codable, Equatable, Pinnable {
    var is_pin: Bool
    let createDate: TimeInterval
    
    let id: String
    var title: String
    var content: String
    let creator: String
    var comments: [Comment]
    var likes: [User]
    
    static func ==(lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id && lhs.createDate == rhs.createDate && lhs.is_pin == rhs.is_pin
    }
}

struct Comment: Codable, Pinnable {
    var is_pin: Bool
    let createDate: TimeInterval
    
    let id: String
    let authorId: String
    let content: String
}
