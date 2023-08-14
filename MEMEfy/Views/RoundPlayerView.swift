//
//  RoundPlayerView.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/27/23.
//

import SwiftUI

struct RoundPlayerView: View {
    @EnvironmentObject var promptManager: PromptManager
    @EnvironmentObject var firebaseManager: FirebaseManager
    @State private var countdownFinished = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("Wallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                
                VStack {                    
                    RoundTimer(countdownFinished: $countdownFinished)
                        .padding()
                        .navigationDestination(isPresented: $countdownFinished) {
                            VotingPlayerView()
                                .environmentObject(promptManager)
                                .environmentObject(firebaseManager)
                                .navigationBarBackButtonHidden(true)
                        }
                    
                    Text(promptManager.currentPrompt)
                        .padding(.top)
                    
                    SearchForm()
                        .environmentObject(firebaseManager)
                }
            }
        }
    }
}

struct RoundPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        RoundPlayerView()
            .environmentObject(PromptManager(prompts: []))
            .environmentObject(FirebaseManager(gameRooms: []))
    }
}
