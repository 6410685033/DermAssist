//
//  CreateNewAllegenViewModel.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 15/4/2567 BE.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class NewAllegenViewModel: ObservableObject {
    @Published var allergen_name = ""
    @Published var createDate = Date()
    @Published var details = ""
    private var user: User? = nil
    
    init() {
        fetchUser()
    }
    
    func save() {
        guard (Auth.auth().currentUser?.uid) != nil else {
            print("User not logged in")
            return
        }

        let AllergennewId = UUID().uuidString
        let PostnewId = UUID().uuidString
        let newAllergen = Allergen(createDate: Date().timeIntervalSince1970, id: AllergennewId, allergen_name: allergen_name, details: details, creator: user?.id ?? "not define")
        let newPost = Post(is_pin: false, createDate: Date().timeIntervalSince1970, id: PostnewId, title: "New Allergen: "+allergen_name, content: details, creator: user?.id ?? "not define", comments: [], likes: [])
        let db = Firestore.firestore()
        
        db.collection("allergens")
            .document(AllergennewId)
            .setData(newAllergen.asDictionary()) { error in
                if let error = error {
                    print("Error writing document: \(error)")
                } else {
                    print("Document successfully written!")
                }
            }
        db.collection("post")
            .document(PostnewId)
            .setData(newPost.asDictionary()) { error in
                if let error = error {
                    print("Error writing document: \(error)")
                } else {
                    print("Document successfully written!")
                }
            }
    }
    
    func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            DispatchQueue.main.async {
                self?.user = User(
                    id: data["id"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    tel: data["tel"] as? String ?? "",
                    gender: Gender(rawValue: data["gender"] as? String ?? "") ?? .undefined,
                    joined: data["joined"] as? TimeInterval ?? 0,
                    role: UserRole(rawValue: data["role"] as? String ?? "") ?? .patient
                )
            }
        }
    }
}
