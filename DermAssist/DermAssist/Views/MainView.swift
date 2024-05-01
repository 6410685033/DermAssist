//
//  MainView.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 10/4/2567 BE.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()

    var body: some View {
        Group {
            if viewModel.isSignedIn, let user = viewModel.user {
                accountView(for: user)
            } else {
                LoginView()
            }
        }
    }

    @ViewBuilder
    private func accountView(for user: User) -> some View {
        TabView {
            HomeView(user: user)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            ChatView(userId: viewModel.currentUserId)
                .tabItem {
                    Label("Chat", systemImage: "message.fill")
                }
            
            ProfileView(viewModel: ProfileViewModel())
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
            
            if user.role.isAdmin {
                ManageView()
                    .tabItem {
                        Label("Manage",systemImage: "person.2.badge.gearshape" )
                    }
            }
        }
    }
}

#Preview {
    MainView()
}
