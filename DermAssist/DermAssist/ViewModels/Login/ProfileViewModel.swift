//
//  ProfileViewModel.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 10/4/2567 BE.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var name = ""
    @Published var tel = ""
    @Published var allergens: [Allergen] = []
    @Published var myAllergens: [Allergen] = []
    
    init() {
        fetchUser()
        fetchAllergens()
    }
    
    
    func edit() {
        guard validate(), let uId = Auth.auth().currentUser?.uid else {
            print("Validation failed or user not logged in")
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uId)
        
        // Update user basic info
        let updatedUser = User(
            id: uId,
            name: name.isEmpty ? user?.name ?? "" : name,
            email: user?.email ?? "",
            tel: tel.isEmpty ? user?.tel ?? "" : tel,
            gender: user?.gender ?? "Not Specified",
            joined: user?.joined ?? Date().timeIntervalSince1970,
            role: user?.role ?? UserRole.patient
        )
        
        userRef.setData(updatedUser.asDictionary(), merge: true) { error in
            if let error = error {
                print("Failed to update user info: \(error.localizedDescription)")
                return
            }
            print("User info updated successfully")
        }
        
        // Update allergens in a subcollection
        let allergensRef = userRef.collection("allergy")
        allergensRef.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let serverAllergensIDs = documents.map { $0.documentID }
            let localAllergensIDs = self.myAllergens.map { $0.id }
            
            // Find IDs to remove (those on the server but not in local list)
            let idsToRemove = Set(serverAllergensIDs).subtracting(localAllergensIDs)
            
            // Remove extraneous allergens from Firestore
            for id in idsToRemove {
                allergensRef.document(id).delete() { error in
                    if let error = error {
                        print("Error removing allergen \(id): \(error.localizedDescription)")
                    } else {
                        print("Successfully removed allergen \(id)")
                    }
                }
            }
            
            // Update or add local allergens to Firestore
            for allergen in self.myAllergens {
                allergensRef.document(allergen.id).setData(allergen.asDictionary(), merge: true) { error in
                    if let error = error {
                        print("Failed to update allergen \(allergen.id): \(error.localizedDescription)")
                    } else {
                        print("Allergen \(allergen.id) updated successfully")
                    }
                }
            }
        }
        
        // Optionally, re-fetch user data to reflect changes
        fetchUser()
    }
    
    
    private func validate() -> Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && tel.count == 10
    }
    
    func load() {
        // Assign loaded user data to published variables
        guard let currentUser = user else { return }
        tel = currentUser.tel
        name = currentUser.name
    }
    
    func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            guard let self = self, let data = snapshot?.data(), error == nil else {
                print("Error fetching user: \(error?.localizedDescription ?? "No data found")")
                return
            }
            
            DispatchQueue.main.async {
                self.user = User(
                    id: data["id"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    tel: data["tel"] as? String ?? "",
                    gender: data["gender"] as? String ?? "",
                    joined: data["joined"] as? TimeInterval ?? 0,
                    role: UserRole(rawValue: data["role"] as? String ?? "") ?? .patient
                )
                
                self.load()  // Process any UI updates with fetched user data
                self.fetchMyAllergens()  // Make sure to fetch allergens here
            }
        }
    }
    
    
    //    func fetchAllergens() {
    //        let db = Firestore.firestore()
    //        db.collection("allergens").getDocuments { [weak self] snapshot, error in
    //            guard let snapshot = snapshot, error == nil else {
    //                print("Error fetching allergens: \(error?.localizedDescription ?? "Unknown error")")
    //                return
    //            }
    //            DispatchQueue.main.async {
    //                self?.allergens = snapshot.documents.compactMap { docSnapshot in
    //                    try? docSnapshot.data(as: Allergen.self)
    //                }
    //            }
    //        }
    //        let myAllergensSet = Set(self.myAllergens)
    //        self.allergens = allergens.filter { !myAllergensSet.contains($0) }
    //    }
    
    func fetchAllergens() {
        let db = Firestore.firestore()
        db.collection("allergens").getDocuments { [weak self] snapshot, error in
            guard let self = self, let snapshot = snapshot, error == nil else {
                print("Error fetching allergens: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            let fetchedAllergens = snapshot.documents.compactMap { docSnapshot -> Allergen? in
                try? docSnapshot.data(as: Allergen.self)
            }
            DispatchQueue.main.async {
                // Filter out allergens that are already in myAllergens
                let myAllergensSet = Set(self.myAllergens)
                self.allergens = fetchedAllergens.filter { !myAllergensSet.contains($0) }
            }
        }
    }
    
    
    func fetchMyAllergens() {
        guard validate(), let uId = Auth.auth().currentUser?.uid else {
            print("not validate")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users/\(uId)/allergy")
            .getDocuments { [weak self] snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    print("Error fetching allergens: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                DispatchQueue.main.async {
                    self?.myAllergens = snapshot.documents.compactMap { docSnapshot in
                        try? docSnapshot.data(as: Allergen.self)
                    }
                }
            }
    }
    
    func add_allergen(_ allergen: Allergen) {
        if let index = allergens.firstIndex(where: { $0.id == allergen.id }) {
            allergens.remove(at: index)
            myAllergens.append(allergen)
        } else {
            // Optionally handle the case where the allergen isn't found in the general list
            // e.g., add it directly to myAllergens if it should be added anyway
            myAllergens.append(allergen)
        }
    }
    
    func remove_allergen(_ allergen: Allergen) {
        // Check if the allergen is present in the user's list
        if let index = myAllergens.firstIndex(where: { $0.id == allergen.id }) {
            // Remove the allergen from the user's list
            myAllergens.remove(at: index)
            allergens.append(allergen)
        } else {
            // Handle the case where the allergen is not in the user's list
            // For example, log an error or inform the user
            print("Allergen not found in the user's list. Cannot remove.")
        }
    }
    
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
    
    func deleteAccount(completion: @escaping (Bool, Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false, nil)  // No user is logged in.
            return
        }
        
        let userId = user.uid
        let db = Firestore.firestore()
        
        // Delete user data from Firestore first
        db.collection("users").document(userId).delete { error in
            if let error = error {
                completion(false, error)
                return
            }
            
            // Once the user data is deleted from Firestore, delete the authentication record
            user.delete { error in
                if let error = error {
                    completion(false, error)
                } else {
                    completion(true, nil)
                }
            }
        }
    }
    
}
