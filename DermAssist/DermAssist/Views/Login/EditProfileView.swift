//
//  EditProfileView.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 15/4/2567 BE.
//

import SwiftUI

struct EditProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    let layout = [
        GridItem(.fixed(100), alignment: .leading),
        GridItem(.flexible(minimum: 40), alignment: .leading)
    ]
    
    var body: some View {
        if let user = viewModel.user {
            Form {
                LazyVGrid(columns: layout, content: {
                    Text("Gmail:")
                    ScrollView(.horizontal){
                        Text(user.email)
                            .foregroundStyle(Color.gray)
                    }
                    Text("Gender:")
                    Text(user.gender)
                        .foregroundStyle(Color.gray)
                    Text("Full Name:")
                    TextField("Full Name:", text: $viewModel.name)
                        .textFieldStyle(DefaultTextFieldStyle())
                    Text("Telephone:")
                    TextField("Telephone", text: $viewModel.tel)
                        .textFieldStyle(DefaultTextFieldStyle())
                })
                TLButton(title: "Save", background: .green) {
                    viewModel.edit()
                    self.presentationMode.wrappedValue.dismiss()
                }
                .onAppear{
                    viewModel.load()
                }
            }
            .offset(y: -50)

        } else {
            Text("Loading")
        }
    }
}

#Preview {
    EditProfileView()
}

