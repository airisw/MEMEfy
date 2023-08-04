//
//  RoundPlayerView.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/27/23.
//

import SwiftUI

struct RoundPlayerView: View {
    @EnvironmentObject var promptManager: PromptManager
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("Wallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                
                VStack {
                    Text("<timer>")
                        .font(.title)
                        .padding(.vertical)
                    
                    Text(promptManager.currentPrompt)
                    
                    SearchForm()
                }
            }
        }
    }
}

struct RoundPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        RoundPlayerView()
    }
}
