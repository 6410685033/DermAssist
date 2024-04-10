//
//  CommentView.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//

import SwiftUI

struct CommentView: View {
    @StateObject private var viewModel: CommentViewModel
    let comment: Comment
    
    init(comment: Comment) {
        self.comment = comment
        _viewModel = StateObject(wrappedValue: CommentViewModel(authorId: comment.authorId))
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(viewModel.authorName.isEmpty ? "Loading..." : viewModel.authorName)
                .font(.caption)
                .bold()
            Text("Comment on \(viewModel.formattedDate(for: comment.timestamp))")
                .font(.caption)
                .foregroundColor(.gray)
            Text(comment.content)
                .font(.body)
        }
    }
}


#Preview {
    CommentView(comment: Comment(id: "1", authorId: "123", content: "Sample comment", timestamp: 1609459200))
}
