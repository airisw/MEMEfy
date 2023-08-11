//
//  VotingPlayerView.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/27/23.
//

import SwiftUI

struct VotingPlayerView: View {
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
                    Text("Voting Time")
                        .font(.title)
                    
//                    Text("<timer>")
//                        .font(.title)
//                        .padding(.vertical)
                    
                    // render ResultView
                    
                    Text("Waiting for \(firebaseManager.currentJudgeID) to vote")
                        .font(.title2)
                    
                    Spacer()
                }
                .padding(.top, 70)
            }
        }
    }
}

struct VotingPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VotingPlayerView()
            .environmentObject(FirebaseManager(gameRooms: []))
    }
}
