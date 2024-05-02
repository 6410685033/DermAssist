//
//  ProductManageView.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 1/5/2567 BE.
//

import SwiftUI

struct ProductManageView: View {
    @StateObject private var viewModel = ProductManageViewModel()
    @State private var showingNewProduct = false
    
    var body: some View {
        List {
            ForEach(viewModel.products, id: \.id) { product in
                VStack(alignment: .leading) {
                    Text(product.name)
                }
            }
            .onDelete(perform: viewModel.deleteProduct)  // Handle deletion
            Button("Create New Product") {
                showingNewProduct = true
            }
            .sheet(isPresented: $showingNewProduct) {
                NewProductView(isPresented: $showingNewProduct)
            }
        }
        .navigationTitle("Product Management")
        .onAppear {
            viewModel.fetchProducts()
        }
        .onChange(of: showingNewProduct) {
            if !showingNewProduct {  // When the sheet is dismissed
                viewModel.fetchProducts()
            }
        }
    }
}

#Preview {
    ProductManageView()
}
