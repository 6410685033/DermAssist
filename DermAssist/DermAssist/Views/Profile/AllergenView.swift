//
//  AllergenView.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 16/4/2567 BE.
//

import SwiftUI

import SwiftUI

struct AllergenView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                    let columns: [GridItem] = [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ]
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(viewModel.myAllergens, id: \.id) { allergen in
                                Text(allergen.allergen_name)
                                    .padding()
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .background(Color.secondary.opacity(0.1))
                                    .cornerRadius(5)
                            }
                        }
                        .padding()
                    }
            }
            .navigationBarTitle("My Allergens", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                isPresented = false
            })
            .onAppear {
                viewModel.load()
                viewModel.fetchMyAllergens()
                viewModel.fetchAllergens()
            }
        }
    }
}


#Preview {
    AllergenView(viewModel: ProfileViewModel(), isPresented: .constant(true))
}
