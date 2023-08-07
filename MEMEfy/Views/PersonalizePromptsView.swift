//
//  PersonalizePromptsView.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/27/23.
//

import SwiftUI

struct PersonalizePromptsView: View {
    @EnvironmentObject var firebaseManager: FirebaseManager
    @StateObject var promptManager: PromptManager
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
                    CountdownTimer(countdownFinished: $countdownFinished)
                        .environmentObject(firebaseManager)
                        .padding()
                        .navigationDestination(isPresented: $countdownFinished) {
                            RoundPlayerView()
                                .environmentObject(promptManager)
                                .navigationBarBackButtonHidden(true)
                        }
                    
                    VStack {
                        Text("Submit your own prompts")
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 25, x: 5, y: 5)
                        
                        PromptForm()
                            .environmentObject(promptManager)
                    }
                }
            }
        }
    }
}

struct PersonalizePromptsView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalizePromptsView(promptManager: PromptManager(prompts: []))
            .environmentObject(FirebaseManager(gameRooms: []))
    }
}
