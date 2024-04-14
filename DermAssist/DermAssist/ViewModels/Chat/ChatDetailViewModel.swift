//
//  ChatDetailViewModel.swift
//  DermAssist
//
//  Created by Supakrit Nithikethkul on 10/4/2567 BE.
//


import Foundation
import FirebaseAuth
import FirebaseFirestore
import OpenAI
import GoogleGenerativeAI


final class ChatDetailsViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var lastest_message: Message? = nil
    @Published var item: ChatRoom? = nil
    @Published var showingEditView = false
    var itemId: String
    
    // Gemini and location for pharmacy
    @Published var pharmacy: String? = nil
    @Published var showingPharmacy = false
    @Published var loadingPharmacy = false
    
    
    let gemini = GenerativeModel(name: "gemini-pro", apiKey: ProcessInfo.processInfo.environment["gemini"]!)
    let openAI = OpenAI(apiToken: ProcessInfo.processInfo.environment["openAI"]!)
    
    init(itemId: String) {
        self.itemId = itemId
        fetch_chat()
        fetch_messages()
    }
    
    func fetchPharmacy() async {
        DispatchQueue.main.async {
            self.showingPharmacy = true // showing sheet
            
            if let pharmacyData = self.pharmacy, !pharmacyData.isEmpty {
                self.loadingPharmacy = false
            } else {
                self.loadingPharmacy = true
            }
        }
        
        if pharmacy == nil || pharmacy!.isEmpty {
            do {
                let response = try await gemini.generateContent("list of pharmacy")
                DispatchQueue.main.async {
                    self.pharmacy = response.text
                    self.loadingPharmacy = false
                    self.showingPharmacy = true
                }
            } catch {
                print("Error fetching pharmacy data: \(error)")
                DispatchQueue.main.async {
                    self.pharmacy = "Failed to fetch data: \(error.localizedDescription)"
                    self.loadingPharmacy = false
                    self.showingPharmacy = true
                }
            }
        }
    }

    
    func sendNewMessage(content: String) {
        let userMessage = Message(is_pin: false, createDate: Date().timeIntervalSince1970, id: UUID().uuidString, message: content, isUser: true)
        self.saveMessage(userMessage)
        self.messages.append(userMessage)
        getBotReply()
    }
    
    func getBotReply() {
        
        openAI.chats(query: .init(model: .gpt3_5Turbo,
                                  messages: self.messages.map({Chat(role: .user, content: $0.message)}))) { result in
            switch result {
            case .success(let success):
                guard let choice = success.choices.first else {
                    return
                }
                let message = choice.message.content
                DispatchQueue.main.async {
                    let bot_message = Message(is_pin: false, createDate: Date().timeIntervalSince1970, id: UUID().uuidString, message: message!, isUser: false)
                    self.messages.append(bot_message)
                    self.saveMessage(bot_message)
                }
            case .failure(let failure):
                print(failure)
            }
        }
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
    
    func toggleIsDone(item: ChatRoom) {
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
                self.item = ChatRoom(
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
        self.lastest_message = self.messages.max(by: { $0.createDate < $1.createDate }) ?? nil
        print("sort_message work with: \(String(describing: lastest_message))")
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

