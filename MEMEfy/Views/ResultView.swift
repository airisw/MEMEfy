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
                        } label: {
                            Text("Next Round")
                                .padding()
                        }
                        // choose judgeid
                        // brings to roundjudgeview or roundplayerview
                        
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
                        // deletes roomCode
                        // deletes iscustom true -> only for roomcode
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
