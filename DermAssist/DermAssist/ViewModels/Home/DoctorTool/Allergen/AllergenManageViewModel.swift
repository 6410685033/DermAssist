//
//  AllergenManageViewModel.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 1/5/2567 BE.
//

import Foundation
import FirebaseFirestore

class AllergenViewModel: ObservableObject {
    @Published var allergens = [Allergen]()

    private var db = Firestore.firestore()

    init() {
        fetchAllergens()
    }

    func fetchAllergens() {
        db.collection("allergens").getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }

            self.allergens = snapshot?.documents.compactMap { doc -> Allergen? in
                let data = doc.data()
                guard let createDate = data["createDate"] as? TimeInterval,
                      let allergenName = data["allergen_name"] as? String,
                      let details = data["details"] as? String,
                      let creator = data["creator"] as? String else {
                          return nil
                      }
                return Allergen(createDate: createDate,
                                id: doc.documentID,
                                allergen_name: allergenName,
                                details: details,
                                creator: creator)
            } ?? []
        }
    }
}
