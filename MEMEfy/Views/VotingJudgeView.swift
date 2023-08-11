//
//  VotingJudgeView.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/27/23.
//

import SwiftUI

struct VotingJudgeView: View {
    @EnvironmentObject var promptManager: PromptManager
    @EnvironmentObject var firebaseManager: FirebaseManager
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("Wallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                
                VStack {
                    Text(promptManager.currentPrompt)
                        .padding(.horizontal)
                    
                    VotingForm()
                        .environmentObject(promptManager)
                        .environmentObject(firebaseManager)
                }
            }
        }
    }
}

struct VotingJudgeView_Previews: PreviewProvider {
    static var previews: some View {
        VotingJudgeView()
            .environmentObject(PromptManager(prompts: []))
            .environmentObject(FirebaseManager(gameRooms: []))
    }
}
