//
//  ChatViewModel.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//

import Foundation
import FirebaseFirestore

class ChatViewModel: ObservableObject {
    @Published var showingNewItemView = false
    @Published var chats: [ChatRoom] = [] // Manually manage the chat list for animation
    private let userId: String
    private let db = Firestore.firestore()
    
    init(userId: String) {
        self.userId = userId
        fetchChats()
    }
    
    func fetchChats() {
        db.collection("users").document(userId).collection("chats")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("No documents")
                    return
                }
                self.chats = documents.compactMap { try? $0.data(as: ChatRoom.self) }
                self.sortChats() // Call sort whenever data changes
            }
    }
    
    func togglePin(chatRoom: ChatRoom) {
        if let index = chats.firstIndex(where: { $0.id == chatRoom.id }) {
            chats[index].is_pin.toggle()  // Toggle the pin status
            sortChats()  // Re-sort the list
        }
    }
    
    func sortChats() {
        chats.sort { $0.is_pin && !$1.is_pin }
    }
    
    func delete(id: String) {
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .collection("chats")
            .document(id)
            .delete()
    }
}
