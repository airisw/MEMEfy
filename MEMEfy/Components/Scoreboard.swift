//
//  Scoreboard.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/31/23.
//

import SwiftUI

struct Scoreboard: View {
    @EnvironmentObject var firebaseManager: FirebaseManager
    @State private var scoresLoaded = false
    
    var body: some View {
        VStack {
            Text("Scoreboard:")
                .font(.title2)
            
            ForEach(firebaseManager.players) { player in
                Text("\(player.name) \(player.totalScore)")
            }
        }
    }
}

struct Scoreboard_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            ZStack {
                Image("Wallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                
                Scoreboard()
                    .environmentObject(FirebaseManager(gameRooms: []))
            }
        }
    }
}
