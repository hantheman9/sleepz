//
//  sleepz Watch App
//
//  Created by Ainley on 2/22/23.
//
//
import SwiftUI

struct HapticsView: View {

    @EnvironmentObject private var extensionDelegate: ExtensionDelegate
    @State private var alarmIsActive = false


    var body: some View {
        VStack {
            Text("Alarm is \(alarmStateString())")
                .padding()
            Button(action: {
                self.alarmIsActive = true
                if self.alarmIsActive {
                    extensionDelegate.setupSession()
                    extensionDelegate.scheduleAlarm()
                }
            }) {
                Text("Start Alarm")
            }
            Button(action: {
                self.alarmIsActive = false
                extensionDelegate.stopSession()
            }) {
                Text("Stop Alarm")
            }
        }
    }

    func alarmStateString() -> String {
        if self.alarmIsActive {
            return "On"
        }
        return "Off"
    }
}


struct HapticsView_Previews: PreviewProvider {
    static var previews: some View {
        HapticsView()
    }
}
