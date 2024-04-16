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
            NavigationLink(destination:
                            PostView(viewModel: PostViewModel(postId: item.id)), isActive: $isNavigationActive) {
                EmptyView()
            }
                            .frame(width: 0)
                            .opacity(0)
            
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
            
            if user.role.isAdmin {
                // PinButton aligned with other items
                PinButton(isPinned: .constant(item.is_pin)) {
                    viewModel.togglePin(item: item)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(NavigationLink("", destination: PostView(viewModel: PostViewModel(postId: item.id))).hidden())  // Ensures navigation link is not visible
            .padding(.vertical)
            .onAppear {
                viewModel.fetchUserName(uid: item.creator) { name in
                    self.userName = name ?? "Unknown User"
                }
            }
    }
    
    private let itemDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private func relativeTime(for timestamp: TimeInterval) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: Date(timeIntervalSince1970: timestamp), relativeTo: Date())
    }
}

#Preview {
    AnnounceItemView(item: .init(is_pin: false, createDate: Date().timeIntervalSince1970, id: "123", title: "AnnounceTitle", content: "contenttttttt", creator: "user", comments: [], likes: []), user: User.init(name: "user", email: "user@mail.com", tel: "0987654321", gender: "Male", joined: Date().timeIntervalSince1970, role: .admin))
}
