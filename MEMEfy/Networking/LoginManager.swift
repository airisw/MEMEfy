//
//  formManager.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/28/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class LoginManager: ObservableObject {
    @Published private(set) var gameRooms: [GameRoom] = []
    
    let db = Firestore.firestore()
    
    init(gameRooms: [GameRoom]) {
        self.gameRooms = gameRooms
    }
    
    func startGame(name: String, roomCode: String) {
        let newPlayerRef = db.collection("player").document()
        let newGameRoomRef = db.collection("gameRoom").document()
        
        let player = Player(name: name,
                            totalScore: 0)
        
        let gameRoom = GameRoom(
            roomCode: roomCode,
            players: [player],
            rounds: [],
            gameStart: Date()
        )
        
        do {
            try newPlayerRef.setData(from: player)
            try newGameRoomRef.setData(from: gameRoom)
        } catch let error {
            print("Error writing player to Firestore: \(error)")
        }
    }
}
