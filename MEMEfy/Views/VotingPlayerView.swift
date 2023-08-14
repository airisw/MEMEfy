//
//  VotingPlayerView.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/27/23.
//

import SwiftUI

struct VotingPlayerView: View {
    @EnvironmentObject var promptManager: PromptManager
    @EnvironmentObject var firebaseManager: FirebaseManager
    @State private var changeView = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("Wallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                
                VStack {
                    Text("Voting Time")
                        .font(.title)
                    
                    Text("Waiting for \(firebaseManager.currentJudgeID) to vote")
                        .font(.title2)
                    
                    if firebaseManager.isWinnerUpdated {
                        Button {

                        } label: {

                        }
                        .navigationDestination(isPresented: $changeView) {
                            ResultView()
                                .environmentObject(firebaseManager)
                                .environmentObject(promptManager)
                                .navigationBarBackButtonHidden(true)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top, 70)
            }
            .onAppear {
                firebaseManager.checkWinner(roomCode: firebaseManager.finalRoomCode)
            }
            .onChange(of: firebaseManager.isWinnerUpdated) { newValue in
                if newValue {
                    firebaseManager.getWinner(roomCode: firebaseManager.finalRoomCode)
                    changeView = true
                }
            }
        }
    }
}

struct VotingPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VotingPlayerView()
            .environmentObject(FirebaseManager(gameRooms: []))
            .environmentObject(PromptManager(prompts: []))
    }
}
