//
//  RoundResults.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/31/23.
//

import SwiftUI

struct RoundResults: View {
    var body: some View {
        VStack {
            Text("<prompt>")
                .padding(.vertical)
            
            Text("<player> +1 pt")
                .padding(.vertical)
            
            AsyncImage(url: URL(string: "https://media0.giphy.com/media/SKGo6OYe24EBG/giphy.gif"))
        }
    }
}

struct RoundResults_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            ZStack {
                Image("Wallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                
                RoundResults()
            }
        }
    }
}
