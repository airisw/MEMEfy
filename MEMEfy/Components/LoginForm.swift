//
//  LoginForm.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/26/23.
//

import SwiftUI

struct LoginForm: View {
    @EnvironmentObject var loginManager: LoginManager
    @State private var name = ""
    @State private var roomCode = ""
    
    var body: some View {
        VStack {
            TextField("name", text: $name)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                .background(Color.white.opacity(0.3).cornerRadius(20))
                .foregroundColor(.white)
            
            TextField("room code", text: $roomCode)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                .background(Color.white.opacity(0.3).cornerRadius(20))
                .foregroundColor(.white)
            
            Button {
                print("Form submitted with \(name) and \(roomCode)")
                loginManager.startGame(name: name, roomCode: roomCode)
                name = ""
                roomCode = ""
            } label: {
                Text("Join Room")
                    .padding()
                    .foregroundColor(Color("Purple"))
            }
            .background(Color("Pink").opacity(0.5).cornerRadius(20))
            .padding()
        }
        .padding(.horizontal)
    }
}

struct LoginForm_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            ZStack {
                Image("Wallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                
                LoginForm()
                    .environmentObject(LoginManager(gameRooms: []))
            }
        }
    }
}
