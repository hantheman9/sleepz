//
//  AlarmCreate.swift
//  sleepz Watch App
//
//  Created by Erin Ly on 2023-03-02.
//

import Foundation
import SwiftUI
import CoreData
import UserNotifications

struct AlarmCreate: View {
    var body: some View {
        AlarmStartTimeView()
    }
}

struct AlarmStartTimeView: View {
    @State var currAlarmInfo = CurrentAlarmInfo()
    
    var body: some View {
        VStack{
            Text("Set wake up window end")
            TimePickerView(currAlarmInfo: $currAlarmInfo, isStart: true)
            OrangeButton(content: {AlarmEndTimeView(currAlarmInfo: $currAlarmInfo)}, action: {})
        }
//        OrangeButton(content: {AlarmEndTimeView()})
    }
}

struct AlarmEndTimeView: View {
    @Binding var currAlarmInfo: CurrentAlarmInfo
    let coreDM = PersistentController()
    
    var body: some View {
        Text("Set wake up window end")
        TimePickerView(currAlarmInfo: $currAlarmInfo, isStart: false)
        OrangeButton(content: {AlarmHome(coreDM: coreDM)}, action: {
            coreDM.saveAlarm(currAlarm: currAlarmInfo)
        })
//        OrangeButton(content: {AlarmEndTimeView()})
    }
}

struct AlarmCreate_Previews: PreviewProvider {
    static var previews: some View {
        AlarmCreate()
    }
}

// THROWAWAY CODE
//// request permission to the user to allow us to send notifications
//UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
//    if success {
//        print("All set!")
//    } else if let error = error {
//        print(error.localizedDescription)
//    }
//}
//
//// create notification content
//let content = UNMutableNotificationContent()
//content.title = "Feed the cat"
//content.subtitle = "It looks hungry"
//content.sound = UNNotificationSound.default
//
//// create the trigger of this notification using the end time
//let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//
//// choose a random identifier
//let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//// add our notification request
//UNUserNotificationCenter.current().add(request)
