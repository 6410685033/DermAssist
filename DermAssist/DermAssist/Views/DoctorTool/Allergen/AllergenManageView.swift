//
//  AllergenManageView.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 1/5/2567 BE.
//

import SwiftUI

struct AllergenManageView: View {
    @StateObject private var viewModel = AllergenViewModel()
    @State private var showingAddAllergen = false
    
    var body: some View {
        List {
            ForEach(viewModel.allergens, id: \.self) { allergen in
                VStack(alignment: .leading) {
                    Text(allergen.allergen_name)
                        .font(.headline)
                    Text(allergen.details)
                        .font(.subheadline)
                }
            }
            .onDelete(perform: viewModel.deleteAllergen)
            Button("Create New Allergy") {
                showingAddAllergen = true
            }
            .sheet(isPresented: $showingAddAllergen) {
                NewAllergenView(isPresented: $showingAddAllergen)
            }
        }
        .navigationTitle("Allergy Management")
        .onChange(of: showingAddAllergen) {
            if !showingAddAllergen {  // When the sheet is dismissed
                viewModel.fetchAllergens()
            }
        }
        .onAppear {
            viewModel.fetchAllergens()
        }
    }
}

#Preview {
    AllergenManageView()
}
