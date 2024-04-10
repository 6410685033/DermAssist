//
//  ChatViewModel.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//

import Foundation
import FirebaseFirestore

class ChatViewModel: ObservableObject {
    @Published var showingnewItemView = false
    
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
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
