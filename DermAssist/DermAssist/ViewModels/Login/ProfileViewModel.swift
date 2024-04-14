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
    
    init() {
        fetchUser()
    }
    
    func edit() {
        guard validate() else {
            return
        }
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let currentEmail = user?.email ?? ""
        let currentGender = user?.gender ?? "Not Specified"
        let currentJoined = user?.joined ?? Date().timeIntervalSince1970
        let currentRole = user?.role ?? UserRole.patient

        let editUser = User(
            id: uId,
            name: name.isEmpty ? user?.name ?? "" : name,
            email: currentEmail,
            tel: tel.isEmpty ? user?.tel ?? "" : tel,
            gender: currentGender,
            joined: currentJoined,
            role: currentRole
        )

        let db = Firestore.firestore()
        db.collection("users")
            .document(uId)
            .setData(editUser.asDictionary(), merge: true)
    }
    
    private func validate() -> Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !tel.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        guard tel.count == 10 else {
            return false
        }
        return true
    }
    
    func load() {
        tel = user?.tel ?? ""
        name = user?.name ?? ""
    }
    
    func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId).getDocument { [weak self]snapshot, error in
                guard let data = snapshot?.data(), error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    self?.user = User(
                        id: data["id"] as? String ?? "",
                        name: data["name"] as? String ?? "",
                        email: data["email"] as? String ?? "",
                        tel: data["tel"] as? String ?? "",
                        gender: data["gender"] as? String ?? "",
                        joined: data["joined"] as? TimeInterval ?? 0,
                        role: UserRole(rawValue: data["role"] as? String ?? "") ?? .patient
                    )
                }
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
