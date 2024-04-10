//
//  ProfileView.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 10/4/2567 BE.
//

import SwiftUI
import FirebaseFirestoreSwift

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    @State private var showConfirmationAlert = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            if let user = viewModel.user {
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.blue)
                    .frame(width: 125, height: 125)
                VStack(alignment: .leading) {
                    HStack {
                        Text("Name: ")
                        Text(user.name)
                    }
                    HStack {
                        Text("Email: ")
                        Text(user.email)
                    }
                    HStack {
                        Text("Role: ")
                        Text(user.role.displayName)
                    }
                    HStack {
                        Text("Member Since: ")
                        Text("\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .shortened))")
                            .font(.footnote)
                            .foregroundColor(Color(.secondaryLabel))
                    }
                }
                
                Button {
                    viewModel.logOut()
                } label: {
                    Text("Logout")
                }
                
                Button("Delete Account") {
                    // Show confirmation alert
                    showConfirmationAlert = true
                }.foregroundColor(.red)
                .alert("Are you sure you want to delete your account?", isPresented: $showConfirmationAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        viewModel.deleteAccount { success, error in
                            if success {
                                print("account deleted")
                            } else {
                                alertMessage = error?.localizedDescription ?? "An error occurred"
                                showAlert = true
                            }
                        }
                    }
                } message: {
                    Text("This action cannot be undone.")
                }
            
                .alert("Error", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(alertMessage)
                }
        } else {
            Text("Loading Profile...")
            Button {
                viewModel.logOut()
            } label: {
                Text("Log in again")
            }
        }
    }
        .onAppear {
            viewModel.fetchUser()
        }
}
}

#Preview {
    ProfileView(viewModel: ProfileViewModel())
}
