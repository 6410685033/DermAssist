//
//  AnnounceView.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//


import SwiftUI

struct AnnounceView: View {
    @StateObject var viewModel = AnnounceViewModel()
    @State private var showConfigMenu = false
    @State private var showingAddProduct = false
    @State private var showingAddAllergen = false
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
                configButton
            }
            .sheet(isPresented: $viewModel.showingnewPostView) {
                NewPostView(newPostPresented: $viewModel.showingnewPostView)
            }
            .sheet(isPresented: $showingAddProduct) {
                NewProductView(isPresented: $showingAddProduct)
            }
            .sheet(isPresented: $showingAddAllergen) {
                CreateNewAllergenView(isPresented: $showingAddAllergen)
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
    
    private var configButton: some View {
        Button(action: {
            self.showConfigMenu = true
        }) {
            Image(systemName: "ellipsis.circle")
                .imageScale(.large)
                .foregroundColor(Color(UIColor(hex: "#387440")))
        }
        .actionSheet(isPresented: $showConfigMenu) {
            ActionSheet(
                title: Text("Options"),
                buttons: [
                    .default(Text("Add Product")) {
                        self.showingAddProduct = true
                    },
                    .default(Text("Add Allergen")) {
                        self.showingAddAllergen = true
                    },
                    .cancel()
                ]
            )
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
