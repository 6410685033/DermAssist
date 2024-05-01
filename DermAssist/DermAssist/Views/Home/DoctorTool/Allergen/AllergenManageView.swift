//
//  AllergenManageView.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 1/5/2567 BE.
//

import SwiftUI

struct AllergenManageView: View {
    @State private var showingAddAllergen = false
    
    var body: some View {
        List {
            Button("Create New Allergy") {
                showingAddAllergen = true
            }
            .sheet(isPresented: $showingAddAllergen) {
                NewAllergenView(isPresented: $showingAddAllergen)
            }
            
        }
        .navigationTitle("Allergy Management")
        
    }
}

#Preview {
    AllergenManageView()
}
