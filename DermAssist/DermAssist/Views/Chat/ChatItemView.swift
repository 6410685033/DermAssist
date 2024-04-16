//
//  ChatItemView.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//


import SwiftUI

struct ChatItemView: View {
    @StateObject var viewModel = ChatItemViewModel()
    let item: ChatRoom
    @State private var isNavigationActive = false  // State to control navigation

    var body: some View {
        HStack {
            // NavigationLink disguised as part of the HStack content
            NavigationLink(destination: ChatDetailsView(itemId: item.id), isActive: $isNavigationActive) {
                EmptyView()
            }
            .frame(width: 0)
            .opacity(0)

            // Tappable area for navigation
            VStack(alignment: .leading) {
                Text(item.chat_name)
                    .font(.title)
                    .bold()
                
                Text("\(Date(timeIntervalSince1970: item.createDate).formatted(date: .abbreviated, time: .shortened))")
                    .font(.footnote)
                    .foregroundColor(Color(.secondaryLabel))
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isNavigationActive = true
            }
            .background(NavigationLink("", destination: ChatDetailsView(itemId: item.id)).hidden())            
            Spacer()
            
            PinButton(isPinned: .constant(item.is_pin)) {
                viewModel.togglePin(item: item)
            }
        }
    }
}
