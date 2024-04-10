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
        if  viewModel.isSignedIn,
            !viewModel.currentUserId.isEmpty {
            accountView
        } 
        else {
            LoginView()
        }
    }
    
    var accountView: some View {
        TabView {
            AnnounceView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "message.fill")
                }
            
            ProfileView(viewModel: ProfileViewModel())
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
            
            if ((viewModel.user?.role.isAdmin) != nil) {
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