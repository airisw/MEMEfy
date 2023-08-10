//
//  RoundJudgeView.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/27/23.
//

import SwiftUI

struct RoundJudgeView: View {
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
                            VotingJudgeView()
                                .environmentObject(promptManager)
                                .environmentObject(firebaseManager)
                                .navigationBarBackButtonHidden(true)
                        }

                    
                    Text("It's your turn to vote!")
                        .font(.title2)
                    
                    Text("Waiting for other players to submit their answers")
                        .padding()
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
                .padding(.top, 70)
            }
        }
    }
}

struct RoundJudgeView_Previews: PreviewProvider {
    static var previews: some View {
        RoundJudgeView()
            .environmentObject(PromptManager(prompts: []))
            .environmentObject(FirebaseManager(gameRooms: []))
    }
}
