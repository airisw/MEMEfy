//
//  PersonalizePromptsView.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/27/23.
//

import SwiftUI

struct PersonalizePromptsView: View {
    @StateObject var promptManager: PromptManager
    @State private var isBeginRoundTapped = false
    
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
                    
                    VStack {
                        Text("Submit your own prompts")
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 25, x: 5, y: 5)
                        
                        PromptForm()
                            .environmentObject(promptManager)
                    }
                    
                    Button {
                        print("Begin Round button tapped")
                        promptManager.getRandomPrompt()
                        isBeginRoundTapped = true
                    } label: {
                        Text("Begin Round")
                            .padding()
                    }
                    .navigationDestination(isPresented: $isBeginRoundTapped) {
                        RoundPlayerView()
                            .environmentObject(promptManager)
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

struct PersonalizePromptsView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalizePromptsView(promptManager: PromptManager(prompts: []))
    }
}
