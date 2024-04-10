//
//  Post.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//

import Foundation

struct Post: Codable {
    let id: String
    let title: String
    let createDate: TimeInterval
    let content: String
    let creator: String
    var comments: [Comment]
    var likes: [User]
}

struct Comment: Codable {
    let id: String
    let authorId: String
    let content: String
    let timestamp: TimeInterval
}
