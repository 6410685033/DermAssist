//
//  ChatDetailView.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//

import SwiftUI
import FirebaseFirestoreSwift

struct ChatDetailsView: View {
    @StateObject var viewModel: ChatDetailsViewModel
    @State private var newMessage = ""
    
    init(itemId: String) {
        _viewModel = StateObject(wrappedValue: ChatDetailsViewModel(itemId: itemId))
    }
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    ForEach(viewModel.messages) { message in
                        MessageView(message: message)
                            .padding(5)
                            .id(message.id)  // Ensure each message has a unique ID
                    }
                }
                .onAppear {
                    if let lastMessage = viewModel.messages.last {
                        scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
                .onChange(of: viewModel.messages) { _ in
                    if let lastMessage = viewModel.messages.last {
                        scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
            
            Divider()
            HStack {
                Button {
                    Task {
                        await viewModel.fetchPharmacy()
                    }
                }label: {
                    Image(systemName: "mappin.and.ellipse")
                }
                .sheet(isPresented: $viewModel.showingPharmacy) {
                    if let pharmacyText = viewModel.pharmacy {
                        Text(pharmacyText)
                    } else {
                        Text("No pharmacy data available.")
                    }
                }
                TextField("What skin product would you like?", text: $newMessage, axis: .vertical)
                    .padding(5)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                Button {
                    viewModel.sendNewMessage(content: newMessage)
                    newMessage = ""
                } label: {
                    Image(systemName: "paperplane")
                }
            }
            .padding()
        }
    }
}
