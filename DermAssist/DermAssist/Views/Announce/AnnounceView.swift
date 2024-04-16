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
                    AnnounceItemView(item: post, user: user)
                }.listStyle(PlainListStyle())
                    .animation(.default, value: viewModel.posts)
            }
            .navigationTitle("Announcements")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if user.role.isDoctor || user.role.isAdmin {
                        HStack {
                            Text("New Product")
                            Button(action: {
                                viewModel.showingnewProductView = true
                            }) {
                                Image(systemName: "plus")
                            }
                            
                            Text("New Post")
                            Button(action: {
                                viewModel.showingnewPostView = true
                            }) {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingnewPostView) {
                NewPostView(newPostPresented: $viewModel.showingnewPostView)
            }
            .sheet(isPresented: $viewModel.showingnewProductView) {
                NewProductView(newPostPresented: $viewModel.showingnewProductView)
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
}

// Formatter for displaying the post's creation date
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    AnnounceView(user: .init(id: "123", name: "John", email: "john@mail.com", tel: "0812345643", gender: .male, joined: Date().timeIntervalSince1970, role: .patient))
}
