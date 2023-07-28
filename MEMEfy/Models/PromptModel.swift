//
//  PromptModel.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/27/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Prompt: Codable, Identifiable {
    @DocumentID var id: String?
    var text: String
    var isCustom: Bool
}
