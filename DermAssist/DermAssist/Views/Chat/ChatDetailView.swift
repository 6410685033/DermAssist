//
//  ChatDetailView.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//

import SwiftUI
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
                            .id(message.id)
                    }
                }
                .onAppear {
                    scrollToLastMessage(using: scrollViewProxy)
                }
                .onChange(of: viewModel.messages) { _ in
                    scrollToLastMessage(using: scrollViewProxy)
                }
            }
            
            Divider()
            HStack {
                PharmacyButton(locationManager: locationManager, pharmacyManager: pharmacyManager)
                productAmountPicker
                productPicker
                sendButton
            }
            .padding()
        }
    }
    
    private func scrollToLastMessage(using scrollViewProxy: ScrollViewProxy) {
        if let lastMessage = viewModel.messages.last {
            scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
    
    private var productAmountPicker: some View {
        VStack(alignment: .leading) {
            Text("Amount")
                .font(.caption)
                .foregroundColor(.secondary)
            Picker("Select Amount", selection: $viewModel.selectedAmount) {
                ForEach(viewModel.amounts, id: \.self) { amount in
                    Text("\(amount)").tag(amount)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
    
    private var productPicker: some View {
        VStack(alignment: .leading) {
            Text("Product")
                .font(.caption)
                .foregroundColor(.secondary)
            Picker("Select Product", selection: $newMessage) {
                Text("-").tag("-")  // Default option
                ForEach(viewModel.products, id: \.name) { product in
                    Text(product.name)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
    
    private var sendButton: some View {
        Button {
            viewModel.sendNewMessage(content: newMessage)
            newMessage = ""
        } label: {
            Image(systemName: "paperplane.fill").foregroundColor(.white)
        }
        .buttonStyle(PrimaryButtonStyle())
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}


struct PharmacyButton: View {
    @ObservedObject var locationManager: LocationManager
    @ObservedObject var pharmacyManager: PharmacyManager
    @State private var showingPharmacySheet = false
    
    var body: some View {
        Button(action: {
            Task {
                do {
                    showingPharmacySheet = true
                    let location = try await locationManager.requestLocation()
                    await pharmacyManager.fetchNearbyPharmacies(latitude: location.latitude, longitude: location.longitude)
                } catch {
                    print("Error getting location or fetching pharmacy data: \(error)")
                }
            }
        }) {
            Image(systemName: "mappin.and.ellipse")
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .clipShape(Circle())
        }
        .disabled(locationManager.isLoading || pharmacyManager.isLoading)
        .sheet(isPresented: $showingPharmacySheet) {
            if locationManager.isLoading || pharmacyManager.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(1.5)
            } else {
                PharmacyList(pharmacies: $pharmacyManager.pharmacies)
            }
        }
    }
}

struct PharmacyList: View {
    @Binding var pharmacies: [Pharmacy]
    
    var body: some View {
        List {
            ForEach(pharmacies.sorted(by: { $0.distance < $1.distance }), id: \.id) { pharmacy in
                VStack(alignment: .leading) {
                    if let url = pharmacy.googleMapsURL {
                        Link(pharmacy.name, destination: url)
                            .font(.title3)
                            .foregroundColor(.blue)
                        Text("Distance: \(pharmacy.formattedDistance)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    } else {
                        Text(pharmacy.name)
                            .font(.title3)
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .listStyle(PlainListStyle())
    }
}
