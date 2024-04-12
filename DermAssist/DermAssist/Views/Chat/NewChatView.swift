//
//  NewChatView.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//

import SwiftUI

struct NewChatView: View {
    
    @StateObject var viewModel = NewChatViewModel()
    @Binding var newItemPresented: Bool
    
    var body: some View {
        VStack {
            Text("New Chat")
                .font(.system(size: 32))
                .bold()
                .padding(.top, 50)
            
            Form {
                TextField("Chat Name", text: $viewModel.chat_name)
                    .textFieldStyle(DefaultTextFieldStyle())
//                TextField("Content", text: $viewModel.content)
//                    .textFieldStyle(DefaultTextFieldStyle())
//                DatePicker("Due Date", selection: $viewModel.dueDate)
//                    .datePickerStyle(GraphicalDatePickerStyle())
                TLButton(title: "Save", background: .pink) {
                    if viewModel.canSave {
                        viewModel.save()
                        newItemPresented = false
                    } else {
                        viewModel.showAlert = true
                    }
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("Please fill in all fields and select due date that is today or newer")
                )
            }
        }
    }
}
