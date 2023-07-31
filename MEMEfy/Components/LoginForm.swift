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
    @Binding var isJoinRoomTapped: Bool
    
    var body: some View {
        VStack {
            TextField("name", text: $name)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                .background(Color.white.opacity(0.7).cornerRadius(20))
            
            TextField("room code", text: $roomCode)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                .background(Color.white.opacity(0.7).cornerRadius(20))
            
            Button {
                print("Form submitted with \(name) and \(roomCode)")
                loginManager.startGame(name: name, roomCode: roomCode)
                name = ""
                roomCode = ""
                isJoinRoomTapped = true
            } label: {
                Text("Join Room")
                    .padding()
                    .foregroundColor(Color("Purple"))
            }
            .background(Color("Pink").opacity(0.7).cornerRadius(20))
            .padding()
        }
        .padding(.horizontal)
    }
}

struct LoginForm_Previews: PreviewProvider {
    @State static var isJoinRoomTapped = false
    
    static var previews: some View {
        GeometryReader { geo in
            ZStack {
                Image("Wallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                
                LoginForm(isJoinRoomTapped: $isJoinRoomTapped)
                    .environmentObject(LoginManager(gameRooms: []))
            }
        }
    }
}
