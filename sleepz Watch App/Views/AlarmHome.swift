//
//  AlarmView.swift
//  sleepz Watch App
//
//  Created by Ainley on 2/1/23.
//

import Foundation
import SwiftUI
import CoreData
import HealthKit

/***
 For alarmList,
 - isActive (boolean)
 - startTime (integer)
 - endTime (integer)
 - durationRange (integer)
 - days (list of strings)
*/




struct AlarmHome: View {
    
    let coreDM: PersistentController
    
    @State private var alarms: [AlarmInfo] = [AlarmInfo]()
    @State private var showSessionView: Bool = false
    @State private var currentDate = Date()

        
    private func populateAlarms() {
        alarms = coreDM.getAllAlarms()
    }
    
    private func setupTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.currentDate = Date()
        }
    }
    
    private func checkAlarmTime() {
        for alarm in alarms {
            if isWithinActiveAlarmTime(dataObject: alarm) {
                self.showSessionView = true
                break
            } else {
                self.showSessionView = false
            }
        }
    }
    
    private func isWithinActiveAlarmTime(dataObject: AlarmInfo) -> Bool {
        let currentDateTime = Date()
        let calendar = Calendar.current
        
        let currentHour = calendar.component(.hour, from: currentDateTime)
        let currentMinute = calendar.component(.minute, from: currentDateTime)
        
        let currentTotalMinutes = currentHour * 60 + currentMinute
        let startTotalMinutes = dataObject.startHour * 60 + dataObject.startMinute
        let endTotalMinutes = dataObject.endHour * 60 + dataObject.endMinute
        
        if dataObject.isActive && currentTotalMinutes >= startTotalMinutes && currentTotalMinutes <= endTotalMinutes {
            return true
        }
        
        return false
    }
    
    var body: some View {
        VStack{
            List {
                ForEach($alarms, id: \.self) { $alarm in
                    let formattedAlarm = dateFormatter(dataObject: alarm)
                    let formattedTimeDif = timeDifCalc(dataObject: alarm)
                    let alarmId = alarm.objectID
                    
                    let alarmObject = coreDM.getAlarm(alarmId: alarmId)
                    let alarmBinding = Binding(
                        get: { alarmObject.value(forKey: "isActive") as! Bool },
                        set: {
                            alarmObject.setValue($0, forKey: "isActive")
                            
                            coreDM.save()
                            populateAlarms()
                        }
                    )

                    HStack {
                        NavigationLink(
                            destination: AlarmEditStartTimeView(alarm: $alarm, alarmId: alarmId),
                            label: {
                                VStack(spacing: 4) {
                                    Text(formattedAlarm.startTime + " - " + formattedAlarm.endTime).frame(width: 120, alignment: .leading)
                                    Text(formattedTimeDif + " min window").frame(width: 120, alignment: .leading).opacity(0.4).font(.system(size: 14))
                                }
                            }
                        )
                        Toggle(isOn: alarmBinding) {
                            EmptyView()
                        }

                    }
                    .navigationTitle("My alarms")
                    .navigationBarBackButtonHidden(true)
                    
                }.onDelete(perform: { indexSet in
                    indexSet.forEach { index in
                        let alarm = alarms[index]
                        
                        // delete it using Core Data Manager
                        coreDM.deleteAlarm(alarm: alarm)
                        populateAlarms()
                    }
                });
            }
            
            .overlay(
                Text(alarms.isEmpty ? "No alarms set" : "")
            )
        
            if (alarms.count < 3) {
                NavigationLink(
                    destination: AlarmCreate(),
                    label: {
                        Text("New Alarms")
                        }
                ).accessibilityIdentifier("createAlarmButton")
            }
            
        }
        .onAppear(perform: {
            populateAlarms()
            setupTimer()
        })
        .onChange(of: currentDate, perform: { _ in
            checkAlarmTime()
        })
        .sheet(isPresented: $showSessionView) {
            StartSession(alarmStartTime: Date())
        }
        
    }
    
    func dateFormatter(dataObject: AlarmInfo) -> (startTime: String, endTime: String) {
        
        let startHourTime = "\(dataObject.startHour)"
        let startMinuteTime = dataObject.startMinute >= 10 ? "\(dataObject.startMinute)" : "0" + "\(dataObject.startMinute)"
        let startMeridiem = dataObject.startMeridiem ?? ""

        let endHourTime = "\(dataObject.endHour)"
        let endMinuteTime = dataObject.endMinute >= 10 ? "\(dataObject.endMinute)" : "0" + "\(dataObject.endMinute)"
        let endMeridiem = dataObject.endMeridiem ?? ""

        
        return (startHourTime + ":" + startMinuteTime, endHourTime + ":" + endMinuteTime + endMeridiem)
    }
    
    func timeDifCalc(dataObject: AlarmInfo) -> String {
        
        var startMin = dataObject.startHour * 60 + dataObject.startMinute
        var endMin = dataObject.endHour * 60 + dataObject.endMinute

        if (dataObject.startMeridiem == "pm") {
            startMin += 12 * 60
            endMin += 12 * 60
        }
        
        let minuteDif = endMin - startMin

        return ("\(minuteDif)")
    }
    
}

final class CurrentAlarmInfo: ObservableObject {
    @Published var currStartHour: Int = 1
    @Published var currStartMinute: Int = 0
    @Published var currStartMeridiem: String = "am"

    @Published var currEndHour: Int = 1
    @Published var currEndMinute: Int = 0
    @Published var currEndMeridiem: String = "am"
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



