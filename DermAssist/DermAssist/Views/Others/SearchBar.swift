//
//  SearchBar.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 2/5/2567 BE.
//

import SwiftUI

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $searchText)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                .padding(.vertical, 4)
//                .padding(.bottom, 8)
        }
    }
}

#Preview {
    SearchBar(searchText: .constant(""))
}
