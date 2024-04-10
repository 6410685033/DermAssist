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
    
    init(itemId: String) {
        _viewModel = StateObject(wrappedValue: ChatDetailsViewModel(itemId: itemId))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if let item = viewModel.item {
                    VStack(alignment: .leading, spacing: 10) {
                        // Uncomment and use your actual UI components
                        // Text(item.chat_name)
                        //     .font(.largeTitle)
                        //     .fontWeight(.bold)
                        //     .padding(.bottom, 10)
                        
                        // Text(item.messages.first?.message ?? "")
                        //     .font(.body)
                        //     .multilineTextAlignment(.leading)
                        //     .padding(.bottom, 10)
                        
                        // Assuming createDate is a property of item, not create_at
                        // Text("\(Date(timeIntervalSince1970: item.createDate).formatted(date: .abbreviated, time: .shortened))")
                        //     .font(.footnote)
                        //     .foregroundColor(.gray)
                        //     .padding(.bottom, 10)

                        Text("ID: \(item.id)")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                            .padding(.bottom, 20)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding()
                } else {
                    Text("Loading note details...")
                        .font(.body)
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle("Note Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
