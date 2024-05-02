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
                    
                    myAllergensSection
                    defineAllergensSection
                    
//                    Button("Save Changes") {
//                        viewModel.edit()
//                        presentationMode.wrappedValue.dismiss()
//                    }
                    //                    .buttonStyle(PrimaryButtonStyle())
                }
                .navigationTitle("Edit Profile")
                .navigationBarItems(leading: cancelButton, trailing: saveButton)
            } else {
                Text("Loading Profile...")
            }
        }
        .onAppear {
            viewModel.load()
            viewModel.fetchMyAllergens()
            viewModel.fetchAllergens()
        }
    }
    
    private func editableField(_ label: String, text: Binding<String>) -> some View {
        HStack {
            Text(label).bold()
            TextField("", text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    private var myAllergensSection: some View {
        Section(header: Text("My Allergens")) {
            if viewModel.myAllergens.isEmpty {
                Text("None").foregroundColor(.gray).italic()
            } else {
                ForEach(viewModel.myAllergens, id: \.id) { allergen in
                    allergenRow(allergen, isMyAllergen: true)
                }
            }
        }
    }
    
    private var defineAllergensSection: some View {
        Section(header: Text("Define Allergens")) {
            TextField("Search Allergens", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            ForEach(viewModel.filteredAllergens, id: \.id) { allergen in
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
            }.buttonStyle(BorderlessButtonStyle())
        }
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private var saveButton: some View {
        Button("Save") {
            viewModel.edit()
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    struct PrimaryButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .foregroundColor(.white)
                .padding()
                .background(Color.green)
                .cornerRadius(10)
                .scaleEffect(configuration.isPressed ? 0.95 : 1)
        }
    }
}
