//
//  LikeUserView.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//

import SwiftUI

struct LikedUsersView: View {
    @Environment(\.presentationMode) var presentationMode
    var likes: [User]
        
        var body: some View {
            NavigationView {
                List(likes, id: \.id) { user in
                    Text(user.name)
                }
                .navigationBarTitle("Liked by", displayMode: .large)
                .toolbar {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
}

#Preview {
    LikedUsersView(likes: [])
}
