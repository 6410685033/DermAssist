//
//  EditProfileView.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 15/4/2567 BE.
//

import SwiftUI

struct EditProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    let layout = [
        GridItem(.fixed(150), alignment: .leading),
        GridItem(.flexible(minimum: 40), alignment: .leading)
    ]
    
    var body: some View {
        if let user = viewModel.user {
            Form {
                LazyVGrid(columns: layout, content: {
                    Text("Gmail:")
                    ScrollView(.horizontal){
                        Text(user.email)
                            .foregroundStyle(Color.gray)
                    }
                    
                    Text("Gender:")
                    Text(user.gender)
                        .foregroundStyle(Color.gray)
                    
                    Text("Full Name:")
                    TextField("Full Name:", text: $viewModel.name)
                        .textFieldStyle(DefaultTextFieldStyle())
                    
                    Text("Telephone:")
                    TextField("Telephone", text: $viewModel.tel)
                        .textFieldStyle(DefaultTextFieldStyle())
                })
                
                
                Text("My Allergens: ")
                    .frame(maxWidth: .infinity, alignment: .leading)
                ZStack {
                    VStack(spacing: 10) {
                        ForEach(viewModel.myAllergens, id: \.id) { allergen in
                            Text(allergen.allergen_name)
                        }
                    }
                    .padding()
                }
                
                Text("Define Allergens")
                ZStack {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(viewModel.allergens, id: \.id) { allergen in
                                HStack {
                                    Text(allergen.allergen_name)
                                    Spacer()
                                    Button(action: {
                                        viewModel.add_allergen(allergen)
                                    }) {
                                        Image(systemName: "plus")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 25)
                                            .foregroundColor(Color(UIColor(hex: "#6dad53")))
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
                
                TLButton(title: "Save", background: .green) {
                    viewModel.edit()
                    self.presentationMode.wrappedValue.dismiss()
                }
                .onAppear{
                    viewModel.load()
                }
            }
            .offset(y: -50)
            
        } else {
            Text("Loading")
        }
    }
}

// Preview code
struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
