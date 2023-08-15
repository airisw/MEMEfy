//
//  ResultView.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/27/23.
//

import SwiftUI

struct ResultView: View {
    @EnvironmentObject var promptManager: PromptManager
    @EnvironmentObject var firebaseManager: FirebaseManager
    @State private var isEndGameTapped = false
    @State private var isNextRoundTapped = false
    var selectedGif: String?
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("Wallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                
                VStack {
                    Text("Result")
                        .font(.title)
                    
                    Result(selectedGif: selectedGif)
                        .environmentObject(promptManager)
                        .environmentObject(firebaseManager)
                    
                    Scoreboard()
                        .environmentObject(firebaseManager)
                    
                    HStack {
                        Button {
                            print("Next Round starting")
                            firebaseManager.addRound(roomCode: firebaseManager.finalRoomCode)
                            firebaseManager.getRoundStart(roomCode: firebaseManager.finalRoomCode)
                            firebaseManager.updateJudgeID(roomCode: firebaseManager.finalRoomCode)
                            isNextRoundTapped = true
                        } label: {
                            Text("Next Round")
                                .padding()
                        }
                        .navigationDestination(isPresented: $isNextRoundTapped) {
                            if firebaseManager.currentJudgeID == firebaseManager.currentPlayerID {
                                RoundJudgeView()
                                    .environmentObject(promptManager)
                                    .environmentObject(firebaseManager)
                                    .navigationBarBackButtonHidden(true)
                            } else {
                                RoundPlayerView()
                                    .environmentObject(promptManager)
                                    .environmentObject(firebaseManager)
                                    .navigationBarBackButtonHidden(true)
                            }
                        }
                        
                        Button {
                            print("End of Game")
                            firebaseManager.deleteGameRoom(roomCode: firebaseManager.finalRoomCode)
                            isEndGameTapped = true
                        } label: {
                            Text("End Game")
                                .padding()
                        }
                        .navigationDestination(isPresented: $isEndGameTapped) {
                            ContentView(firebaseManager: FirebaseManager(gameRooms: []))
                                .navigationBarBackButtonHidden(true)
                        }
                    }
                }
            }
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView()
            .environmentObject(PromptManager(prompts: []))
            .environmentObject(FirebaseManager(gameRooms: []))
    }
}
