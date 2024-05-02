//
//  RegisterView.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 10/4/2567 BE.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewModel()
    @State private var expandGenderPicker = false // State to control the dropdown expansion
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Create Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.teal)
                    
                    Text("Join our community")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 50)
                
                Spacer()
                
                // Form with enhanced design
                VStack(spacing: 16) {
                    textFieldWithIcon(iconName: "person.fill", placeholder: "Full Name", text: $viewModel.name)
                    textFieldWithIcon(iconName: "envelope", placeholder: "Email Address", text: $viewModel.email)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                    textFieldWithIcon(iconName: "phone.fill", placeholder: "Telephone", text: $viewModel.tel)
                        .keyboardType(.phonePad)
                    
                    // Custom dropdown for gender selection
                    VStack(alignment: .leading, spacing: 10) {
                        Button(action: {
                            withAnimation {
                                expandGenderPicker.toggle()
                            }
                        }) {
                            HStack {
                                Text(viewModel.gender.displayName.isEmpty ? "Select Gender" : viewModel.gender.displayName)
                                    .foregroundColor(viewModel.gender.displayName.isEmpty ? .gray : .primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .rotationEffect(.degrees(expandGenderPicker ? 90 : 0))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        
                        if expandGenderPicker {
                            VStack {
                                ForEach(Gender.allCases, id: \.self) { gender in
                                    Button(action: {
                                        viewModel.gender = gender
                                        withAnimation {
                                            expandGenderPicker = false
                                        }
                                    }) {
                                        Text(gender.displayName)
                                            .padding()
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                    
                    secureFieldWithIcon(iconName: "lock.fill", placeholder: "Password", text: $viewModel.password)
                    
                    Button(action: viewModel.register) {
                        Text("Register")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color.teal)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarHidden(true)
            .padding()
        }
    }
    
    @ViewBuilder
    private func textFieldWithIcon(iconName: String, placeholder: String, text: Binding<String>) -> some View {
        HStack {
            Image(systemName: iconName).foregroundColor(.gray)
            TextField(placeholder, text: text)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    @ViewBuilder
    private func secureFieldWithIcon(iconName: String, placeholder: String, text: Binding<String>) -> some View {
        HStack {
            Image(systemName: iconName).foregroundColor(.gray)
            SecureField(placeholder, text: text)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    RegisterView()
}
