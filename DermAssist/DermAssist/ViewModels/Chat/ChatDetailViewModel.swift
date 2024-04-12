//
//  ChatDetailViewModel.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//


import Foundation
import FirebaseAuth
import FirebaseFirestore
import OpenAISwift

final class ChatDetailsViewModel: ObservableObject {
    @Published var messages: [Message] = []
    private var openAI: OpenAISwift?
    
    var itemId: String
    @Published var item: Chat? = nil
    @Published var showingEditView = false
    
    init(itemId: String) {
        self.itemId = itemId
        fetch_item()
    }
    
    func setupOpenAI() {
        let config: OpenAISwift.Config = .makeDefaultOpenAI(apiKey: "API")
        openAI = OpenAISwift(config: config) // Initialize OpenAI
    }

    func sendUserMessage(_ message: String) {
        let userMessage = Message(is_pin: false, createDate: Date().timeIntervalSince1970, id: UUID().uuidString, message: message, isUser: true)
        messages.append(userMessage) // Append user message to chat history

        openAI?.sendCompletion(with: message, maxTokens: 500) { [weak self] result in
            switch result {
            case .success(let model):
                if let response = model.choices?.first?.text {
                    self?.receiveBotMessage(response) // Handle bot's response
                    print("response success")
                }
            case .failure(_):
                // Handle any errors during message sending
                break
            }
        }
    }

    private func receiveBotMessage(_ message: String) {
        let botMessage = Message(is_pin: false, createDate: Date().timeIntervalSince1970, id: UUID().uuidString, message: message, isUser: false)
        messages.append(botMessage) // Append bot message to chat history
    }
    
    func toggleIsDone(item: Chat) {
        var itemCopy = item
        itemCopy.toggle_pin()
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(uid)
            .collection("chats")
            .document(itemCopy.id)
            .setData(itemCopy.asDictionary())
    }
    
    func fetch_item() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(uid)
            .collection("chats")
            .document(itemId)
            .getDocument { [weak self]snapshot, error in
                guard let data = snapshot?.data(), error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self?.item = Chat(
                        is_pin: data["is_pin"] as? Bool ?? false,
                        createDate: data["createDate"] as? TimeInterval ?? 0,
                        id: data["id"] as? String ?? "",
                        chat_name: data["chat_name"] as? String ?? "",
                        messages: data["messages"] as? [Message] ?? []
                    )
                }
                
            }
    }
}
