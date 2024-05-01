//
//  EditProfileView.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 15/4/2567 BE.
//

import SwiftUI

struct EditProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            if let user = viewModel.user {
                Form {
                    Section(header: Text("Profile")) {
                        editableField("Full Name:", text: $viewModel.name)
                        editableField("Telephone:", text: $viewModel.tel)
                        
                        Picker("Gender:", selection: $viewModel.gender) {
                            ForEach(Gender.allCases, id: \.self) { gender in
                                Text(gender.displayName).tag(gender)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        Text("Email: \(user.email)").foregroundColor(.gray)
                        Text("Role: \(user.role.displayName)").foregroundColor(.gray)
                    }
                    
                    allergenSection
                    
                    Button("Save Changes") {
                        viewModel.edit()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
                }
                .navigationTitle("Edit Profile")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            } else {
                Text("Loading Profile...")
            }
        }
        .onAppear {
            viewModel.load()
        }
    }
    
    private func editableField(_ label: String, text: Binding<String>) -> some View {
        HStack {
            Text(label).bold()
            TextField("", text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    
    
    private var allergenSection: some View {
        Section(header: Text("My Allergens")) {
            ForEach(viewModel.myAllergens, id: \.id) { allergen in
                allergenRow(allergen, isMyAllergen: true)
            }
            ,
            Text("Define Allergens").bold()
            ForEach(viewModel.allergens, id: \.id) { allergen in
                if !viewModel.myAllergens.contains(allergen) {
                    allergenRow(allergen, isMyAllergen: false)
                }
            }
            
        }
    }
    
    private func allergenRow(_ allergen: Allergen, isMyAllergen: Bool) -> some View {
        HStack {
            Text(allergen.allergen_name)
            Spacer()
            Button(action: {
                isMyAllergen ? viewModel.remove_allergen(allergen) : viewModel.add_allergen(allergen)
            }) {
                Image(systemName: isMyAllergen ? "trash" : "plus")
                    .foregroundColor(Color(UIColor.systemGreen))
            }
        }
    }
}

// Preview code
struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(viewModel: ProfileViewModel())
    }
}
