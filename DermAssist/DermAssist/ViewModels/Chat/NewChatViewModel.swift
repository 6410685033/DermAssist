//
//  NewChatViewModel.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class NewChatViewModel: ObservableObject {
    @Published var chat_name = ""
//    @Published var content = ""
//    @Published var dueDate = Date()
    @Published var showAlert = false
    
    func save() {
        guard canSave else { return }
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let newId = UUID().uuidString
        let newItem = Chat(is_pin: false, createDate: Date().timeIntervalSince1970, id: newId, chat_name: chat_name)
        let db = Firestore.firestore()
        db.collection("users")
            .document(uId)
            .collection("chats")
            .document(newId)
            .setData(newItem.asDictionary())
    }
    
    var canSave: Bool {
        guard !chat_name.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
//        guard dueDate >= Date().addingTimeInterval(-86400) else {
//            return false
//        }
        return true
    }
}
