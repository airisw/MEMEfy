//
//  LoginForm.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/26/23.
//

import SwiftUI

struct LoginForm: View {
    @State private var name = ""
    @State private var roomCode = ""
    
    var body: some View {
        Form {
            TextField("name", text: $name)
                .disableAutocorrection(true)
            TextField("room code", text: $roomCode)
                .disableAutocorrection(true)
            
            Button(action: {
                print("Form submitted with \(name) and \(roomCode)")
            }) {
                Text("Join Room")
            }
        }
    }
}

struct LoginForm_Previews: PreviewProvider {
    static var previews: some View {
        LoginForm()
    }
}
