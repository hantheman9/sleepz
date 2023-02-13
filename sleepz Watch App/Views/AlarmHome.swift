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
    
    @FetchRequest (
        entity: AlarmInfo.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \AlarmInfo.dateAdded, ascending: false)]
    )

    var results: FetchedResults<AlarmInfo>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(results) { item in
                    
                    let alarmDetails = dateFormatter(dataObject: item)

                    HStack {
                        NavigationLink(
                            destination: Text(alarmDetails.startTime + " - " + alarmDetails.endTime),
                            label: {
                                Text(alarmDetails.startTime + " - " + alarmDetails.endTime)
                            }
                        )
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
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
                Text(results.isEmpty ? "No alarms set" : "")
            )
            .navigationTitle("My alarms")
            .navigationBarBackButtonHidden(true)
        }
    }
    
    func dateFormatter(dataObject: AlarmInfo) -> (startTime: String, endTime: String) {
        
        let startHourTime = "\(dataObject.startHour)"
        let startMinuteTime = dataObject.startMinute >= 10 ? "\(dataObject.startMinute)" : "0" + "\(dataObject.startMinute)"

        let endHourTime = "\(dataObject.endHour)"
        let endMinuteTime = dataObject.endMinute >= 10 ? "\(dataObject.endMinute)" : "0" + "\(dataObject.endMinute)"
        
        
        return (startHourTime + ":" + startMinuteTime, endHourTime + ":" + endMinuteTime)
    }
}

struct AlarmStartTimeView: View {
    @EnvironmentObject var alarmObject: AlarmInfo
    
    var body: some View {
        Text("Set wake up window start")
        TimePickerView(nextContent: {AlarmEndTimeView()})
//            OrangeButton(content: {AlarmEndTimeView()})
    }
}

struct AlarmEndTimeView: View {
    @EnvironmentObject var alarmObject: AlarmInfo

    var body: some View {
        Text("Set wake up window end")
        TimePickerView(nextContent: {AlarmHome()}, isStart: false)
//        OrangeButton(content: {AlarmEndTimeView()})
    }
}

struct AlarmDayView: View {
    var body: some View {
        Text("Set schedule")
        GreenButton(content: {AlarmHome()})
        
    }
}

struct AlarmHome_Previews: PreviewProvider {
    static var previews: some View {
        AlarmHome()
    }
}




