//
//  WaitingRoomView.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/27/23.
//

import SwiftUI

struct WaitingRoomView: View {
    @State private var isStartGameTapped = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    Image("Wallpaper")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    
                    VStack {
                        Text("<room code>")
                            .font(.title)
                            .padding(.vertical)
                        
                        VStack(alignment: .leading) {
                            Text("Waiting for players...")
                                .padding(.horizontal)
                            
                            VStack {
                                Text("<player 1>")
                                Text("<player 2>")
                                Text("<player 3>")
                                Text("<player 4>")
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        
                        Button {
                            print("Start Game button tapped")
                            isStartGameTapped = true
                        } label: {
                            Text("Start Game")
                                .padding()
                        }
                        .navigationDestination(isPresented: $isStartGameTapped) {
                            PersonalizePromptsView(promptManager: PromptManager(prompts: []))
                                .navigationBarBackButtonHidden(true)
                        }
                        .background(Color("Purple"))
                        .foregroundColor(.white)
                        .cornerRadius(30)
                        .shadow(color: .white, radius: 10, x: 5, y: 5)
                        
                    }
                }
            }
        }
    }
}

struct WaitingRoomView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingRoomView()
    }
}
