//
//  PromptManager.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/31/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class PromptManager: ObservableObject {
    @Published fileprivate(set) var prompts: [Prompt] = []
    @Published fileprivate(set) var promptsID = [String]()
    @Published fileprivate(set) var currentPrompt = ""
    @Published fileprivate(set) var currentPromptID = ""
    
    let db = Firestore.firestore()
    
    init(prompts: [Prompt]) {
        self.prompts = prompts
    }
    
    func createPrompts(prompt: String) {
        let newPromptRef = db.collection("prompt").document()
        
        let newPrompt = Prompt(text: prompt,
                               isCustom: true)
        
        do {
            try newPromptRef.setData(from: newPrompt)
        } catch let error {
            print("Error adding prompt to Firestore: \(error)")
        }
    }
    
    func getPromptsID(completion: @escaping () -> Void) {
        db.collection("prompt").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents{
                    self.promptsID.append(document.documentID)
                }
            }
            self.promptsID.shuffle()
            self.currentPromptID = self.promptsID[0]
            print(self.promptsID)
            print("prompt id:", self.currentPromptID)
            completion()
        }
    }
    
    func getRandomPrompt() {
        getPromptsID {
            let promptID = self.promptsID[0]
            
            self.db.collection("prompt").document(promptID).getDocument { (document, error) in
                if let document = document, document.exists {
                    if let prompt = document.data()?["text"] as? String {
                        self.currentPrompt = prompt
                        print("prompt:", self.currentPrompt)
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
}
