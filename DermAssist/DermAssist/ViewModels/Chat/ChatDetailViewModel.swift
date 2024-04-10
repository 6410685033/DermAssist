//
//  ChatDetailViewModel.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//


import Foundation
import FirebaseAuth
import FirebaseFirestore

class ChatDetailsViewModel: ObservableObject {
    var itemId: String
    @Published var item: Chat? = nil
    @Published var showingEditView = false
    
    init(itemId: String) {
        self.itemId = itemId
        fetch_item()
    }
    
    func toggleIsDone(item: Chat) {
        var itemCopy = item
        itemCopy.toggle_pin()
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(uid)
            .collection("chats")
            .document(itemCopy.id)
            .setData(itemCopy.asDictionary())
    }
    
    func fetch_item() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(uid)
            .collection("chats")
            .document(itemId)
            .getDocument { [weak self]snapshot, error in
                guard let data = snapshot?.data(), error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self?.item = Chat(
                        is_pin: data["is_pin"] as? Bool ?? false,
                        createDate: data["createDate"] as? TimeInterval ?? 0,
                        id: data["id"] as? String ?? "",
                        chat_name: data["chat_name"] as? String ?? "",
                        messages: data["messages"] as? [Message] ?? []
                    )
                }
                
            }
    }
}
