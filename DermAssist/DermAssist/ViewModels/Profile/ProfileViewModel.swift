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
    @Published var gender: Gender = .undefined
    @Published var role = ""
    @Published var allergens: [Allergen] = []
    @Published var myAllergens: [Allergen] = []
    
    init() {
        fetchUser()
        fetchMyAllergens()
        fetchAllergens()
    }
    
    func edit() {
        guard let uId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uId)
        
        let updatedUser = User(id: uId, name: name, email: user?.email ?? "", tel: tel, gender: gender, joined: user?.joined ?? Date().timeIntervalSince1970, role: user?.role ?? .patient)
        
        do {
            try userRef.setData(from: updatedUser) { [weak self] error in
                if let error = error {
                    print("Error updating user: \(error.localizedDescription)")
                } else {
                    print("User successfully updated")
                    self?.updateAllergens(uId: uId, db: db) // Update the allergens after user is updated
                }
            }
        } catch {
            print("Failed to encode user: \(error)")
        }
        
        // After updating the user, update the local user instance
        self.user = updatedUser
    }

    private func updateAllergens(uId: String, db: Firestore) {
        let allergensRef = db.collection("users").document(uId).collection("allergy")
        for allergen in myAllergens {
            do {
                try allergensRef.document(allergen.id).setData(from: allergen)
            } catch {
                print("Error setting allergen data: \(error)")
            }
        }
    }
    
    
    private func validate() -> Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && tel.count == 10
    }
    
    func load() {
        guard let currentUser = user else { return }
        name = currentUser.name
        tel = currentUser.tel
        gender = currentUser.gender // Make sure the gender is set correctly from the user data
    }
    
    func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            guard let self = self, let snapshot = snapshot, let data = snapshot.data(), error == nil else {
                print("Error fetching user: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                self.user = try snapshot.data(as: User.self)
                self.load() // Update local properties with fetched data
            } catch {
                print("Error decoding user: \(error)")
            }
        }
    }
    
    
    func fetchAllergens() {
        print("Do fetchAllergens()")
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
        print("finish fetchAllergens()")
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
        print("Do fetchMyAllergens()")
        print(self.myAllergens)
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
