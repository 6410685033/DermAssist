//
//  PinButton.swift
//  DermAssist
//
//  Created by Thammasat Thonggamgaew on 16/4/2567 BE.
//

import SwiftUI

struct PinButton: View {
    @Binding var isPinned: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: isPinned ? "pin.fill" : "pin.slash.fill")
                .foregroundColor(isPinned ? .yellow : .gray)
                .imageScale(.large)
        }
    }
}
