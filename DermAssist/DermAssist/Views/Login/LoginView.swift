//
//  LoginView.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 10/4/2567 BE.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationView {
            // Header with title and subtitle
            VStack(alignment: .center, spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Derm Assist")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text("Find the proper product")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                Spacer()
                
                // Image from file path with adjusted size and styling
                Image("DermAssist_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150) // Adjust size here
                    .clipShape(Circle()) // Apply circular clipping mask
                    .overlay(
                        Circle().stroke(Color.blue, lineWidth: 4)
                    )
                    .shadow(radius: 10) // Add shadow for visual effect
                
                Spacer()
                
                // Form for login credentials
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                        TextField("Email Address", text: $viewModel.email)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                        SecureField("Password", text: $viewModel.password)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    
                    Button(action: viewModel.login) {
                        Text("Log In")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Link to Register View
                NavigationLink("Create an Account", destination: RegisterView())
                    .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
            .padding()
        }
    }
}

#Preview {
    LoginView()
}
