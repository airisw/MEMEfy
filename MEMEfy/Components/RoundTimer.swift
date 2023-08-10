//
//  RoundTimer.swift
//  MEMEfy
//
//  Created by Airis Wang on 8/10/23.
//

import SwiftUI

struct RoundTimer: View {
    @Binding var countdownFinished: Bool
    @EnvironmentObject var firebaseManager: FirebaseManager
    @State var nowDate = Date()
    var referenceDate: Date {
            firebaseManager.modifiedRoundStart
        }
    let calendar = Calendar(identifier: .gregorian)
    
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.nowDate = Date()
 
            if referenceDate <= nowDate {
                countdownFinished = true
                self.timer.invalidate()
            }
        }
    }
    
    var body: some View {
            HStack {
                Image(systemName: "clock.fill")
                    .font(.title)
                    .foregroundColor(Color("Purple"))
                
                Text(countdownString(from: referenceDate, until: nowDate))
                    .font(.title)
                    .onAppear(perform: {
                        let _ = self.timer
                    })
            }
    }
    
    func countdownString(from date: Date, until nowDate: Date) -> String {
        let components = calendar.dateComponents([.second], from: nowDate, to: date)

        return String(format: "%d", components.second ?? 00)
    }
}

struct RoundTimer_Previews: PreviewProvider {
    @State static var countdownFinished = false
    
    static var previews: some View {
        GeometryReader { geo in
            ZStack {
                Image("Wallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                
                RoundTimer(countdownFinished: $countdownFinished)
                    .environmentObject(FirebaseManager(gameRooms: []))
            }
        }
    }
}
