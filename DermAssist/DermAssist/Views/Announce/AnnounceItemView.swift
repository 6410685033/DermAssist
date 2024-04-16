//
//  AnnounceItemView.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//

import SwiftUI

struct AnnounceItemView: View {
    @State private var userName: String = ""
    @State private var isNavigationActive = false
    @ObservedObject var viewModel = AnnounceViewModel()
    let item: Post
    let user: User
    
    var body: some View {
        HStack {
            NavigationLink(destination: PostView(viewModel: PostViewModel(postId: item.id)), isActive: $isNavigationActive) {
                EmptyView()
            }
            .frame(width: 0)
            .opacity(0)

            if !user.role.isAdmin {
                // Conditionally display a pin icon if the post is pinned
                if item.is_pin {
                    Image(systemName: "pin.fill")
                        .foregroundColor(.yellow) // Use a color to highlight the pin status
                        .padding(.trailing, 5)
                }
            }

            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.headline)
                    .bold()
                
                Text("By \(userName)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("\(relativeTime(for: item.createDate))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(item.content)
                    .font(.body)
                    .lineLimit(1) // Limit to 3 lines of content for a brief snippet
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isNavigationActive = true
            }

            Spacer()
            
            // Display the PinButton if the user is an admin
            if user.role.isAdmin {
                PinButton(isPinned: .constant(item.is_pin)) {
                    viewModel.togglePin(item: item)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(NavigationLink("", destination: PostView(viewModel: PostViewModel(postId: item.id))).hidden())
        .padding(.vertical)
        .onAppear {
            viewModel.fetchUserName(uid: item.creator) { name in
                self.userName = name ?? "Unknown User"
            }
        }
    }
    
    private func relativeTime(for timestamp: TimeInterval) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: Date(timeIntervalSince1970: timestamp), relativeTo: Date())
    }
}
