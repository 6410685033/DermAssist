//
//  AnnounceViewModel.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AnnounceViewModel: ObservableObject {
    @Published var showingnewPostView = false
    @Published var showingnewProductView = false
    @Published var posts: [Post] = []
    
    private let db = Firestore.firestore()
    
    func fetchPosts() {
        db.collection("post").addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("No documents")
                    return
                }
                self.posts = documents.compactMap { try? $0.data(as: Post.self) }
                self.sortPost() // Call sort whenever data changes
            }
    }
    
    func sortPost() {
        posts.sort {
            if $0.is_pin == $1.is_pin {
                return $0.createDate > $1.createDate // Sort by date if pin status is the same
            }
            return $0.is_pin && !$1.is_pin // Prioritize pinned posts
        }
    }
    
    
    func fetchUserName(uid: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let name = document.data()?["name"] as? String
                completion(name)
            } else {
                print("User not found or error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
    }
    
    func togglePin(item: Post) {
        let db = Firestore.firestore()
        
        print("Before toggle: \(item.is_pin)")
        
        var updatedPost = item
        updatedPost.toggle_pin()
        try? db.collection("post")
            .document(item.id)
            .setData(from: updatedPost)
        
        print("After toggle: \(item.is_pin)")
    }
}
