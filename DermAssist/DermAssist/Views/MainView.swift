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
        } else {
            LoginView()
        }
    }
    
    var accountView: some View {
        TabView {
//            NoteView(userId: viewModel.currentUserId)
//                .tabItem {
//                    Label("Home", systemImage: "house")
//                }
            
            ProfileView(viewModel: ProfileViewModel())
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}

#Preview {
    MainView()
}
