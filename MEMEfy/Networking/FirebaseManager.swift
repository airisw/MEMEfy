//
//  formManager.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/28/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

extension String {
    static func generateRandomString(length: Int) -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
}

class FirebaseManager: ObservableObject {
    @Published fileprivate(set) var gameRooms: [GameRoom] = []
//    @Published fileprivate(set) var players: [Player] = []
    
    let db = Firestore.firestore()
    
    init(gameRooms: [GameRoom]) {
        self.gameRooms = gameRooms
    }
    
    func startGame(name: String, roomCode: String) -> String {
        
        let player = Player(name: name,
                            totalScore: 0)
        
        var finalRoomCode = roomCode
        
        if finalRoomCode.isEmpty {
            finalRoomCode = String.generateRandomString(length: 4)
        } else {
            finalRoomCode = roomCode.uppercased()
        }
        
        let newPlayerRef = db.collection("player").document()
        let newGameRoomRef = db.collection("gameRoom").document(finalRoomCode)
        
        let gameRoom = GameRoom(
            roomCode: finalRoomCode,
            players: [player],
            rounds: [],
            gameStart: Date()
        )
        
        do {
            try newPlayerRef.setData(from: player)
            try newGameRoomRef.setData(from: gameRoom)
        } catch let error {
            print("Error writing to Firestore: \(error)")
        }
        
        return finalRoomCode
    }
    
//    func get players
    
    func updateTimestamp(roomCode: String) {
        db.collection("gameRoom").document(roomCode).setData(["gameStart": Date()], merge: true)
    }
    
    func getTimestamp(roomCode: String) {
        db.collection("gameRoom").document(roomCode).getDocument { (document, error) in
            if let document = document, document.exists {
//                let timestamp = document.data()?["gameStart"] as? Timestamp
//                print(timestamp)
                if let timestamp = document.data()?["gameStart"] as? Timestamp {
                    let date = timestamp.dateValue()
                    print(date)
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
//    func get random prompt
    
//    func get submissions
    
//    func delete gameRoom
}

internal class MockFirebaseManager: FirebaseManager {
    override func startGame(name: String, roomCode: String) -> String {
        let player = Player(name: "Ada", totalScore: 0)
        let gameRoom = GameRoom(
                                roomCode: roomCode,
                                players: [player],
                                rounds: [],
                                gameStart: Date()
                                )
        
        self.gameRooms.append(gameRoom)
        
        return roomCode
    }
}
