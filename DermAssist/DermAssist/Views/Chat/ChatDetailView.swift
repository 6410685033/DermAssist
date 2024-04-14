//
//  ChatDetailView.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//

import SwiftUI
import FirebaseFirestoreSwift
import CoreLocationUI

struct ChatDetailsView: View {
    @StateObject var locationManager = LocationManager()
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
                // Pharmacy near me
                PharmacyButton(locationManager: locationManager, viewModel: viewModel)
                
                // Input box
                TextField("What skin product would you like?", text: $newMessage, axis: .vertical)
                    .padding(5)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                
                // Send button
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

struct PharmacyButton: View {
    @ObservedObject var locationManager: LocationManager
    @ObservedObject var viewModel: ChatDetailsViewModel
    
    var body: some View {
        LocationButton(.currentLocation) {
            Task {
                locationManager.requestLocation()
                await viewModel.fetchPharmacy()
            }
        }
        .labelStyle(.iconOnly)  // Emphasizes the icon, minimal text
        .symbolVariant(.fill)   // Filled style for the icon
        .foregroundColor(.white)
        .background(Color.blue)
        .clipShape(Circle())    // Makes the button circular
        .sheet(isPresented: $viewModel.showingPharmacy) {
            if viewModel.loadingPharmacy || locationManager.isLoading {
                //                Text("Loading...")
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(1.5)
            } else if let pharmacyText = viewModel.pharmacy {
                Text(pharmacyText)
            } else {
                Text("No pharmacy data available.")
            }
        }
        
    }
}
