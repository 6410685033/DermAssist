//
//  EditPostView.swift
//  POS
//
//  Created by Thammasat Thonggamgaew on 23/4/2567 BE.
//

import SwiftUI

struct EditPostView: View {
    @Binding var post: Post?
    var onCommit: (String, String) -> Void
    
    @State private var title: String = ""
    @State private var content: String = ""
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextEditor(text: $content)
                Button("Save") {
                    // Call the onCommit closure with the new title and content
                    if let post = post {
                        onCommit(title.isEmpty ? post.title : title,
                                 content.isEmpty ? post.content : content)
                    }
                    // Dismiss the EditPostView after the save operation
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationBarTitle("Edit Post", displayMode: .inline)
            .onAppear {
                // Initialize text fields with current post data
                if let post = post {
                    title = post.title
                    content = post.content
                }
            }
        }
    }
}


//#Preview {
//    EditPostView()
//}
