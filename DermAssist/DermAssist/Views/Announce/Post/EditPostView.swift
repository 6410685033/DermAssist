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
                Section(header: Text("Post Title")) {
                    TextField("Enter Title", text: $title)
                }
                
                Section(header: Text("Post Content")) {
                    TextEditor(text: $content)
                        .frame(minHeight: 200)  // Ensure there's ample space for editing content
                }
                
                Button("Save") {
                    savePost()
                }
                .disabled(title.isEmpty && content.isEmpty) // Disable save if both fields are empty
            }
            .navigationBarTitle("Edit Post", displayMode: .inline)
            .navigationBarItems(leading: cancelButton)
            .onAppear {
                loadInitialData()
            }
        }
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func loadInitialData() {
        // Initialize text fields with current post data only if they haven't been edited yet
        if let post = post, title.isEmpty && content.isEmpty {
            title = post.title
            content = post.content
        }
    }
    
    private func savePost() {
        // Use non-empty fields or default to existing data
        if let post = post {
            onCommit(title.isEmpty ? post.title : title,
                     content.isEmpty ? post.content : content)
            presentationMode.wrappedValue.dismiss()
        }
    }
}

// For preview purposes
struct EditPostView_Previews: PreviewProvider {
    static var previews: some View {
        EditPostView(post: .constant(Post(is_pin: false, createDate: Date().timeIntervalSince1970, id: "id", title: "Title", content: "Content", creator: "Creator", comments: [], likes: [])), onCommit: { title, content in
            print("Title: \(title), Content: \(content)")
        })
    }
}
