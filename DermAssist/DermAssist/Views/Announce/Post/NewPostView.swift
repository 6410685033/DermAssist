//
//  NewPostView.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//

import SwiftUI

struct NewPostView: View {
    
    @StateObject var viewModel = NewPostViewModel()
    @StateObject var HomeviewModel = AnnounceViewModel()
    @Binding var newPostPresented: Bool
    
    var body: some View {
        VStack {
            Text("New Post")
                .font(.system(size: 32))
                .bold()
                .padding(.top, 50)
            
            Form {
                TextField("Title", text: $viewModel.title)
                    .textFieldStyle(DefaultTextFieldStyle())
                TextField("Content", text: $viewModel.content)
                    .textFieldStyle(DefaultTextFieldStyle())
                TLButton(title: "Save", background: .pink) {
                    viewModel.save()
                    newPostPresented = false
                }
            }
            
        }
    }
}

#Preview {
    NewPostView(newPostPresented: .constant(true))
}
