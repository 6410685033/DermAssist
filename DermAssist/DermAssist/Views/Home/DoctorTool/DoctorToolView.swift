//
//  DoctorToolView.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 1/5/2567 BE.
//

import SwiftUI

struct DoctorToolView: View {
    @State private var showingAddProduct = false
    @State private var showingAddAllergen = false
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: NewProductView(isPresented: $showingAddProduct)) {
                    Text("Create New Product")
                }
                NavigationLink(destination: NewAllergenView(isPresented: $showingAddAllergen)) {
                    Text("Create New Allergy")
                }
            }
            .navigationTitle("Doctor Tools")
        }
    }
}

#Preview {
    DoctorToolView()
}
