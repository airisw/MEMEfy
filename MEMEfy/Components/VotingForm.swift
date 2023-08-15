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
    @State var selectedGif: String?
    @State private var isChooseWinnerTapped = false
    
    var body: some View {
        ScrollView {
            Button {
                firebaseManager.fetchWinnerId(roomCode: firebaseManager.finalRoomCode, winnerGIF: selectedGif) {
                    firebaseManager.updateWinner(roomCode: firebaseManager.finalRoomCode, winnerGIF: selectedGif)
                    
                    firebaseManager.scorePoint(roomCode: firebaseManager.finalRoomCode)
                }
                print("winner updated")
                isChooseWinnerTapped = true
            } label: {
                Text("Choose winner")
            }
            .navigationDestination(isPresented: $isChooseWinnerTapped) {
                ResultView(selectedGif: selectedGif)
                    .environmentObject(promptManager)
                    .environmentObject(firebaseManager)
                    .navigationBarBackButtonHidden(true)
            }
            
            ForEach(firebaseManager.submissions, id: \.self) { gifURL in
                if let submission = URL(string: gifURL) {
                    KFAnimatedImage(submission)
                        .scaledToFit()
                        .border(selectedGif == gifURL ? Color.black : Color.clear, width: 5)
                        .onTapGesture {
                            if selectedGif == gifURL {
                                selectedGif = nil
                            } else {
                                selectedGif = gifURL
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
