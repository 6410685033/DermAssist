//
//  ProductManageView.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 1/5/2567 BE.
//

import SwiftUI

struct ProductManageView: View {
    @State private var showingNewProduct = false
    
    var body: some View {
        NavigationView {
            List {
                Button("Create New Product") {
                    showingNewProduct = true
                }
                .sheet(isPresented: $showingNewProduct) {
                    NewProductView(isPresented: $showingNewProduct)
                }}
        }
        .navigationTitle("Product Management")
    }
}


#Preview {
    ProductManageView()
}
