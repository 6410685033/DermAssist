//
//  AnnounceItemView.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//

import SwiftUI

struct AnnounceItemView: View {
    @State private var userName: String = ""
    @StateObject var viewModel = AnnounceViewModel()
    let item: Post
    
    var body: some View {
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
    AnnounceItemView(item: .init(id: "123", title: "AnnounceTitle", createDate: Date().timeIntervalSince1970, content: "contenttttttt", creator: "tNcfb0V8ergVGyPfyuUkRQWlnoW2", comments: [], likes: []))
}
