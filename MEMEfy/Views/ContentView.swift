//
//  ContentView.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/26/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var firebaseManager: FirebaseManager
    @State private var isJoinRoomTapped = false
    @State private var finalRoomCode: String = ""
    
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

                        LoginForm(isJoinRoomTapped: $isJoinRoomTapped, finalRoomCode: $finalRoomCode)
                            .environmentObject(firebaseManager)
                            .navigationDestination(isPresented: $isJoinRoomTapped) { WaitingRoomView(finalRoomCode: finalRoomCode).environmentObject(firebaseManager)
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
        let manager = MockFirebaseManager(gameRooms: [])
        ContentView(firebaseManager: manager)
    }
}
