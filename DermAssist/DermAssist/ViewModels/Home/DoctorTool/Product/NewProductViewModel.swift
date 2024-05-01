//
//  NewProductViewModel.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 16/4/2567 BE.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class NewProductViewModel: ObservableObject {
    @Published var product_name = ""
    
    func save() {
        guard let uId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        let newId = UUID().uuidString
        let newProduct = Product(id: newId, name: product_name)
        let db = Firestore.firestore()
        
        db.collection("products")
            .document(newId)
            .setData(newProduct.asDictionary()) { error in
                if let error = error {
                    print("Error writing document: \(error)")
                } else {
                    print("Document successfully written!")
                }
            }
    }

}
