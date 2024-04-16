//
//  ChatView.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//

import SwiftUI
import FirebaseFirestoreSwift

struct ChatView: View {
    @StateObject var viewModel: ChatViewModel
    
    init(userId: String) {
        self._viewModel = StateObject(wrappedValue: ChatViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.chats) { chat in
                    ChatItemView(item: chat)
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.delete(id: chat.id)
                            } label: {
                                Image(systemName: "trash.fill")
                            }
                        }
                }
                .listStyle(PlainListStyle())
                .animation(.default, value: viewModel.chats)  // Apply animation whenever the chats array changes
            }
            .navigationTitle("Chats")
            .toolbar {
                Button {
                    viewModel.showingNewItemView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $viewModel.showingNewItemView) {
                NewChatView(newItemPresented: $viewModel.showingNewItemView)
            }
        }
    }
}
