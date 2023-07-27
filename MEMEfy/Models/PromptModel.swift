//
//  PromptModel.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/27/23.
//

import Foundation

struct Prompt: Codable, Identifiable {
    var id: String
    var promptId: String
    var text: String
    var isCustom: Bool
}
