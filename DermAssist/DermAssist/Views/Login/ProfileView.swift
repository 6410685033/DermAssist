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
    @State private var showCreateNewAllergen = false
    @State private var showConfirmationAlert = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                if let user = viewModel.user {
                    ScrollView {
                        VStack(spacing: 20) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200)

                            Text(user.name)
                                .font(.title)
                                .bold()

                            Text(user.email)
                                .foregroundColor(.secondary)

                            Text(user.tel)
                                .foregroundColor(.secondary)

                            if viewModel.user!.role.isDoctor {
                                Button(action: {
                                    showCreateNewAllergen = true
                                }) {
                                    Label("Add Allergen", systemImage: "plus.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }

                            VStack(spacing: 10) {
                                ForEach(viewModel.myAllergens, id: \.id) { allergen in
                                    Text(allergen.allergen_name)
                                }
                            }

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
                            .alert("Error", isPresented: $showAlert) {
                                Button("OK", role: .cancel) {}
                            } message: {
                                Text(alertMessage)
                            }

                            Button("Log Out") {
                                viewModel.logOut()
                            }
                            .padding()
                            .frame(width: 220, height: 50)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                        }
                        .padding()
                    }
                    .navigationBarItems(trailing: Button(action: {
                        showingEditPage = true
                    }) {
                        Image(systemName: "gearshape.fill")
                    })
                } else {
                    Text("Loading Profile")
                }
            }
            .navigationTitle("Profile")
            .fullScreenCover(isPresented: $showingEditPage, onDismiss: viewModel.fetchUser) {
                EditProfileView(viewModel: viewModel)
            }
            .sheet(isPresented: $showCreateNewAllergen) {
                CreateNewAllergenView(CreateNewAllergenPresented: $showCreateNewAllergen)
            }
        }
    }
}

#Preview {
    ProfileView()
}
