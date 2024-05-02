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
                    HStack {
                        Image(systemName: "wrench.fill").foregroundColor(.green)
                        Text("Manage Product")
                    }
                }
                NavigationLink(destination: AllergenManageView()) {
                    HStack {
                        Image(systemName: "bandage.fill").foregroundColor(.red)
                        Text("Manage Allergy")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Doctor Tools")
        }
    }
}


#Preview {
    DoctorToolView()
}
