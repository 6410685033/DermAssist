//
//  UserManageView.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 10/4/2567 BE.
//

import SwiftUI

import SwiftUI

struct UserManageView: View {
    @State var user: User
    @State private var isEditing = false
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
                    // Call the update method
                    viewModel.updateUserDetail(user) { success, error in
                        if let error = error {
                            // Handle the error, maybe show an alert
                            print("Error: \(error.localizedDescription)")
                        } else if success {
                            // Handle the success, maybe show a confirmation message
                            print("User details updated successfully")
                        }
                    }
                }
                isEditing.toggle()
            }
        }
        .navigationTitle("User Details")
    }
}

#Preview {
    UserManageView(user: User.init(id: "123", name: "Tony Stark", email: "iron@man.com", tel: "0812345678", gender: "Male", joined: Date().timeIntervalSince1970, role: .doctor))
}
