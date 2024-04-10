//
//  CommentViewModel.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//

import Combine
import FirebaseFirestore

class CommentViewModel: ObservableObject {
    @Published var authorName: String = ""
    private var cancellables = Set<AnyCancellable>()

    init(authorId: String) {
        fetchAuthorName(authorId: authorId)
    }

    private func fetchAuthorName(authorId: String) {
        let db = Firestore.firestore()
        db.collection("users").document(authorId).getDocument { [weak self] document, error in
            DispatchQueue.main.async {
                if let name = document?.data()?["name"] as? String {
                    self?.authorName = name
                } else {
                    print("Could not fetch author name: \(error?.localizedDescription ?? "Unknown")")
                    self?.authorName = "Unknown"
                }
            }
        }
    }
    
    func formattedDate(for timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
