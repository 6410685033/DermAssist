//
//  ChatItemView.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//


import SwiftUI

struct ChatItemView: View {
    @StateObject var viewModel = ChatItemViewModel()
    @State private var isNavigationActive = false
    let item: ChatRoom
    
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
            
            Spacer()
            
            // PinButton aligned with other items
            PinButton(isPinned: .constant(item.is_pin)) {
                viewModel.togglePin(item: item)
            }
            .buttonStyle(PlainButtonStyle())  // Ensures the button has no additional padding or effects interfering with layout
        }
        .background(NavigationLink("", destination: ChatDetailsView(itemId: item.id)).hidden())  // Ensures navigation link is not visible
    }
}
