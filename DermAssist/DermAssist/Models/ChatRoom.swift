//
//  Chat.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//

import Foundation

struct ChatRoom: Codable ,Identifiable, Pinnable, Equatable{
    var is_pin: Bool
    let createDate: TimeInterval
    let id: String
    var chat_name: String
    
    static func ==(lhs: ChatRoom, rhs: ChatRoom) -> Bool {
        lhs.id == rhs.id && lhs.createDate == rhs.createDate && lhs.is_pin == rhs.is_pin
    }
}

struct Message: Codable ,Identifiable, Pinnable {
    var is_pin: Bool
    let createDate: TimeInterval
    
    var id: String
    let message: String
    var isUser: Bool
}
