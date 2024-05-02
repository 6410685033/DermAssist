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
            VStack(spacing: 20) {
                // Header with title
                VStack(alignment: .leading, spacing: 10) {
                    Text("Doctor Tools")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text("Manage resources")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 50)
                
                Spacer()
                
                // Tools List
                VStack(spacing: 16) {
                    NavigationLink(destination: ProductManageView()) {
                        HStack {
                            Image(systemName: "wrench.fill").foregroundColor(.green)
                            Text("Manage Product")
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    
                    NavigationLink(destination: AllergenManageView()) {
                        HStack {
                            Image(systemName: "bandage.fill").foregroundColor(.red)
                            Text("Manage Allergens")
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarHidden(true)
            .padding()
        }
    }
}

#Preview {
    DoctorToolView()
}
