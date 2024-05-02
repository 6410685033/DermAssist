//
//  UserManageView.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 10/4/2567 BE.
//

import SwiftUI

struct UserManageView: View {
    @State var user: User
    @State private var isEditing = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @StateObject private var viewModel = UserManageViewModel()
    let roles = UserRole.allCases
    
    var body: some View {
        Form {
            Section(header: Text("User Info")) {
                if isEditing {
                    TextField("Name", text: $user.name)
                    Picker("Role", selection: $user.role) {
                        ForEach(roles, id: \.self) { role in
                            Text(role.displayName).tag(role)
                        }
                    }
                } else {
                    Text("Name: \(user.name)")
                    Text("Role: \(user.role.displayName)")
                }
            }
            
            Button(isEditing ? "Save" : "Edit") {
                if isEditing {
                    viewModel.updateUserDetail(user) { success, error in
                        if let error = error {
                            alertMessage = error.localizedDescription
                            showingAlert = true
                        } else if success {
                            alertMessage = "User details updated successfully."
                            showingAlert = true
                        }
                    }
                }
                isEditing.toggle()
            }
        }
        .navigationTitle("User Details")
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Update Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    UserManageView(user: User(id: "123", name: "Tony Stark", email: "iron@man.com", tel: "0812345678", gender: .male, joined: Date().timeIntervalSince1970, role: .doctor))
}
