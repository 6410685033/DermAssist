//
//  NewProductView.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 16/4/2567 BE.
//


import SwiftUI

struct NewProductView: View {
    
    @StateObject var viewModel = NewProductViewModel()
    @Binding var newPostPresented: Bool
    
    var body: some View {
        VStack {
            Text("New Product")
                .font(.system(size: 32))
                .bold()
                .padding(.top, 50)
            
            Form {
                TextField("Product Name", text: $viewModel.product_name)
                    .textFieldStyle(DefaultTextFieldStyle())
                TLButton(title: "Save", background: .pink) {
                    viewModel.save()
                    newPostPresented = false
                }
            }
            
        }
    }
}
