//
//  AlarmView.swift
//  sleepz Watch App
//
//  Created by Ainley on 2/1/23.
//

import Foundation
import SwiftUI
import CoreData

/***
 For alarmList,
 - isActive (boolean)
 - startTime (integer)
 - endTime (integer)
 - durationRange (integer)
 - days (list of strings)
*/

struct AlarmHome: View {
    
//    @StateObject var currAlarmInfo = CurrentAlarmInfo()
    let coreDM: PersistentController
    
//    @FetchRequest (
//        entity: AlarmInfo.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \AlarmInfo.dateAdded, ascending: false)]
//    )
//
    @State private var alarms: [AlarmInfo] = [AlarmInfo]()
    
    private func populateAlarms() {
        alarms = coreDM.getAllAlarms()
    }
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($alarms, id: \.self) { $alarm in
                    
                    let alarmDetails = dateFormatter(dataObject: alarm)

                    HStack {
                        NavigationLink(
                            destination: AlarmEditStartTimeView(alarm: $alarm),
                            label: {
                                Text(alarmDetails.startTime + " - " + alarmDetails.endTime)
                            }
                        )
                    }
                }
                NavigationLink(
                    destination: AlarmStartTimeView(),
                    label: {
                        Text("New Alarms")
                    }
                )
                
            }
            .overlay(
                Text(alarms.isEmpty ? "No alarms set" : "")
            )
            .navigationTitle("My alarms")
            .navigationBarBackButtonHidden(true)
        }.onAppear(perform: {
            populateAlarms()
        })
    }
//    func currState(dataObject: AlarmInfo) -> [(Int,Int,String)] {
//
//        let startHourTime = Int(dataObject.startHour)
//        let startMinuteTime = Int(dataObject.startMinute)
//        let startMeridiemTime = dataObject.startMeridiem!
//
//        let endHourTime = Int(dataObject.endHour)
//        let endMinuteTime = Int(dataObject.endMinute)
//        let endMeridiemTime = dataObject.endMeridiem!
//
//
//        return [(startHourTime, startMinuteTime, startMeridiemTime), (endHourTime, endMinuteTime, endMeridiemTime)]
//    }
    
    func dateFormatter(dataObject: AlarmInfo) -> (startTime: String, endTime: String) {
        
        let startHourTime = "\(dataObject.startHour)"
        let startMinuteTime = dataObject.startMinute >= 10 ? "\(dataObject.startMinute)" : "0" + "\(dataObject.startMinute)"

        let endHourTime = "\(dataObject.endHour)"
        let endMinuteTime = dataObject.endMinute >= 10 ? "\(dataObject.endMinute)" : "0" + "\(dataObject.endMinute)"
        
        
        return (startHourTime + ":" + startMinuteTime, endHourTime + ":" + endMinuteTime)
    }
}

final class CurrentAlarmInfo: ObservableObject {
    @Published var currStartHour: Int = 0
    @Published var currStartMinute: Int = 0
    @Published var currStartMeridiem: String = ""

    @Published var currEndHour: Int = 0
    @Published var currEndMinute: Int = 0
    @Published var currEndMeridiem: String = ""
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

//struct AlarmDayView: View {
//    var body: some View {
//        Text("Set schedule")
//        GreenButton(content: {AlarmHome(coreDM: PersistentController())})
//    }
//}

struct AlarmHome_Previews: PreviewProvider {
    static var previews: some View {
        AlarmHome(coreDM: PersistentController())
    }
}



