//
//  ContentView.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/26/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var loginManager: LoginManager
    @State private var isJoinRoomTapped = false
    
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
                        Text("MEMEfy")
                            .font(.title).bold()
                            .foregroundColor(Color("Purple"))
                            .shadow(color: .white, radius: 10, x: 5, y: 5)

                        LoginForm(isJoinRoomTapped: $isJoinRoomTapped)
                            .environmentObject(loginManager)
                            .navigationDestination(isPresented: $isJoinRoomTapped) { WaitingRoomView()
                                    .navigationBarBackButtonHidden(true)
                            }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        ContentView(loginManager: LoginManager(gameRooms: []))
        let manager = MockLoginManager(gameRooms: [])
        ContentView(loginManager: manager)
    }
}
