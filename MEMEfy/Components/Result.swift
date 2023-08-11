//
//  RoundResults.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/31/23.
//

import SwiftUI
import Kingfisher

struct Result: View {
    @EnvironmentObject var promptManager: PromptManager
    @EnvironmentObject var firebaseManager: FirebaseManager
    var selectedGif: String?
    
    var body: some View {
        VStack {
            Text(promptManager.currentPrompt)
                .padding(.vertical)
            
            Text("\(firebaseManager.winnerId) +1 pt")
                .padding(.vertical)
            
            if let gifUrl = selectedGif, let url = URL(string: gifUrl) {
                KFAnimatedImage(url)
                    .scaledToFit()
                    .scaleEffect(0.8)
            }
        }
    }
}

struct Result_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            ZStack {
                Image("Wallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                
                Result()
                    .environmentObject(PromptManager(prompts: []))
                    .environmentObject(FirebaseManager(gameRooms: []))
            }
        }
    }
}
