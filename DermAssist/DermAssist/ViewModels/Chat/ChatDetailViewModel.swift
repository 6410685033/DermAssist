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
        fetch_chat()
        fetch_messages()
    }
    
    func setupOpenAI() {
        let config: OpenAISwift.Config = .makeDefaultOpenAI(apiKey: "API")
        openAI = OpenAISwift(config: config) // Initialize OpenAI
    }
    
    func sendUserMessage(_ message: String) {
        let userMessage = Message(is_pin: false, createDate: Date().timeIntervalSince1970, id: UUID().uuidString, message: message, isUser: true)
        messages.append(userMessage) // Append user message to chat history
        saveMessage(userMessage) // Save user message to Firestore
        
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
    
    private func saveMessage(_ message: Message) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let db = Firestore.firestore()
        let messageRef = db.collection("users").document(uid).collection("chats").document(itemId).collection("messages").document(message.id)
        
        do {
            try messageRef.setData(from: message)
        } catch let error {
            print("Error saving message to Firestore: \(error.localizedDescription)")
        }
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
    
    func fetch_chat() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let db = Firestore.firestore()
        let chatRef = db.collection("users").document(uid).collection("chats").document(itemId)
        
        chatRef.getDocument { [weak self] snapshot, error in
            guard let self = self, let snapshot = snapshot, snapshot.exists, error == nil else {
                print("Error fetching chat: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            
            let data = snapshot.data() ?? [:]
            
            DispatchQueue.main.async {
                self.item = Chat(
                    is_pin: data["is_pin"] as? Bool ?? false,
                    createDate: data["createDate"] as? TimeInterval ?? 0,
                    id: data["id"] as? String ?? "",
                    chat_name: data["chat_name"] as? String ?? ""
                )
            }
        }
    }
    
    func sort_message() {
        self.messages.sort { $0.createDate < $1.createDate }
    }
    
    func fetch_messages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let db = Firestore.firestore()
        let messagesRef = db.collection("users").document(uid).collection("chats").document(itemId).collection("messages")
        
        messagesRef.getDocuments { [weak self] (querySnapshot, err) in
            guard let self = self else { return }
            
            if let err = err {
                print("Error getting messages: \(err)")
            } else {
                var messages: [Message] = []
                for document in querySnapshot!.documents {
                    let messageData = document.data()
                    let message = Message(
                        is_pin: messageData["is_pin"] as? Bool ?? false,
                        createDate: messageData["createDate"] as? TimeInterval ?? 0,
                        id: messageData["id"] as? String ?? UUID().uuidString,
                        message: messageData["message"] as? String ?? "",
                        isUser: messageData["isUser"] as? Bool ?? false
                    )
                    messages.append(message)
                }
                
                // Update the messages on the main thread
                DispatchQueue.main.async {
                    self.messages = messages
                    self.sort_message()
                }
            }
        }
    }
    
}
