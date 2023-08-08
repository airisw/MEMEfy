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
    @Published fileprivate(set) var players = [String]()
    @Published fileprivate(set) var timestamp = Date()
    @Published fileprivate(set) var modifiedDate = Date()
    @Published fileprivate(set) var playersID = [String]()
    @Published fileprivate(set) var currentJudgeID = ""
    @Published fileprivate(set) var roundDocumentID = ""
    
    let db = Firestore.firestore()
    
    init(gameRooms: [GameRoom]) {
        self.gameRooms = gameRooms
    }
    
    func startGame(name: String, roomCode: String) -> String {
        var finalRoomCode = roomCode
        
        if finalRoomCode.isEmpty {
            finalRoomCode = String.generateRandomString(length: 4)
        } else {
            finalRoomCode = roomCode.uppercased()
        }
        
        let newGameRoomRef = db.collection("gameRoom").document(finalRoomCode)
        
        let gameRoom = GameRoom(
            roomCode: finalRoomCode,
//            players: [player],
//            rounds: [],
            gameStart: Date()
        )
        
        do {
            try newGameRoomRef.setData(from: gameRoom)
        } catch let error {
            print("Error writing to Firestore: \(error)")
        }
        
        addPlayers(name: name, roomCode: finalRoomCode)
        addRound(roomCode: finalRoomCode)
        
        return finalRoomCode
    }
    
//    add players as sub collection to gameRoom
    func addPlayers(name:String, roomCode: String) {
        let newPlayerRef = db.collection("gameRoom").document(roomCode).collection("players").document(name)
    
        let newPlayer = Player(name: name, totalScore: 0)
        
        do {
            try newPlayerRef.setData(from: newPlayer)
        } catch {
            print("Error writing player")
        }
    }
    
    func addRound(roomCode: String) {
        let newRoundRef = db.collection("gameRoom").document(roomCode).collection("rounds").document()
        
        let newRound = Round(judgeId: "",
                             winnerId: "",
                             promptId: "",
                             submissions: [],
                             roundStart: Date())
        
        do {
            try newRoundRef.setData(from: newRound)
        } catch {
            print("Error writing round")
        }
    }
    
//    real time updates of players collection
    func getPlayersCollection(roomCode: String) {
        db.collection("gameRoom/\(roomCode)/players").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
                
            let names = documents.map { $0["name"] as! String }.sorted()
            print("Current players: \(names)")
            
            self.players = names

        }
    }
     
//    real time updates of players field
//        func getPlayers(roomCode: String) {
////            let gameRoomRef = db.collection("gameRoom").document(roomCode).collection("players")
//            let gameRoomRef = db.collection("gameRoom").document(roomCode)
//
//            gameRoomRef.addSnapshotListener { querySnapshot, error in
//                guard let document = querySnapshot else {
//                    print("Error fetching documents: \(error!)")
//                    return
//                }
//
//                guard let data = document.data() else {
//                    print("Document was empty")
//                    return
//                }
//
//                print(data)
//
////                if let players = data["players"] as? Dictionary<String, Any> {
////                    print(players)
////                    let name = players["name"]
////                    print(name)
////                }
//            }
//        }
    
    func updateTimestamp(roomCode: String) {
        db.collection("gameRoom").document(roomCode).setData(["gameStart": Date()], merge: true)
    }
    
    func getTimestamp(roomCode: String) {
        db.collection("gameRoom").document(roomCode).getDocument { (document, error) in
            if let document = document, document.exists {
                if let timestamp = document.data()?["gameStart"] as? Timestamp {
                    let date = timestamp.dateValue()
                    self.timestamp = date
                    print("timestamp from Firebase: \(self.timestamp)")
                    
                    let calendar = Calendar.current
                    if let modifiedDate = calendar.date(byAdding: .second, value: 100, to: self.timestamp) {
                        self.modifiedDate = modifiedDate
                        print("added 100 secs: \(self.modifiedDate)")
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func getJudgeID(roomCode: String, completion: @escaping () -> Void) {
        db.collection("gameRoom/\(roomCode)/players").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting players documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    self.playersID.append(document.documentID)
                }
            }
            self.playersID.shuffle()
            self.currentJudgeID = self.playersID[0]
            print(self.playersID[0])
            completion()
        }
    }
    
    func updateJudgeID(roomCode: String) {
        getJudgeID(roomCode: roomCode) {
            let judgeID = self.currentJudgeID
            
            self.db.collection("gameRoom/\(roomCode)/rounds")
                .order(by: "roundStart", descending: true).limit(to: 1).getDocuments() { (querySnapshot, error) in
                    if let error = error {
                        print("Error fetching round document: \(error)")
                    } else {
                        for document in querySnapshot!.documents {
                            let roundRef = document.reference
                            
                            roundRef.setData(["judgeId": judgeID], merge:true)
                        }
                    }
                }
        }
    }
    
//    func get submissions
    
//    func delete gameRoom
    func deleteGameRoom(roomCode: String) {
        db.collection("gameRoom").document(roomCode).delete() { error in
            if let error = error {
                print("Error deleting gameRoom: \(error)")
            }
        }
    }
}

internal class MockFirebaseManager: FirebaseManager {
    override func startGame(name: String, roomCode: String) -> String {
//        let player = Player(name: "Ada", totalScore: 0)
        let gameRoom = GameRoom(
                                roomCode: roomCode,
//                                rounds: [],
                                gameStart: Date()
                                )
        
        self.gameRooms.append(gameRoom)
        
        return roomCode
    }
}
