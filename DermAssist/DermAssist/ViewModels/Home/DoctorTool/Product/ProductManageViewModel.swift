//
//  ProductManageViewModel.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 2/5/2567 BE.
//

import Foundation
import FirebaseFirestore

class ProductManageViewModel: ObservableObject {
    @Published var products: [Product] = []
    
    private var db = Firestore.firestore()
    
    init() {
        fetchProducts()
    }
    
    func fetchProducts() {
        db.collection("products").getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            self.products = snapshot?.documents.compactMap { doc -> Product? in
                let data = doc.data()
                guard let name = data["name"] as? String
                else {
                    return nil
                }
                return Product(id: doc.documentID, name: name)
            } ?? []
        }
    }
}

