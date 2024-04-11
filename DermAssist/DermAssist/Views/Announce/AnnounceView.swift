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
                    NavigationLink(destination: PostView(viewModel: PostViewModel(postId: post.id))) {
                        AnnounceItemView(item: post)
                    }
                }
            }
            .navigationTitle("Announcements")
            .toolbar {
                if (user.role.isDoctor) {
                    Button {
                        viewModel.showingnewPostView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingnewPostView) {
                NewPostView(newPostPresented: $viewModel.showingnewPostView)
            }
            .onAppear {
                Task {
                    await viewModel.fetchPosts()
                }
            }
            .onChange(of: viewModel.showingnewPostView) {
                if !viewModel.showingnewPostView {
                    Task {
                        await viewModel.fetchPosts()
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
    AnnounceView(user: .init(id: "123", name: "John", email: "john@mail.com", tel: "0812345643", gender: "Male", joined: Date().timeIntervalSince1970, role: .patient))
//    AnnounceView(user: .init(id: "123", name: "John", email: "john@mail.com", tel: "0812345643", gender: "Male", joined: Date().timeIntervalSince1970, role: .doctor))
}
