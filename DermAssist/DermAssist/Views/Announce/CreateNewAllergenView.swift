//
//  CreateNewAllergenView.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 15/4/2567 BE.
//

import SwiftUI

struct CreateNewAllergenView: View {
    @StateObject var viewModel = CreateNewAllegenViewModel()
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            Text("New Allergen")
                .font(.system(size: 32))
                .bold()
                .padding(.top, 50)
            
            Form {
                TextField("Allergen", text: $viewModel.allergen_name)
                    .textFieldStyle(DefaultTextFieldStyle())
                TextField("Details", text: $viewModel.details)
                    .textFieldStyle(DefaultTextFieldStyle())
                TLButton(title: "Create", background: .pink) {
                    viewModel.save()
                    isPresented = false
                }
            }
        }
    }
}
