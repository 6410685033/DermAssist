//
//  RegisterView.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 10/4/2567 BE.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewModel()
    
    var body: some View {
        VStack {
            HeaderView(title: "Register", subtitle: "Getting to know", angle: -15, background: .teal)
            Form {
                Section(header: Text("Detail")) {
                    TextField("Full Name", text: $viewModel.name)
                        .textFieldStyle(DefaultTextFieldStyle())
                    TextField("Email Address", text: $viewModel.email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                    TextField("Telephone", text: $viewModel.tel)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .keyboardType(.phonePad)
                }
                
                Section(header: Text("Gender")) {
                    Picker("Select your gender", selection: $viewModel.gender) {
                        ForEach(Gender.allCases, id: \.self) { gender in
                            Text(gender.displayName).tag(gender)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Section(header: Text("Password")) {
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(DefaultTextFieldStyle())
                }
                
                TLButton(title: "Create Account", background: .teal) {
                    viewModel.register()
                }
            }
            .offset(y: -50)
            
            Spacer()
            
        }
    }
}

#Preview {
    RegisterView()
}
