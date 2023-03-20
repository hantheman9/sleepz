//
//  Scheduler.swift
//  sleepz Watch App
//
//  Created by Erin Ly on 2023-02-22.
//

import Foundation
import SwiftUI


//struct Scheduler: View {
//
//    let coreDM: PersistentController
//    @State private var alarms: [AlarmInfo] = [AlarmInfo]()
//
//    final class ScheduledAlarmInfo: ObservableObject {
//        @Published var startHour: Int = 0
//        @Published var startMinute: Int = 0
//
//        @Published var endHour: Int = 0
//        @Published var endMinute: Int = 0
//    }
//
//    private func populateAlarms() {
//        alarms = coreDM.getAllAlarms()
//    }
//
//    var body: some View {
////        let alarmDetails = date(dataObject: alarm)
//
//        let components
//        Text(dateComponents)
//
//        List {
//            ForEach($alarms, id: \.self) { $alarm in
//                let alarmDetails = dateFormatter(dataObject: alarm)
//
//                HStack {
//                    NavigationLink(
//                        destination: AlarmEditStartTimeView(alarm: $alarm),
//                        label: {
//                            Text(alarmDetails.startTime + " - " + alarmDetails.endTime)
//                        }
//                    ).frame(width: 100)
//
//                    Toggle(isOn: $alarm.isActive) {
//                        EmptyView()
//                    }.onChange(of: alarm.isActive){_ in
//                        print("toggle")
//                        print(alarm.isActive)
//                    }
//                }
//
//            }
//        }
//
////        Text(Date.now, format: .dateTime.day().month().year())
//    }
//
//    func getDate() {
//        var dateComponents = DateComponents()
//        dateComponents.calendar = Calendar.current
//
//        dateComponents.weekday = 3  // Tuesday
//        dateComponents.hour = 14    // 14:00 hours
//
//        // Create the trigger as a repeating event.
////        let trigger = UNCalendarNotificationTrigger(
////                 dateMatching: dateComponents, repeats: true)
//
////        let currDate = Calendar.current.date(from: components) ?? Date.now
//    }
//
//}
//
//struct Scheduler_Previews: PreviewProvider {
//    static var previews: some View {
//        Scheduler(coreDM: PersistentController())
//    }
//}



