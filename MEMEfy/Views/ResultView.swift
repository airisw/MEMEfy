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
                        .environmentObject(promptManager)
                        .environmentObject(firebaseManager)
                    
                    HStack {
                        Button {
                            print("Next Round starting")
                        } label: {
                            Text("Next Round")
                                .padding()
                        }
                        
                        Button {
                            print("End of Game")
                        } label: {
                            Text("End Game")
                                .padding()
                        }
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
