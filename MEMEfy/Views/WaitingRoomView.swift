//
//  WaitingRoomView.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/27/23.
//

import SwiftUI

struct WaitingRoomView: View {
    @EnvironmentObject var firebaseManager: FirebaseManager
    @State private var isStartGameTapped = false
    var finalRoomCode: String
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    Image("Wallpaper")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    
                    VStack {
                        Text(finalRoomCode)
                            .font(.title)
                            .padding(.vertical)
                        
                        VStack(alignment: .leading) {
                            Text("Waiting for players...")
                                .padding(.horizontal)
                            
                            ForEach(firebaseManager.players) { player in
                                Text(player.name)
                                    .padding(.leading)
                            }
                        }
                        
                        Button {
                            print("Start Game button tapped")
                            isStartGameTapped = true
                            firebaseManager.updateGameStart(roomCode: finalRoomCode)
                            print("timestamp updated")
                            firebaseManager.getGameStart(roomCode: finalRoomCode)
                            print("update judgeID")
                            firebaseManager.updateJudgeID(roomCode: finalRoomCode)
                        } label: {
                            Text("Start Game")
                                .padding()
                        }
                        .navigationDestination(isPresented: $isStartGameTapped) {
                            PersonalizePromptsView(promptManager: PromptManager(prompts: []))
                                .environmentObject(firebaseManager)
                                .navigationBarBackButtonHidden(true)
                        }
                        .background(Color("Purple"))
                        .foregroundColor(.white)
                        .cornerRadius(30)
                        .shadow(color: .white, radius: 10, x: 5, y: 5)
                        
                    }
                }
            }
        }
    }
}

struct WaitingRoomView_Previews: PreviewProvider {
    @State static var finalRoomCode = "<room code>"
    
    static var previews: some View {
        WaitingRoomView(finalRoomCode: finalRoomCode)
            .environmentObject(FirebaseManager(gameRooms: []))
    }
}
