//
//  MEMEfyApp.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/26/23.
//

import SwiftUI
import Firebase

@main
struct MEMEfyApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(firebaseManager: FirebaseManager(gameRooms: []))
        }
    }
}
