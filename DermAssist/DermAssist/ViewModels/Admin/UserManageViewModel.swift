//
//  UserManageViewModel.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 10/4/2567 BE.
//

import Foundation
import FirebaseFirestore

class UserManageViewModel: ObservableObject {
    private let db = Firestore.firestore()
    
    func updateUserDetail(_ user: User, completion: @escaping (Bool, Error?) -> Void) {
        guard let userId = user.id else {
            completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid user ID"]))
            return
        }
        
        db.collection("users").document(userId).setData(user.asDictionary) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
}
