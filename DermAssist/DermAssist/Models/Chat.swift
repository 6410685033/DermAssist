//
//  Chat.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//

import Foundation

struct Chat: Codable ,Identifiable, Pinnable {
    var is_pin: Bool
    let createDate: TimeInterval
    
    let id: String
    var chat_name: String
    var messages: [Message]
}

struct Message: Codable ,Identifiable, Pinnable {
    var is_pin: Bool
    let createDate: TimeInterval
    
    var id: String
    let message: String
    var isUser: Bool
}
