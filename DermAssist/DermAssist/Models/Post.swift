//
//  Post.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//

import Foundation

struct Post: Codable, Pinnable {
    var is_pin: Bool
    let createDate: TimeInterval
    
    let id: String
    let title: String
    let content: String
    let creator: String
    var comments: [Comment]
    var likes: [User]
}

struct Comment: Codable, Pinnable {
    var is_pin: Bool
    let createDate: TimeInterval
    
    let id: String
    let authorId: String
    let content: String
}
