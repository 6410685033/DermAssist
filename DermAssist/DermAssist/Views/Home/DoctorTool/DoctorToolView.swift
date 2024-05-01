//
//  DoctorToolView.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 1/5/2567 BE.
//

import SwiftUI

struct DoctorToolView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ProductManageView()) {
                    Text("Manage Product")
                }
                NavigationLink(destination: AllergenManageView()) {
                    Text("Manage Allergy")
                }
            }
            .navigationTitle("Doctor Tools")
        }
    }
}

#Preview {
    DoctorToolView()
}
