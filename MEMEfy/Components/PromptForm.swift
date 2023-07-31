//
//  PromptForm.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/27/23.
//

import SwiftUI

struct PromptForm: View {
    @EnvironmentObject var promptManager: PromptManager
    @State private var prompt: String = ""
    
    var body: some View {
        VStack {
            TextEditor(text: $prompt)
                .frame(height: 80)
                .background(.opacity(0.5))
                .cornerRadius(5)
                .padding()
            
            Button {
                print("\(prompt) submitted")
                promptManager.createPrompts(prompt: prompt)
                prompt = ""
            } label: {
                Text("Submit")
                    .padding()
                    .foregroundColor(.white)
            }
            .background(Color("Purple").cornerRadius(20))
            .shadow(color: .white, radius: 40, x: 5, y: 5)
            
            Spacer()
        }
    }
}

struct PromptForm_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            ZStack {
                Image("Wallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                
                PromptForm()
                    .environmentObject(PromptManager(prompts: []))
            }
        }
    }
}
