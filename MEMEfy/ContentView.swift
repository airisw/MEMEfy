//
//  ContentView.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/26/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var loginManager: LoginManager
    
    var body: some View {
        VStack {
            Text("MEMEfy")
                .font(.title).bold()
            LoginForm()
                .environmentObject(loginManager)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(loginManager: LoginManager(gameRooms: []))
    }
}
