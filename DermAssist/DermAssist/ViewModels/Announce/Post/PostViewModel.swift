//
//  PostViewModel.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class PostViewModel: ObservableObject {
    @Published var post: Post?
    
    init(postId: String) {
        fetchPost(postId: postId)
    }
    
    var currentUserIsCreator: Bool {
        let currentUserId = Auth.auth().currentUser?.uid
        return post?.creator == currentUserId
    }
    
    
    // Post section
    var formattedCreateDate: String {
        guard let postDate = post?.createDate else { return "" }
        let date = Date(timeIntervalSince1970: postDate)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    // Comment section
    func formattedDate(for timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func fetchPost(postId: String) {
        // get every post
        let db = Firestore.firestore()
        let docRef = db.collection("post").document(postId)
        
        docRef.getDocument { (snapshot, error) in
            if let document = snapshot, document.exists {
                do {
                    self.post = try document.data(as: Post.self)
                } catch {
                    print("Error decoding post: \(error)")
                }
            } else {
                print("Document does not exist: \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    func comment(content: String) {
        // get post
        guard let postId = self.post?.id else {
            print("Post ID is unavailable.")
            return
        }
        
        // get user
        guard let uId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        // find post in firebase
        let db = Firestore.firestore()
        let postRef = db.collection("post").document(postId)
        
        // create new comment object
        let newComment = Comment(is_pin: false, createDate: Date().timeIntervalSince1970, id: UUID().uuidString, authorId: uId, content: content)
        
        // add comment to comment field
        postRef.updateData([
            "comments": FieldValue.arrayUnion([newComment.asDictionary])
        ]) { error in
            if let error = error {
                print("Error adding comment: \(error.localizedDescription)")
            } else {
                print("Comment successfully added.")
                self.post?.comments.append(newComment)
            }
        }
    }
    
    func likePost() {
        // get user and post
        guard let userId = Auth.auth().currentUser?.uid, let postId = self.post?.id else {
            print("User not logged in or post ID unavailable.")
            return
        }
        
        // find user in firebase
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] (document, error) in
            guard let document = document, document.exists else {
                print("User document does not exist: \(error?.localizedDescription ?? "")")
                return
            }
            
            // get user and post to like
            do {
                let user = try document.data(as: User.self)
                let postRef = db.collection("post").document(postId)
                
                // add user to likes field
                postRef.updateData([
                    "likes": FieldValue.arrayUnion([user.asDictionary()])
                ]) { error in
                    if let error = error {
                        print("Error updating likes: \(error.localizedDescription)")
                    } else {
                        print("Post successfully liked.")
                        DispatchQueue.main.async {
                            self?.post?.likes.append(user)
                        }
                    }
                }
            } catch let error {
                print("Error decoding user: \(error.localizedDescription)")
            }
        }
    }
    
    func unlikePost() {
        // get user and post
        guard let userId = Auth.auth().currentUser?.uid, let postId = post?.id else {
            print("User not logged in or post ID unavailable.")
            return
        }
        
        // find user in firebase
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] (document, error) in
            guard let self = self, let document = document, document.exists else {
                print("User document does not exist: \(error?.localizedDescription ?? "")")
                return
            }
            
            // get user and post to like
            do {
                let user = try document.data(as: User.self)
                let postRef = db.collection("post").document(postId)
                
                // remove user from likes field
                postRef.updateData([
                    "likes": FieldValue.arrayRemove([user.asDictionary()])
                ]) { error in
                    if let error = error {
                        print("Error updating likes: \(error.localizedDescription)")
                    } else {
                        print("Unlike post successfully.")
                        DispatchQueue.main.async {
                            // Safely find the index and remove it from the likes array
                            if let index = self.post?.likes.firstIndex(where: { $0.id == userId }) {
                                self.post?.likes.remove(at: index)
                            }
                        }
                    }
                }
            } catch let error {
                print("Error decoding user: \(error.localizedDescription)")
            }
        }
    }
    
    
    func toggleLike() {
        if isLiked {
            unlikePost()
        } else {
            likePost()
        }
    }
    
    func editPost(newTitle: String, newContent: String) {
        // Ensure we have a post ID and a user is logged in
        guard let postId = self.post?.id else {
            print("Post ID is unavailable.")
            return
        }
        
        // find post in firebase
        let db = Firestore.firestore()
        let postRef = db.collection("post").document(postId)
        
        // update post content
        postRef.updateData([
            "content": newContent
        ]) { error in
            if let error = error {
                print("Error updating post: \(error.localizedDescription)")
            } else {
                print("Post successfully updated.")
                DispatchQueue.main.async {
                    self.post?.title = newTitle
                    self.post?.content = newContent
                }
            }
        }
    }
    
    func deletePost() {
        guard let postId = self.post?.id else {
            print("Post ID is unavailable.")
            return
        }
        
        // find post in firebase and delete
        let db = Firestore.firestore()
        let postRef = db.collection("post").document(postId)
        
        postRef.delete() { error in
            if let error = error {
                print("Error removing post: \(error.localizedDescription)")
            } else {
                print("Post successfully deleted.")
                DispatchQueue.main.async {
                    self.post = nil
                }
            }
        }
    }
    
}
