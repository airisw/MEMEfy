//
//  VotingForm.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/31/23.
//

import SwiftUI
import Kingfisher

struct VotingForm: View {
    @EnvironmentObject var promptManager: PromptManager
    @EnvironmentObject var firebaseManager: FirebaseManager
    @State var selectedGifIndex: String?
    
    var body: some View {
        ScrollView {
            Text(promptManager.currentPrompt)
                .padding(.horizontal)
            
            ForEach(firebaseManager.submissions, id: \.self) { gifURL in
                if let submission = URL(string: gifURL) {
                    KFAnimatedImage(submission)
                        .scaledToFit()
                        .border(selectedGifIndex == gifURL ? Color.black : Color.clear, width: 5)
                        .onTapGesture {
                            if selectedGifIndex == gifURL {
                                selectedGifIndex = nil
                            } else {
                                selectedGifIndex = gifURL
                            }
                        }
                        .padding()
                }
            }
        }
        .onAppear {
            firebaseManager.fetchGifs(roomCode: firebaseManager.finalRoomCode)
        }
    }
}

struct VotingForm_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            ZStack {
                Image("Wallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                
                VotingForm()
                    .environmentObject(PromptManager(prompts: []))
                    .environmentObject(FirebaseManager(gameRooms: []))
            }
        }
    }
}
