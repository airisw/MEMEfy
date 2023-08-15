//
//  GameRoomModel.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/27/23.
//

import Foundation
import FirebaseFirestoreSwift

struct GameRoom: Codable, Identifiable {
    @DocumentID var id: String?
    var roomCode: String
    var gameStart: Date
}

struct Player: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var totalScore: Int
}

struct Round: Codable, Identifiable {
    @DocumentID var id: String?
    var judgeId: String
    var winnerId: String
//    var promptId: String
    var winnerGifUrl: String
    var roundStart: Date
}

struct Submission: Codable, Identifiable {
    @DocumentID var id: String?
    var playerId: String
    var gifUrl: String
}
