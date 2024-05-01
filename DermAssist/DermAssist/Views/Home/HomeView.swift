//
//  HomeView.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 1/5/2567 BE.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedSegment = 0
    var user: User
    
    var body: some View {
        if user.role.isAdmin || user.role.isDoctor {
            segment
        } else {
            AnnounceView(user: user)
        }
    }
    
    private var segment: some View {
        VStack {
            Picker("Options", selection: $selectedSegment) {
                Text("Announcement").tag(0)
                Text("Doctor Tool").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if selectedSegment == 0 {
                AnnounceView(user: user)
            } else {
                DoctorToolView()
            }
        }
    }
}

#Preview {
    HomeView(user: .init(id: "123", name: "John", email: "john@mail.com", tel: "0812345643", gender: .male, joined: Date().timeIntervalSince1970, role: .doctor))
}
