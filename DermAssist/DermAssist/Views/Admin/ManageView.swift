//
//  ManageView.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 10/4/2567 BE.
//

import SwiftUI

struct ManageView: View {
    @StateObject private var viewModel = ManageViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.users) { user in
                NavigationLink(destination: UserManageView(user: user)) {
                    VStack(alignment: .leading) {
                        Text(user.name).font(.headline)
                        Text(user.email).font(.subheadline)
                        Text(user.role.displayName).font(.caption)
                    }
                }
            }
            .navigationTitle("Manage Users")
            .toolbar {
                Button("Refresh") {
                    viewModel.fetchUsers()
                }
            }
            .onAppear {
                viewModel.fetchUsers()
            }
        }
    }
}

#Preview {
    ManageView()
}
