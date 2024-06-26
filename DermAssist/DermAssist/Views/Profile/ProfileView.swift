//
//  ProfileView.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 10/4/2567 BE.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    @State private var showingEditPage = false
    @State private var showingAllergenPage = false
    @State private var showConfirmationAlert = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                if let user = viewModel.user {
                    VStack(spacing: 20) {
                        profileImage(for: user.role)
                        
                        labeledText("Name", value: user.name)
                        labeledText("Email", value: user.email)
                        labeledText("Telephone", value: user.tel)
                        labeledText("Gender", value: user.gender.displayName)
                        
                        Button("My Allergens") {
                            showingAllergenPage = true
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        
                        Spacer()
                        
                        deleteAccountButton
                        logOutButton
                    }
                    .padding()
                    .navigationBarItems(trailing: editProfileButton)
                    .sheet(isPresented: $showingAllergenPage) {
                        AllergenView(viewModel: viewModel, isPresented: $showingAllergenPage)
                    }
                } else {
                    Text("Loading Profile...")
                    logOutButton
                }
            }
            .navigationTitle("Profile")
            .fullScreenCover(isPresented: $showingEditPage, onDismiss: viewModel.fetchUser) {
                EditProfileView(viewModel: viewModel)
            }
        }
    }
    
    private func profileImage(for role: UserRole) -> some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .padding(.vertical, 20)
            .overlay(
                roleIcon(for: role)
                    .offset(x: 30, y: 10),
                alignment: .bottomTrailing
            )
    }

    private func roleIcon(for role: UserRole) -> some View {
        Image(systemName: icon(for: role))
            .resizable()
            .frame(width: 50, height: 50)
            .background(Color.green)
            .clipShape(Circle())
    }

    private func icon(for role: UserRole) -> String {
        switch role {
        case .patient:
            return "person.crop.circle"
        case .doctor:
            return "stethoscope.circle"
        case .admin:
            return "wrench.and.screwdriver"
        }
    }
    
    private func labeledText(_ label: String, value: String) -> some View {
        HStack {
            Text("\(label):")
                .bold()
            Text(value)
            Spacer()
        }
    }
    
    private var deleteAccountButton: some View {
        Button("Delete Account") {
            showConfirmationAlert = true
        }
        .foregroundColor(.red)
        .alert("Are you sure you want to delete your account?", isPresented: $showConfirmationAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                viewModel.deleteAccount { success, error in
                    if success {
                        print("Account deleted")
                    } else {
                        alertMessage = error?.localizedDescription ?? "An error occurred"
                        showAlert = true
                    }
                }
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }
    
    private var logOutButton: some View {
        Button("Log Out") {
            viewModel.logOut()
        }
        .padding()
        .frame(width: 220, height: 50)
        .background(Color.gray)
        .foregroundColor(.white)
        .clipShape(Capsule())
    }
    
    private var editProfileButton: some View {
        Button(action: { showingEditPage = true }) {
            Image(systemName: "pencil")
        }
    }
}
