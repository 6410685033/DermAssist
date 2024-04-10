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
    @Published var posts: [Post] = []
    
    func fetchPosts() async {
        let db = Firestore.firestore()
        do {
            let snapshot = try await db.collection("post").getDocuments()
            let fetchedPosts = snapshot.documents.compactMap { document in
                try? document.data(as: Post.self)
            }
            // Switch to the main thread to update the published property
            DispatchQueue.main.async {
                self.posts = fetchedPosts
                self.sortPost()
            }
        } catch {
            print("Error fetching posts: \(error)")
        }
    }
    
    func sortPost() {
        posts.sort { $0.createDate > $1.createDate }
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
}
