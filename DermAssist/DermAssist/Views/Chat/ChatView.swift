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
    @FirestoreQuery var items: [ChatRoom]
    
    init(userId: String) {
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/chats")
        self._viewModel = StateObject(wrappedValue: ChatViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(items) { item in
                    ChatItemView(item: item)
                        .swipeActions {
                            Button {
                                viewModel.delete(id: item.id)
                            } label: {
                                Image(systemName: "trash.fill")
                            }
                        }
                        .tint(.red)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Chats")
            .toolbar {
                Button {
                    viewModel.showingnewItemView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $viewModel.showingnewItemView) {
                NewChatView(newItemPresented: $viewModel.showingnewItemView)
            }
        }
    }
}
