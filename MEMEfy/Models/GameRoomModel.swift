//
//  GameRoomModel.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/27/23.
//

import Foundation

struct GameRoom: Codable, Identifiable {
    var id: String
    var roomCode: String
    var players: [Player]
    var rounds: [Round]
    var gameStart: Date
}

struct Player: Codable, Identifiable {
    var id: String
    var playerId: String
    var name: String
    var totalScore: Int
}

struct Round: Codable, Identifiable {
    var id: String
    var judgeId: String
    var winnerId: String
    var promptId: String
//    var scoreboard: [Scoreboard]
    var submissions: [Submission]
    var roundStart: Date
}

//struct Scoreboard: Codable, Identifiable {
//    var id: String
//    var playerId: String
//    var playerScore: Int
//}

struct Submission: Codable, Identifiable {
    var id: String
    var playerId: String
    var gifUrl: String
}
