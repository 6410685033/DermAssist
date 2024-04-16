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
    
    let layout = [
        GridItem(.fixed(60)),
        GridItem(.flexible(minimum: 40), alignment: .leading)
    ]
    
    var body: some View {
        ZStack{
            VStack{
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 180)
                    .foregroundColor(Color(UIColor(hex: "#387440")))
                    .edgesIgnoringSafeArea(.all)
                Spacer()
            }
            VStack{
                if let user = viewModel.user {
                    Spacer()
                        .frame(maxHeight: 130)
                    ZStack{
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(Color(UIColor(hex: "#ddedb6")))
                        VStack{
                            VStack(alignment: .leading){
                                Text("STAFF")
                                    .font(.system(size: 30))
                                    .foregroundColor(Color(UIColor(hex: "#10621b")))
                                Text("Name-Surname:")
                                ZStack{
                                    RoundedRectangle(cornerRadius: 25)
                                        .foregroundColor(Color.white)
                                        .frame(height: 30)
                                    Text(user.name)
                                        .frame(width: 230, height: 30, alignment: .leading)
                                }
                                Text("Gmail: ")
                                ZStack{
                                    RoundedRectangle(cornerRadius: 25)
                                        .foregroundColor(Color.white)
                                        .frame(height: 30)
                                    ScrollView(.horizontal){
                                        Text(user.email)
                                    }.padding(.horizontal)
                                }
                                Text("Tel: ")
                                ZStack{
                                    RoundedRectangle(cornerRadius: 25)
                                        .foregroundColor(Color.white)
                                        .frame(height: 30)
                                    Text(user.tel)
                                        .frame(width: 230, height: 30, alignment: .leading)
                                }
                                HStack {
                                    Text("Allergen: ")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    if (viewModel.user!.role.isDoctor) {
                                            Button(action: {
                                                showCreateNewAllergen = true
                                            }) {
                                                Image(systemName: "plus.circle.fill")
                                                    .foregroundColor(.green)
                                                    .font(.title)
                                            }
                                        }
                                }
                                
                                VStack{
                                    VStack(spacing: 10) {
                                        ForEach(viewModel.myAllergens, id: \.id) { allergen in
                                            Text(allergen.allergen_name)
                                        }
                                    }
                                    .padding()
                                }
                            }
                            .padding(30)
                            
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
                            
                            TLButton(title: "Log Out", background: Color(UIColor(hex: "#387440"))){
                                viewModel.logOut()
                            }
                            .frame(width: 220, height: 50)
                        }
                    }
                } else {
                    Text("Loading Profile")
                }
            }
            .fullScreenCover(isPresented: $showingEditPage, onDismiss: viewModel.fetchUser) {EditProfileView(viewModel: viewModel)}
            .padding(30)
            .sheet(isPresented: $showCreateNewAllergen) {
                CreateNewAllergenView(CreateNewAllergenPresented: $showCreateNewAllergen)
            }
            
            // Picture
            VStack{
                Spacer().frame(height: 30)
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                    .foregroundColor(Color(UIColor(hex: "#9ed461")))
                Spacer()
            }
            
            // Edit Button
            VStack{
                Spacer().frame(height: 190)
                HStack{
                    Spacer()
                    Button{
                        showingEditPage = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25)
                            .foregroundColor(Color(UIColor(hex: "#6dad53")))
                    }
                }
                Spacer()
            }.padding(.trailing, 60)

        }
    }
}

#Preview {
    ProfileView()
}
