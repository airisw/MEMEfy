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
    @Published fileprivate(set) var players = [Player]()
    @Published fileprivate(set) var modifiedDate = Date()
    @Published fileprivate(set) var playersID = [String]()
    @Published fileprivate(set) var currentJudgeID = ""
    @Published fileprivate(set) var currentPlayerID = ""
    @Published fileprivate(set) var roundDocID = ""
    @Published fileprivate(set) var subDocID = ""
    @Published fileprivate(set) var finalRoomCode = ""
    @Published fileprivate(set) var modifiedRoundStart = Date()
    @Published fileprivate(set) var submissions = [String]()
    @Published fileprivate(set) var winnerId = ""
    @Published fileprivate(set) var isWinnerUpdated = false
    @Published fileprivate(set) var winnerSubmission: String?
    @Published fileprivate(set) var winnerGifUrl: String?
    
    let db = Firestore.firestore()
    
    init(gameRooms: [GameRoom]) {
        self.gameRooms = gameRooms
    }
    
    func startGame(name: String, roomCode: String) -> String {
        self.currentPlayerID = name
        var finalRoomCode = roomCode
        
        if finalRoomCode.isEmpty {
            finalRoomCode = String.generateRandomString(length: 4)
        } else {
            finalRoomCode = roomCode.uppercased()
        }
        
        let newGameRoomRef = db.collection("gameRoom").document(finalRoomCode)
        
        let gameRoom = GameRoom(
            roomCode: finalRoomCode,
            gameStart: Date()
        )
        
        do {
            try newGameRoomRef.setData(from: gameRoom)
        } catch let error {
            print("Error writing to Firestore: \(error)")
        }
        
        addPlayers(name: name, roomCode: finalRoomCode)
        addRound(roomCode: finalRoomCode)
        
        self.finalRoomCode = finalRoomCode
        
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
//                             promptId: "",
                             winnerGifUrl: "",
                             roundStart: Date())
        
        do {
            try newRoundRef.setData(from: newRound)
            self.roundDocID = newRoundRef.documentID
        } catch {
            print("Error writing round")
        }
        
        addSubmissions(roomCode: roomCode, name: self.currentPlayerID)
    }
    
    func addSubmissions(roomCode: String, name: String) {
        let newSubRef = db.collection("gameRoom").document(roomCode).collection("rounds").document(self.roundDocID).collection("submissions").document(name)
        
        let newSubmission = Submission(playerId: name, gifUrl: "")
        
        do {
            try newSubRef.setData(from: newSubmission)
            self.subDocID = newSubRef.documentID
        } catch {
            print("Error writing submission")
        }
    }
    
//    real time updates of players collection
    func getPlayersCollection(roomCode: String) {
        db.collection("gameRoom/\(roomCode)/players").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
                
            self.players = documents.compactMap { document -> Player? in
                do {
                    return try document.data(as: Player.self)
                } catch {
                    print("Error decoding document into Player: \(error)")
                    return nil
                }
            }
        }
    }
    
    func updateGameStart(roomCode: String) {
        db.collection("gameRoom").document(roomCode).setData(["gameStart": Date()], merge: true)
    }
    
    func getGameStart(roomCode: String) {
        db.collection("gameRoom").document(roomCode).getDocument { (document, error) in
            if let document = document, document.exists {
                if let timestamp = document.data()?["gameStart"] as? Timestamp {
                    let date = timestamp.dateValue()
                    print("gameStart from Firebase: \(date)")
                    
                    let calendar = Calendar.current
                    if let modifiedDate = calendar.date(byAdding: .second, value: 20, to: date) {
                        self.modifiedDate = modifiedDate
                        print("added 20 secs: \(self.modifiedDate)")
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
            print("current judge: \(self.currentJudgeID)")
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
    
//     submit gif url
    func submitURL(roomCode: String, url: String) {
        db.collection("gameRoom/\(roomCode)/rounds/\(self.roundDocID)/submissions")
            .document(self.subDocID).setData(["gifUrl": url], merge: true)
    }
    
    func updateRoundStart(roomCode: String) {
        print("upadting roundstart")
        db.collection("gameRoom/\(roomCode)/rounds")
            .document(self.roundDocID).setData(["roundStart": Date()], merge: true)
    }
    
    func getRoundStart(roomCode: String) {
        db.collection("gameRoom/\(roomCode)/rounds").document(self.roundDocID).getDocument { (document, error) in
            if let document = document, document.exists {
                if let timestamp = document.data()?["roundStart"] as? Timestamp {
                    let date = timestamp.dateValue()
                    print("roundStart from Firebase: \(date)")
                    
                    let calendar = Calendar.current
                    if let modifiedDate = calendar.date(byAdding: .second, value: 30, to: date) {
                        self.modifiedRoundStart = modifiedDate
                        print("added 30 secs: \(self.modifiedRoundStart)")
                    }
                }
            } else {
                print("Document does not exist")
                }
        }
    }
    
//    func get submissions
    func fetchGifs(roomCode: String) {
        db.collection("gameRoom/\(roomCode)/rounds/\(self.roundDocID)/submissions").getDocuments() { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching submissions: \(error!)")
                return
            }
                
            let submissions = documents.map { $0["gifUrl"] as! String }
            print("Submitted GIFs: \(submissions)")
            
            self.submissions = submissions
            print(self.submissions)
        }
    }
    
//    func update winner
    func fetchWinnerId(roomCode: String, winnerGIF: String?, completion: @escaping () -> Void) {
        if let winnerGIF = winnerGIF {
            db.collection("gameRoom/\(roomCode)/rounds/\(self.roundDocID)/submissions")
                .whereField("gifUrl", isEqualTo: winnerGIF).getDocuments() { (querySnapshot, error) in
                    if let error = error {
                        print("Error fetching winner ID: \(error)")
                    } else {
                        for document in querySnapshot!.documents {
                            if let playerId = document.data()["playerId"] as? String {
                                self.winnerId = playerId
                                print("fetched winner id:", self.winnerId)
                                completion()
                            }
                        }
                    }
                }
        }
    }
    
    func updateWinner(roomCode: String, winnerGIF: String?) {
//        db.collection("gameRoom/\(roomCode)/rounds").document(self.roundDocID)
//            .setData(["winnerId": self.winnerId], merge: true)
        
        var dataToUpdate = ["winnerId": self.winnerId]
        
        if let winnerGIF = winnerGIF {
            dataToUpdate["winnerGifUrl"] = winnerGIF
        }
        
        db.collection("gameRoom/\(roomCode)/rounds").document(self.roundDocID)
            .setData(dataToUpdate, merge: true)
    }
    
//    winner scores +1 pt
    func scorePoint(roomCode: String) {
        let winnerRef = db.collection("gameRoom/\(roomCode)/players").document(self.winnerId)

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let document: DocumentSnapshot
            do {
                try document = transaction.getDocument(winnerRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            guard let currentScore = document.data()?["totalScore"] as? Int else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Unable to retrieve current score from snapshot \(document)"
                    ]
                )
                errorPointer?.pointee = error
                return nil
            }

            transaction.updateData(["totalScore": currentScore + 1], forDocument: winnerRef)
            return nil
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Transaction successfully committed!")
            }
        }
    }
    
//    func get real time updates of winner
    func checkWinner(roomCode: String) {
        db.collection("gameRoom/\(roomCode)/rounds").document(self.roundDocID).addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            guard let data = document.data() else {
                print("Document data was empty")
                return
            }
            
            if let winnerId = data["winnerId"] as? String {
                if winnerId != "" {
                    self.isWinnerUpdated = true
                }
            }
        }
    }
    
//    func get winner from Firebase
    func getWinner(roomCode: String) {
        db.collection("gameRoom/\(roomCode)/rounds").document(self.roundDocID).getDocument { (document, error) in
            if let document = document, document.exists {
                if let winnerId = document.data()?["winnerId"] as? String {
                    self.winnerId = winnerId
                }
            }
        }
    }
    
    func getWinnerSubmission(roomCode: String) {
        db.collection("gameRoom/\(roomCode)/rounds/\(self.roundDocID)/submissions").document(self.winnerId).getDocument { (document, error) in
            if let document = document, document.exists {
                if let gifUrl = document.data()?["gifUrl"] as? String {
                    self.winnerSubmission = gifUrl
                }
            }
        }
    }
    
    func getWinnerGifUrl(roomCode: String) {
        db.collection("gameRoom/\(roomCode)/rounds").document(self.roundDocID).getDocument { (document, error) in
            if let document = document, document.exists {
                if let winnerGifUrl = document.data()?["winnerGifUrl"] as? String {
                    self.winnerGifUrl = winnerGifUrl
                }
            }
        }
    }
    
//    func delete gameRoom
    func deleteGameRoom(roomCode: String) {
        db.collection("gameRoom/\(roomCode)/rounds").document(self.roundDocID).delete() { error in
            if let error = error {
                print("Error deleting rounds document: \(error)")
            }
        }
        
        db.collection("gameRoom").document(roomCode).delete() { error in
            if let error = error {
                print("Error deleting gameRoom: \(error)")
            }
        }
        
        let playersRef = db.collection("gameRoom/\(roomCode)/players")
            
        playersRef.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error fetching players documents to delete: \(error)")
            }
            
            for document in querySnapshot!.documents {
                let playerId = document["name"] as? String ?? ""
                playersRef.document(playerId).delete() { error in
                    if let error = error {
                        print("Error deleting player documents: \(error)")
                    }
                }
                
            }
        }
    }
}

internal class MockFirebaseManager: FirebaseManager {
    override func startGame(name: String, roomCode: String) -> String {
        let gameRoom = GameRoom(
                                roomCode: roomCode,
                                gameStart: Date()
                                )
        
        self.gameRooms.append(gameRoom)
        
        return roomCode
    }
}
