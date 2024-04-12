//
//  MessageView.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 12/4/2567 BE.
//

import SwiftUI

struct MessageView: View {
    var message: Message

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }

    private let cornerRadius: CGFloat = 10 // Adjust this value to change the roundness

    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                VStack(alignment: .trailing) {
                    Text(message.message)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)

                    Text(dateFormatter.string(from: Date(timeIntervalSince1970: message.createDate)))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding([.top, .bottom, .trailing])
            } else {
                VStack(alignment: .leading) {
                    Text(message.message)
                        .padding()
                        .background(Color.gray.opacity(0.5))
                        .foregroundColor(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)

                    Text(dateFormatter.string(from: Date(timeIntervalSince1970: message.createDate)))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding([.top, .bottom, .leading])
                Spacer()
            }
        }
    }
}

