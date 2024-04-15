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
    @StateObject var pharmacyManager = PharmacyManager()
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
                PharmacyButton(locationManager: locationManager, pharmacyManager: pharmacyManager)
                
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
    @ObservedObject var pharmacyManager: PharmacyManager
    @State var showingPharmacySheet = false
    
    var body: some View {
        LocationButton(.currentLocation) {
            Task {
                do {
                    showingPharmacySheet = true
                    let location = try await locationManager.requestLocation()
                    await pharmacyManager.fetchNearbyPharmacies(latitude: location.latitude, longitude: location.longitude)
                } catch {
                    print("Error getting location or fetching pharmacy data: \(error)")
                }
            }
        }
        .labelStyle(.iconOnly)
        .symbolVariant(.fill)
        .foregroundColor(.white)
        .background(Color.blue)
        .clipShape(Circle())
        .disabled(locationManager.isLoading || pharmacyManager.isLoading)
        .sheet(isPresented: $showingPharmacySheet) {
            if locationManager.isLoading || pharmacyManager.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(1.5)
            } else {
                PharmacyList(pharmacies: pharmacyManager.pharmacies)
            }
        }
    }
}

struct PharmacyList: View {
    let pharmacies: [Pharmacy]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Pharmacy Nearby")
                .font(.title)
                .padding()
            
            Divider()  // Add a divider below the heading
            
            List {
                ForEach(pharmacies, id: \.id) { pharmacy in
                    if let url = pharmacy.googleMapsURL {
                        Link(pharmacy.name, destination: url)
                            .foregroundColor(.cyan)
                            .font(.title3)
                            .padding(.vertical, 8)
                    } else {
                        Text(pharmacy.name)
                            .font(.title3)
                            .padding(.vertical, 8)
                    }
                }
            }
            .listStyle(PlainListStyle())  // Use a plain list style
            
            Spacer()  // Add a spacer at the bottom to push content upwards
        }
        .background(Color(.systemBackground))  // Set background color to system background color
    }
}



