//
//  ChatItemViewModel.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ChatItemViewModel: ObservableObject {
    
    //    func toggleIsDone(item: ChatRoom) {
    //        var itemCopy = item
    //        itemCopy.toggle_pin()
    //
    //        guard let uid = Auth.auth().currentUser?.uid else {
    //            return
    //        }
    //
    //        let db = Firestore.firestore()
    //        db.collection("users")
    //            .document(uid)
    //            .collection("chats")
    //            .document(itemCopy.id)
    //            .setData(itemCopy.asDictionary())
    //    }
    
    func togglePin(item: ChatRoom) {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        
        var updatedChatRoom = item
        updatedChatRoom.toggle_pin()
        try? db.collection("users")
            .document(uid)
            .collection("chats")
            .document(item.id)
            .setData(from: updatedChatRoom)
    }
}
