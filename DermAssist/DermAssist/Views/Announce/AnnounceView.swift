//
//  AnnounceView.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//


import SwiftUI

struct AnnounceView: View {
    @StateObject var viewModel = AnnounceViewModel()
    var user: User
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.posts, id: \.id) { post in
                    AnnounceItemView(viewModel: viewModel, item: post, user: user)
                        .padding(.vertical, 4)
                }
                .listStyle(PlainListStyle())
                .animation(.default, value: viewModel.posts)
            }
            .navigationTitle("Announcements")
            .navigationBarItems(trailing: user.role.isDoctor || user.role.isAdmin ? addButton : nil)
            .sheet(isPresented: $viewModel.showingnewPostView) {
                NewPostView(newPostPresented: $viewModel.showingnewPostView)
            }
            .onAppear {
                Task {
                    viewModel.fetchPosts()
                }
            }
            .onChange(of: viewModel.showingnewPostView) {
                if !viewModel.showingnewPostView {
                    Task {
                        viewModel.fetchPosts()
                    }
                }
            }
        }
    }
    
    private var addButton: some View {
        Button(action: {
            viewModel.showingnewPostView = true
        }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 24, height: 24)
        }
    }
}

#Preview {
    AnnounceView(user: .init(id: "123", name: "John", email: "john@mail.com", tel: "0812345643", gender: .male, joined: Date().timeIntervalSince1970, role: .patient))
}
