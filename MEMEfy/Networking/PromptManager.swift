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
}
