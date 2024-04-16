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
    @Published var selectedAmount = 5
    @Published var amounts: [Int]
    @Published var products: [String] = []
    @Published var selectedProduct: String = ""
    @Published var myAllergens: [Allergen] = []
    var itemId: String
    
    
    let openAI = OpenAI(apiToken: ProcessInfo.processInfo.environment["openAI"]!)
    
    init(itemId: String) {
        self.amounts = Array(1...10)
        self.itemId = itemId
        fetch_chat()
        fetch_messages()
        fetchMyAllergens()
    }

    func fetchMyAllergens() {
        guard let uId = Auth.auth().currentUser?.uid else {
            print("not validate")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users/\(uId)/allergy")
            .getDocuments { [weak self] snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    print("Error fetching allergens: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                DispatchQueue.main.async {
                    self?.myAllergens = snapshot.documents.compactMap { docSnapshot in
                        try? docSnapshot.data(as: Allergen.self)
                    }
                }
            }
    }
    
    func sendNewMessage(content: String) {
        let allergens = formatAllergens(allergens: self.myAllergens)
        let prompt = "Please recommend \(self.selectedAmount) specific \(content) brands that do not contain \(allergens)"
        let userMessage = Message(is_pin: false, createDate: Date().timeIntervalSince1970, id: UUID().uuidString, message: prompt, isUser: true)
        self.saveMessage(userMessage)
        self.messages.append(userMessage)
        getBotReply()
    }
    
    func formatAllergens(allergens: [Allergen]) -> String {
        var result = ""
        for (index, allergen) in allergens.enumerated() {
            if index > 0 {
                result += ", "
            }
            result += "\(allergen.allergen_name)"
        }
        return result
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

